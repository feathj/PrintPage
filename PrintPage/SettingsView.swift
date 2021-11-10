//
//  SettingsView.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/10/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiKey") private var apiKey = ""
    @AppStorage("searchEngineId") private var searchEngineId = ""
    var body: some View {
        List {
            Section(header: Text("API Information")) {
                Form {
                    Text("API Key")
                    TextField("", text: $apiKey)
                    Text("Search Engine ID")
                    TextField("", text: $searchEngineId)
                }
            }
            Section(header: Text("Cache")) {
                Button("Clear Cache"){
                    clearCache()
                }
            }
        }
        .listStyle(.sidebar)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
