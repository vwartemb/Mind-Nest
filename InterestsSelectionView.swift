//
//  InterestsSelectionView.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI

struct InterestsSelectionView: View {
    
    @EnvironmentObject var bookmarksManager: BookmarksManager
    
    let textLabels = [
        "Nature", "Science", "History", "Art",
        "Tech", "Personal Development", "Fitness", "Cooking",
        "Travel", "Mindfulness & Meditation"
    ]
    // were storing a list of boolean functions
    @State private var selections: [Bool]
    @State private var goToRecs: Bool = false
    
    
    
    // now that the wrapper defaults are set we can safely look at textlabels and use its count to build the selection array
    init() {
        _selections = State(
            initialValue: Array(repeating: false, count: textLabels.count))
    }
    
    // get all of the toggled labels
    private var selectedLabels: [String] {
        textLabels.indices.compactMap { index in
            selections[index] ? textLabels[index] : nil
            
        }
    }
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                VStack(spacing: 16){
                    
                    // Title
                    Text("Interests")
                        .bold()
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    
                    // Instead of manually adding each topic im iterating through the list of topics and assigning it a personal toggle
                    VStack(alignment: .leading, spacing: 12){
                        ForEach(textLabels.indices, id: \.self) { idx in
                            HStack(spacing: 12){
                                Text(textLabels[idx])
                                    .frame(width: 180, alignment: .leading)
                                Toggle("", isOn: $selections[idx])
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    Button("Save Preferences"){
                        let labels = selectedLabels
                        guard !labels.isEmpty else { return }
                        
                        // Tell the manager which categories are now active:
                        bookmarksManager.updateSelectedCategories(labels)
                        
                        // Then navigate:
                        goToRecs = true
                    }
                    .frame(maxWidth: 200)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    
                    NavigationLink(destination: RecommendationsView(), isActive: $goToRecs) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationBarView(selection: 2).environmentObject(BookmarksManager())
}
