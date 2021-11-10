//
//  MainView.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/1/21.
//

import SwiftUI

var items: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
let maxPage = 5

struct MainView: View {
    @State var searchText = ""
    @State var viewSearchResults = [SearchResult]()
    @State var currentPage = 0
    
    @AppStorage("apiKey") private var apiKey = ""
    @AppStorage("searchEngineId") private var searchEngineId = ""
    
    func runSearch(page: Int=0){
        executeSearch(apiKey: apiKey, searchEngineId: searchEngineId, searchText: searchText, page: page) { searchResults in
            viewSearchResults.append(contentsOf: searchResults)
        }
    }
    
    var body: some View {
        Spacer()
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search ..", text: $searchText)
            Button("Go"){
                currentPage = 0
                viewSearchResults = [SearchResult]()
                runSearch()
            }
            Spacer()
        }
        .foregroundColor(.gray)
        .padding(.leading, 13)
        Spacer()
        ScrollView(.vertical, showsIndicators: true){
            LazyVGrid(columns: items, spacing: 10) {
                ForEach(viewSearchResults, id: \.id){ searchResult in
                    if !searchResult.link.hasSuffix(".svg") && !searchResult.link.hasPrefix("http:"){
                        PagePreview(link: searchResult.link, title: searchResult.title)
                    }
                }
            }.padding(.horizontal)
        }
        Spacer()
        if(viewSearchResults.count > 0 && currentPage < maxPage) {
            Button("Load More") {
                currentPage = currentPage + 1
                runSearch(page: currentPage)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
