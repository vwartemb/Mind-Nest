//
//  RecommendationsView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI

// make this a shared instance of the recommendation data (May need a dispatch Queue
let sharedRecommendations: RecommendationsByCategory = {
    guard let url = Bundle.main.url(forResource: "recommendations", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let result = try? JSONDecoder().decode(RecommendationsByCategory.self, from: data)
    else { return [:] }
    return result
}()

class BookmarksManager: ObservableObject {
    
    @Published var bookmarkedIDs: Set<UUID> = []
    @Published var selectedCategories: [String] = []
    
    // String identifiers used to save and get data from UserDefaults
    private let bookmarksKey = "SavedBookmarks" // what items did i bookmark?
    private let categoriesKey = "SelectedCategories" // what categories do i like?
    
    init() {
        loadBookmarks() // restore bookmarked items from last time
        loadSelectedCategories() // restore selected categories from last time
    }
    
    // This checks if an item's ID exists in our bookmarkedID's set
    func isBookmarked(_ item: RecommendationsItem) -> Bool {
        bookmarkedIDs.contains(item.id)
    }
    
    // for adding and removing bookmarks
    func toggleBookmark(_ item: RecommendationsItem) {
        if isBookmarked(item) {
            bookmarkedIDs.remove(item.id)
        } else {
            bookmarkedIDs.insert(item.id)
        }
        saveBookmarks()
    }
    // Replace the category list when the user updates it
    func updateSelectedCategories(_ categories: [String]) {
        selectedCategories = categories
        saveSelectedCategories()
    }
    
    // MARK: - Persistence Methods
    
    
    // I need to convert the UUIDs to string before i can store
    private func saveBookmarks() {
        let uuidStrings = Array(bookmarkedIDs).map { $0.uuidString }
        UserDefaults.standard.set(uuidStrings, forKey: bookmarksKey)
    }
    
    // get the UUID string and convert it back to UUIDs
    private func loadBookmarks() {
        guard let uuidStrings = UserDefaults.standard.array(forKey: bookmarksKey) as? [String] else { return }
        bookmarkedIDs = Set(uuidStrings.compactMap { UUID(uuidString: $0) })
    }
    
    // just store the categories in UserDefaults
    private func saveSelectedCategories() {
        UserDefaults.standard.set(selectedCategories, forKey: categoriesKey)
    }
    
    // Get the string array of categories
    private func loadSelectedCategories() {
        selectedCategories = UserDefaults.standard.stringArray(forKey: categoriesKey) ?? []
    }
}

// 1) Codable Modal
struct RecommendationsItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let link: String? // optional
    let image: String
    let description: String
    
}
// a dictionary that stores each key as a string and each value is an array of RecommendationsItem
typealias RecommendationsByCategory = [String: [RecommendationsItem]]



// 2) Load JSON
func loadRecommendations() -> RecommendationsByCategory {
    return sharedRecommendations
}

// 3) Card View
struct RecommendationCardView: View {
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
struct RecommendationsView: View {
    @EnvironmentObject var bookmarksManager: BookmarksManager
    
    //var selectedCategory: [String]
    
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
                Text("Recommendations")
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
            
            if bookmarksManager.selectedCategories.isEmpty {
                VStack(spacing: 16) {
                    Text("No categories selected")
                        .font(.headline)
                    Text("Please go to your interests to select categories, or showing all available content:")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    // Show all categories as fallback
                    LazyVStack(spacing: 0) {
                        ForEach(allItemsForCurrentMedia) { item in
                            RecommendationCardView(item: item, category: itemCategory(item: item))
                        }
                    }
                    .padding(.top, 8)
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(filteredItems) { item in
                        RecommendationCardView(item: item, category: itemCategory(item: item))
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    // filter items so only those whose category is in selectedCategories
    private var filteredItems: [RecommendationsItem] {
        bookmarksManager.selectedCategories
            .compactMap{ category in allRecs[category]}
            .flatMap { $0 }
            .filter { item in item.type == selectedMedia.typeMatch }
    }
    
    // All items for current media type
    private var allItemsForCurrentMedia: [RecommendationsItem]{
        allRecs.values
            .flatMap{$0}
            .filter { item in item.type == selectedMedia.typeMatch }
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
    RecommendationsView().environmentObject(BookmarksManager())
}
