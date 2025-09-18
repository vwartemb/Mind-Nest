//
//  SavedContentView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI

// 3) Card View
struct SavedCardView: View {
    let item: RecommendationsItem // modal
    let category: String
    
    @EnvironmentObject var bookmarksManager: BookmarksManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // load image
            AsyncImage(url: URL(string: item.image)){ img in
                if let image = img.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.gray
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading){
                
                // Media title
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                
                HStack{
                    // The media category
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    Spacer()
                    
                    // Bookmark icon
                    Button{
                        bookmarksManager.toggleBookmark(item)
                    } label: {
                        Image(systemName: bookmarksManager.isBookmarked(item)
                              ? "bookmark.fill"
                              : "bookmark")
                        .font(.system(size: 20, weight: .regular))
                    }
                    // link icon
                    Button{
                        openLink(item.link)
                    } label: {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 20, weight: .regular))
                    }
                    
                }
                
                
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        
    }
    // May need a dispatch queue
    func openLink(_ link: String?){
        // try to open the link else print invalid link
        guard let urlString = link,
              let url = URL(string: urlString)
        else {
            print("Invalid or missing link")
            return
            
        }
        UIApplication.shared.open(url)
    }
}

// 4) Recommendations screen
struct SavedContentView: View {
    // load the bookmarks manager
    @EnvironmentObject var bookmarksManager: BookmarksManager
    
    
    // load everything one time
    var allRecs:  RecommendationsByCategory = loadRecommendations()
    
    // For the segmented control
    enum MediaType: Int, CaseIterable, Identifiable {
        case book
        case podcast
        case video
        case activity
        
        var id: Int { rawValue }
        
        // Label for the segmented control
        var displayName: String {
            switch self {
            case .book:
                return "Books"
            case .podcast:
                return "Podcasts"
            case .video:
                return "Videos"
            case .activity:
                return "Activities"
            }
        }
        
        
        // so that we can property type cast
        var typeMatch: String {
            switch self {
            case .book:
                return "book"
            case .podcast:
                return "podcast"
            case .video:
                return "video"
            case .activity:
                return "activity"
            }
        }
    }
    // to keep track of what is selected
    @State private var selectedMedia: MediaType = .book
    
    var body: some View {
        
        ScrollView {
            VStack{
                Text("My Library")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
            }
            
            // Segmented Control
            Picker("MediaType", selection: $selectedMedia) {
                ForEach(MediaType.allCases){ type in
                    Text(type.displayName).tag(type)
                    
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if savedItems.isEmpty {
                VStack(spacing: 16) {
                    Text("No Saved content yet")
                        .font(.headline)
                    Text("Go back to your recommendations and bookmark some content")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(savedItems) { item in
                        SavedCardView(item: item, category: itemCategory(item: item))
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    private var savedItems: [RecommendationsItem]{
        // get all the items from all categories
        let allItems = allRecs.values.flatMap { $0 }
        
        
        
        // Now filter to only bookmarked items
        let bookmarkedItems = allItems.filter { item in
            bookmarksManager.bookmarkedIDs.contains(item.id)
        }
       
        
        // Filter by selected media type
        let filterByType = bookmarkedItems.filter { item in
            item.type == selectedMedia.typeMatch }
        
        
        
        return filterByType
    }
    
    // Tag: helper function that displays which category this item came from
    private func itemCategory(item: RecommendationsItem) -> String {
        // find the first key for each item
        for (category, items) in allRecs {
            if items.contains(where: {$0.id == item.id}){
                return category
            }
        }
        return ""
    }
    
    
}



#Preview {
    SavedContentView().environmentObject(BookmarksManager())
}
