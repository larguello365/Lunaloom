//
//  SleepTrackingView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Charts

/*
 Chart view where users can see their sleep data
 over the last week
 */

struct SleepChartData: Identifiable {
    let id = UUID()
    let dayLabel: String
    let rem: Double
    let core: Double
    let deep: Double
}

struct SleepTrackingView: View {
    @Environment(AuthController.self) private var authController

    @State private var chartData: [SleepChartData] = []
    @State private var errorMessage: String?
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Sleep (Last 7 Days)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)
                    .padding(.top)
                
                if !chartData.isEmpty {
                    Chart {
                        ForEach(chartData) { item in
                            // REM segment (bottom)
                            BarMark(
                                x: .value("Day", item.dayLabel),
                                yStart: .value("Start", 0),
                                yEnd: .value("End", item.rem)
                            )
                            .foregroundStyle(Color.red)
                            
                            // Core segment (middle)
                            BarMark(
                                x: .value("Day", item.dayLabel),
                                yStart: .value("Start", item.rem),
                                yEnd: .value("End", item.rem + item.core)
                            )
                            .foregroundStyle(Color.yellow)
                            
                            // Deep segment (top)
                            BarMark(
                                x: .value("Day", item.dayLabel),
                                yStart: .value("Start", item.rem + item.core),
                                yEnd: .value("End", item.rem + item.core + item.deep)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisValueLabel()
                                .foregroundStyle(Color.white)
                        }
                    }
                    .chartXAxis {
                        AxisMarks() { value in
                            AxisValueLabel()
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Loading…")
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
            }
        }
        .onAppear {
            loadSleepData()
        }
    }
    
    private func loadSleepData() {
            let userId = authController.userId
            
            let db = Firestore.firestore()
            let sleepCollection = db
                .collection("users")
                .document(userId)
                .collection("sleep")
            
            let today = Date()
            guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
                errorMessage = "Date calculation failed"
                return
            }
            let startOfSevenDaysAgo = calendar.startOfDay(for: sevenDaysAgo)
            
            sleepCollection
                .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfSevenDaysAgo))
                .getDocuments { snapshot, error in
                    if let error = error {
                        self.errorMessage = "Fetch error: \(error.localizedDescription)"
                        return
                    }
                    guard let docs = snapshot?.documents else {
                        self.errorMessage = "No sleep data"
                        return
                    }
                    
                
                    let sleeps: [Sleep] = docs.compactMap { doc in
                        try? doc.data(as: Sleep.self)
                    }
                    
                    var dailyDict: [Date: Sleep] = [:]
                    for sleep in sleeps {
                        let day = calendar.startOfDay(for: sleep.date)
                        dailyDict[day] = sleep
                    }
                    
                    var newData: [SleepChartData] = []
                    for offset in (0...6).reversed() {
                        guard let dayDate = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
                        let dayStart = calendar.startOfDay(for: dayDate)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "EEE"
                        let label = formatter.string(from: dayStart)
                        
                        if let sleep = dailyDict[dayStart] {
                            let remH   = Double(sleep.remTime) / 60.0
                            let coreH  = Double(sleep.coreSleepTime) / 60.0
                            let deepH  = Double(sleep.deepSleepTime) / 60.0
                            let entry = SleepChartData(
                                dayLabel: label,
                                rem: remH,
                                core: coreH,
                                deep: deepH
                            )
                            newData.append(entry)
                        } else {
                            // No data → zeros
                            let entry = SleepChartData(
                                dayLabel: label,
                                rem: 0,
                                core: 0,
                                deep: 0
                            )
                            newData.append(entry)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.chartData = newData
                    }
                }
        }
    
}

#Preview {
    SleepTrackingView()
}
