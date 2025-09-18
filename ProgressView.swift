//
//  ProgressView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//
import SwiftUI

struct ProgressView: View {
    // MARK: - State Variables for Screen Time Data (Now using sample data)
    @State private var currentWeekTime: TimeInterval = 72000    // 20 hours
    @State private var previousWeekTime: TimeInterval = 90000   // 25 hours
    @State private var currentMonthTime: TimeInterval = 324000  // 90 hours
    @State private var previousMonthTime: TimeInterval = 432000 // 120 hours
    @State private var isLoadingData = false
    @State private var hasError = false
    @State private var errorMessage = ""
    
    // Sample data for bar chart and content breakdown
    let weeklyScreenTime = [3.2, 4.1, 2.8, 4.5, 3.8, 3.0, 2.7]
    let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    let contentData = [
        ContentType(name: "Books", value: 25, color: .blue),
        ContentType(name: "Videos", value: 35, color: Color.blue.opacity(0.7)),
        ContentType(name: "Podcasts", value: 30, color: Color.blue.opacity(0.5)),
        ContentType(name: "Activities", value: 10, color: Color.blue.opacity(0.3))
    ]
    
    // Sample detailed screen time data
    let sampleScreenTimeData = [
        ScreenTimeEntry(app: "Safari", time: "2h 30m", category: "Productivity"),
        ScreenTimeEntry(app: "Instagram", time: "1h 45m", category: "Social"),
        ScreenTimeEntry(app: "YouTube", time: "3h 15m", category: "Entertainment"),
        ScreenTimeEntry(app: "Messages", time: "45m", category: "Social"),
        ScreenTimeEntry(app: "Spotify", time: "2h 10m", category: "Music")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Main Title
                Text("Track Your Progress")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // MARK: - Main Title
                Text("Screen Time Reduced")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // MARK: - Percentage Statistics
                HStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        Text(weeklyPercentageChange)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(weeklyChangeColor)
                        Text("This Week")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(monthlyPercentageChange)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(monthlyChangeColor)
                        Text("This Month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                
                
                // MARK: - Weekly Bar Chart
                VStack(alignment: .leading) {
                    Text("Weekly Screen Time")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                            if index < weeklyScreenTime.count {
                                VStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.blue)
                                        .frame(width: 24, height: CGFloat(weeklyScreenTime[index] * 20))
                                    Text(day)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 120)
                }
                
                // MARK: - Donut Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Content Consumed")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack {
                        ZStack {
                            ForEach(Array(contentData.enumerated()), id: \.offset) { index, item in
                                if let startAngle = safeStartAngle(for: index),
                                   let endAngle = safeEndAngle(for: index) {
                                    Circle()
                                        .trim(from: startAngle, to: endAngle)
                                        .stroke(item.color, lineWidth: 40)
                                        .rotationEffect(.degrees(-90))
                                }
                            }
                        }
                        .frame(width: 120, height: 80)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(contentData, id: \.name) { item in
                                HStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 12, height: 12)
                                    Text(item.name)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(item.value)%")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Streaks & Achievements
                VStack(alignment: .leading, spacing: 16) {
                    Text("Streaks & Achievements")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("8")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Day Streak")
                                .font(.headline)
                            Text("Reduced screen time goal met")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Time Reclaimed Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Time Reclaimed")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("This Week:")
                                .font(.headline)
                            Spacer()
                            Text(formatTimeInterval(previousWeekTime - currentWeekTime))
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("This Month:")
                                .font(.headline)
                            Spacer()
                            Text(formatTimeInterval(previousMonthTime - currentMonthTime))
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top)
        }
    }
    
    // MARK: - Computed Properties for Dynamic Percentages
    private var weeklyPercentageChange: String {
        let change = calculatePercentageChange(current: currentWeekTime, previous: previousWeekTime)
        return formatPercentage(change)
    }
    
    private var monthlyPercentageChange: String {
        let change = calculatePercentageChange(current: currentMonthTime, previous: previousMonthTime)
        return formatPercentage(change)
    }
    
    private var weeklyChangeColor: Color {
        let change = calculatePercentageChange(current: currentWeekTime, previous: previousWeekTime)
        return change < 0 ? .green : .red
    }
    
    private var monthlyChangeColor: Color {
        let change = calculatePercentageChange(current: currentMonthTime, previous: previousMonthTime)
        return change < 0 ? .green : .red
    }
    
    private func calculatePercentageChange(current: TimeInterval, previous: TimeInterval) -> Double {
        guard previous > 0 else { return 0 }
        return ((current - previous) / previous) * 100
    }
    
    private func formatPercentage(_ percentage: Double) -> String {
        let sign = percentage >= 0 ? "+" : ""
        return "\(sign)\(Int(percentage))%"
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    // MARK: - Error Handling
    private func retryDataLoad() {
        hasError = false
        errorMessage = ""
        simulateDataLoad()
    }
    
    // MARK: - Simulate Data Loading
    private func simulateDataLoad() {
        // Add a small delay to simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Data is already set in the state variables
            // This just adds a realistic loading feel
        }
    }
    
    // MARK: - Safe Donut Chart Helper Functions
    private func safeStartAngle(for index: Int) -> Double? {
        guard index >= 0 && index < contentData.count else { return nil }
        let total = contentData.reduce(0) { $0 + $1.value }
        guard total > 0 else { return nil }
        
        let previousSum = contentData[0..<index].reduce(0) { $0 + $1.value }
        return Double(previousSum) / Double(total)
    }
    
    private func safeEndAngle(for index: Int) -> Double? {
        guard index >= 0 && index < contentData.count else { return nil }
        let total = contentData.reduce(0) { $0 + $1.value }
        guard total > 0 else { return nil }
        
        let currentSum = contentData[0...index].reduce(0) { $0 + $1.value }
        return Double(currentSum) / Double(total)
    }
}

struct ContentType {
    let name: String
    let value: Int
    let color: Color
}

struct ScreenTimeEntry {
    let app: String
    let time: String
    let category: String
}

#Preview {
    ProgressView()
}
