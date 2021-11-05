//
//  MainView.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/1/21.
//

import SwiftUI

var items: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

struct MainView: View {
    @State var searchText = ""
    @State var viewSearchResults = [SearchResult]()
    var body: some View {
        TextField("", text:$searchText)
        Button("Search"){
            executeSearch(searchText: searchText) { searchResults in
                viewSearchResults = searchResults
            }
            /*viewSearchResults = [SearchResult]()
            viewSearchResults = [PrintPage.SearchResult(title: "Paw Patrol Coloring Pages - Best Coloring Pages For Kids", link: "https://www.bestcoloringpagesforkids.com/wp-content/uploads/2018/01/Free-Paw-Patrol-Coloring-Page.png"), PrintPage.SearchResult(title: "Paw Patrol Coloring Pages - ColoringAll", link: "https://static.coloringall.com/images/cartoon/paw-patrol/Paw-Patrol-Six-Pups.svg"), PrintPage.SearchResult(title: "Free Printable PAW Patrol Coloring Pages For Kids", link: "https://www.cool2bkids.com/wp-content/uploads/2021/02/Paw-Patrol-Coloring-Pages-300x212.jpg"), PrintPage.SearchResult(title: "Paw Patrol Coloring Pages - Coloring Home", link: "https://coloringhome.com/coloring/dc6/aaG/dc6aaGbMi.jpg"), PrintPage.SearchResult(title: "Paw Patrol Coloring Pages (Updated 2021)", link: "https://iheartcraftythings.com/wp-content/uploads/2021/05/PawPatrol_1.jpg"), PrintPage.SearchResult(title: "Printable Paw Patrol Friends Pdf Coloring Pages", link: "https://coloringoo.com/wp-content/uploads/2020/09/printable-paw-patrol-friends-pdf-coloring-pages.png"), PrintPage.SearchResult(title: "Rubble and his friends in Paw Patrol Coloring Page - Free ...", link: "https://coloringonly.com/images/imgcolor/Rubble-and-his-friends-in-Paw-Patrol-coloring-page.png"), PrintPage.SearchResult(title: "Happy Halloween Paw Patrol Coloring Pages", link: "https://coloringoo.com/wp-content/uploads/2020/10/happy-halloween-paw-patrol-coloring-pages-1200x1697.png"), PrintPage.SearchResult(title: "Paw Patrol Coloring Pages - Free Printable Coloring Pages for Kids", link: "https://coloringonly.com/images/imgcolor/1529643021-32.png"), PrintPage.SearchResult(title: "PAW Patrol coloring pages | Free Coloring Pages", link: "http://www.supercoloring.com/sites/default/files/styles/coloring_full/public/cif/2016/06/zumas-air-rescue-uniform-coloring-page.png")]*/
        }
        ScrollView(.vertical, showsIndicators: true){
            LazyVGrid(columns: items, spacing: 10) {
                ForEach(viewSearchResults, id: \.link){ searchResult in
                    if !searchResult.link.hasSuffix(".svg") && !searchResult.link.hasPrefix("http:"){
                        PagePreview(link: searchResult.link, title: searchResult.title)
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
