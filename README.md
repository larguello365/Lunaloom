# 🌙 Lunaloom - Sleep Tracking & Social Wellness App

A comprehensive iOS and watchOS application that gamifies sleep tracking through a virtual pet companion, promoting better sleep habits and social wellness connections.

## 📱 Overview

Lunaloom is a native iOS application that combines sleep tracking, social features, and gamification to help users maintain healthy sleep patterns. Users care for their virtual owl companion "Nyxie" by maintaining good sleep habits, earning rewards that can be shared with friends.

## ✨ Key Features

### 🦉 Virtual Pet Companion
- **Interactive Owl (Nyxie)**: A charming virtual pet whose mood reflects your sleep quality
- **Mood System**: Dynamic mood gauge that increases when fed seeds
- **Feeding Mechanic**: Use earned seeds to improve Nyxie's happiness

### 😴 Sleep Tracking & Visualization
- **Comprehensive Sleep Analysis**: Tracks REM, Core, and Deep sleep stages
- **7-Day Chart View**: Visual representation of sleep patterns using Swift Charts
- **Color-Coded Data**: Intuitive display with REM (red), Core (yellow), and Deep (blue) sleep stages
- **Real-time Data Sync**: Seamless integration with Firebase for data persistence

### ⌚ watchOS Companion App
- **Native watchOS Support**: Dedicated Apple Watch app for convenient sleep tracking
- **HealthKit Integration**: Direct access to sleep data from Apple Health
- **Start/Stop Tracking**: Simple interface for initiating sleep sessions
- **Background Sync**: Automatic data synchronization with the main app

### 👥 Social Features
- **Friend System**: Connect with other users to build a sleep wellness community
- **Seed Gifting**: Share seeds with friends to help their Nyxie
- **Friend Discovery**: Find and add new friends within the app
- **Real-time Updates**: Firestore-powered instant synchronization

### 📚 Educational Content
- **Sleep Articles**: Curated content about sleep health and wellness
- **Image-Rich Articles**: Visual learning with integrated images
- **Knowledge Base**: Built-in articles stored in plist for offline access

## 🛠 Technical Stack

### Core Technologies
- **SwiftUI**: Modern declarative UI framework for all views
- **Firebase**: Complete backend solution
  - Firebase Auth for user authentication
  - Cloud Firestore for real-time database
  - Firebase Analytics for user insights
- **HealthKit**: Sleep data collection from Apple Health
- **Swift Charts**: Native charting for sleep visualization
- **Combine Framework**: Reactive programming for data flow

### Architecture Highlights
- **MVVM Pattern**: Clean separation of concerns with ViewModels
- **Environment Objects**: Efficient state management across views
- **Custom Components**: Reusable UI elements (RatingOverlay, Friend Rows)
- **App Groups**: Data sharing between iOS and watchOS apps

### Project Structure
```
Lunaloom/
├── Models/
│   ├── Sleep.swift         # Sleep data model with Codable support
│   ├── Social.swift        # Social features and friend management
│   ├── Article.swift       # Educational content model
│   └── ArticleViewModel.swift
├── Views/
│   ├── MainTabView.swift   # Tab navigation controller
│   ├── HomeView.swift      # Main dashboard with Nyxie
│   ├── SleepTrackingView.swift # Charts and sleep analytics
│   ├── FriendsView.swift   # Social features interface
│   └── SettingsView.swift  # User preferences
├── LunaLoomWatchOS/        # Complete watchOS app
└── Resources/              # Assets, plists, and configurations
```

## 🎯 iOS Development Showcase

### Advanced SwiftUI Implementation
- Custom gradients and visual effects
- Responsive layouts for all device sizes
- Smooth animations and transitions
- Dark theme with blue/black gradient design

### Firebase Integration
- Real-time data synchronization
- User authentication flow
- Firestore queries with proper error handling
- Transaction support for atomic operations (seed gifting)

### Data Management
- UserDefaults for local preferences
- App Groups for iOS/watchOS communication
- Firestore for cloud persistence
- HealthKit for health data access

### Code Quality
- Clean, maintainable Swift code
- Proper error handling throughout
- Consistent naming conventions
- Modular, reusable components

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- watchOS 10.0+ for companion app
- Firebase project configuration

### Installation
1. Clone the repository
2. Open `Lunaloom.xcodeproj` in Xcode
3. Add your `GoogleService-Info.plist` for Firebase
4. Configure App Groups for watchOS communication
5. Build and run on simulator or device