//
//  TabView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI

struct NavigationBarView: View {
    @State var selection: Int = 1   // default to the 2nd tab
    var body: some View {
        TabView(selection: $selection){
            HomeView(selection: $selection)
                .tag(1)
                .tabItem{
                    Image(systemName: "house")
                    //Text("Home")
                }
            InterestsSelectionView()
                .tag(2)
                .tabItem {
                    Image(systemName: "list.bullet")
                    //Text("My interests")
                }
            RecommendationsView()
                .tag(3)
                .tabItem {
                    Image(systemName: "heart.square")
                    //Text("My Recommendations")
                }
            SavedContentView()
                .tag(4)
                .tabItem {
                    Image(systemName: "star.square")
                    //Text("Saved")
                }
            ProgressView()
                .tag(5)
                .tabItem {
                    Image(systemName: "progress.indicator")
                    //Text("Progress")
                }
        }
    }
}

#Preview {
    NavigationBarView()
}
