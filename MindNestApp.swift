//
//  MindNestApp.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI

@main
struct MindNestApp: App {
    @StateObject private var bookmarksManager = BookmarksManager()
    
    var body: some Scene {
        WindowGroup {
            //HomeView()
            NavigationBarView()
            // we do this so that every card/view in the app can read from and write to the same shared "bookmarks" data
                .environmentObject(bookmarksManager)
        }
    }
}
