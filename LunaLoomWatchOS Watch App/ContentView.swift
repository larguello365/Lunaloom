//
//  ContentView.swift
//  LunaLoomWatchOS Watch App
//
//  Created by Lester Arguello on 6/1/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var isTracking = false
    @State private var startDate: Date?
    @State private var healthStore = HKHealthStore()
    @State private var errorMessage: String?
    
    private let sleepType = HKObjectType.categoryType(
        forIdentifier: .sleepAnalysis
    )!
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Sleep Tracker")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption2)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    isTracking ? stopTracking() : startTracking()
                }) {
                    Text(isTracking ? "Stop Tracking" : "Start Tracking")
                        .font(.title3).bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isTracking ? Color.red : Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            requestHealthKitAuthorization()
        }
    }
    
    private func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "Health data not available."
            return
        }
        
        let typesToRead: Set = [sleepType]
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "HK Auth Error: \(error.localizedDescription)"
                }
            }
            if !success {
                DispatchQueue.main.async {
                    errorMessage = "HealthKit authorization denied."
                }
            }
        }
    }
    
    private func startTracking() {
        startDate = Date()
        errorMessage = nil
        isTracking = true
    }
    
    private func stopTracking() {
        guard let start = startDate else {
            errorMessage = "Start date missing."
            return
        }
        let end = Date()
        isTracking = false
        
        fetchSleepData(from: start, to: end) { remMinutes, coreMinutes, deepMinutes in
            let groupDefaults = UserDefaults(suiteName: "group.Lunaloom")
            let todayKey = isoDateString(from: Date())
            
            guard let userId = groupDefaults?.string(forKey: "userId") else {
                errorMessage = "No userId found in shared defaults."
                return
            }
            
            let remKey   = "\(userId)_\(todayKey)_rem"
            let coreKey  = "\(userId)_\(todayKey)_core"
            let deepKey  = "\(userId)_\(todayKey)_deep"
            let dateKey  = "\(userId)_lastSleepDate"
            
            groupDefaults?.set(remMinutes, forKey: remKey)
            groupDefaults?.set(coreMinutes, forKey: coreKey)
            groupDefaults?.set(deepMinutes, forKey: deepKey)
            groupDefaults?.set(todayKey, forKey: dateKey)
        }
    }
    
    private func fetchSleepData(
        from start: Date,
        to end: Date,
        completion: @escaping (_ rem: Int, _ core: Int, _ deep: Int) -> Void
    ) {
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: []
        )
        
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: true
        )
        
        let sampleQuery = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, results, error in
            guard error == nil, let categories = results as? [HKCategorySample] else {
                DispatchQueue.main.async {
                    self.errorMessage = "Sleep query failed: \(error?.localizedDescription ?? "unknown")"
                }
                return
            }
            
            var remMinutes  = 0
            var coreMinutes = 0
            var deepMinutes = 0
            
            for sample in categories {
                let value = sample.value
                let duration = Int(sample.endDate.timeIntervalSince(sample.startDate) / 60)
                switch value {
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    remMinutes += duration
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    coreMinutes += duration
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    deepMinutes += duration
                default:
                    break
                }
            }
            
            DispatchQueue.main.async {
                completion(remMinutes, coreMinutes, deepMinutes)
            }
        }
        
        healthStore.execute(sampleQuery)
    }
    
    private func isoDateString(from date: Date) -> String {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
}

#Preview {
    ContentView()
}
