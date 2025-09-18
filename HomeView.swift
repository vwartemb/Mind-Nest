//
//  ContentView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//
import SwiftUI

struct HomeView: View {
    @Binding var selection: Int // live binding from navigationBarView
    
    // Sample Data - I need a developers account to get my own data
    @State private var todayScreenTime = "3h 42m"
    
    @State private var dailyApps = [
        ("Instagram", "1h 00m"),
        ("TikTok", "45m"),
        ("YouTube", "1h 22m")
    ]
    
    var body: some View {
        NavigationStack{
            
            ScrollView {
                
                //outer VStack that stacks everything vertically
                VStack(spacing: 20) {
                    
                    /* Button to link to the settings 
                    Button {
                        selection = 2 // Navigate to interests
                    } label: {
                        Image(systemName: "gear")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                     */
                    
                    //Title 
                    Text("Mind Nest")
                        .bold()
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    
                    VStack(spacing: 12){
                        Text("Today's Screen Time")
                            .font(.headline)
                        
                        // Sample screen time data display since i cant collect it from my phone
                        VStack(spacing: 8) {
                            Text(todayScreenTime)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            ForEach(Array(dailyApps.enumerated()), id: \.offset) { index, app in
                                HStack {
                                    Text(app.0)
                                        .font(.body)
                                    Spacer()
                                    Text(app.1)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(height: 100)
                        .padding()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    
                    // Button that changes tab selection instead of NavigationLink
                    Button {
                        selection = 2 // Navigate to interests
                    } label: {
                        Text("Need a break?")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Adds the 4 boxes for Books, Podcasts, etc
                    // These are buttons when pressed takes you to your saved or recommended media or choice
                    HStack(spacing: 24){
                        VStack(spacing: 4){
                            Button {
                                selection = 3 // Navigate to Recommendations tab
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "book.fill")
                                        .font(.title2)
                                    Text("Books")
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: 75)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .buttonStyle(PlainButtonStyle())
                        
                        // Podcast Button
                        VStack(spacing: 4){
                            Button {
                                selection = 3
                            } label: {
                                VStack(spacing: 4){
                                    Image(systemName: "mic.fill")
                                        .font(.title2)
                                    Text("Podcasts")
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: 75)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .buttonStyle(PlainButtonStyle())
                        
                        // Video Button
                        VStack(spacing: 4){
                            Button {
                                selection = 3
                            } label: {
                                VStack(spacing: 4){
                                    Image(systemName: "play.rectangle.fill")
                                        .font(.title2)
                                    Text("Videos")
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: 75)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .buttonStyle(PlainButtonStyle())
                        
                        // Activity button
                        VStack(spacing: 4){
                            Button {
                                selection = 3
                            } label: {
                                VStack(spacing: 4){
                                    Image(systemName: "figure.walk")
                                        .font(.title2)
                                    Text("Activities")
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: 75)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    VStack(spacing: 8){
                        Button {
                            selection = 5
                        } label: {
                            VStack(spacing: 8){
                                Text("Daily Challenge")
                                    .font(.headline)
                                Text("Take a 30-minute nature walk")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(spacing: 8){
                        Button {
                            selection = 5
                        } label: {
                            VStack(spacing: 8){
                                Text("Streak")
                                    .font(.headline)
                                Text("7 days of reduced screen time")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .buttonStyle(PlainButtonStyle())

                }
                .padding()
                
            }
        }
    }
}



#Preview {
    NavigationBarView(selection: 1).environmentObject(BookmarksManager())
}
