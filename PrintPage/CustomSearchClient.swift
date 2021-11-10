//
//  CustomSearchClient.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/2/21.
//

import Foundation
import SwiftUI


// https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list
struct SearchResult: Hashable {
    var id = UUID()
    var title = ""
    var link = ""
}

func searchResultsFromData(data: Data) -> [SearchResult] {
    do{
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            var returnVal: [SearchResult] = []
            for jsonRecord in jsonResult["items"] as! [NSDictionary] {
                returnVal.append(SearchResult(title: jsonRecord["title"] as! String, link: jsonRecord["link"] as! String))
            }
            return returnVal
        }
    }
    catch let error as NSError {
        print(error.localizedDescription)
    }
   return []
}

// TODO: Better error handling
func executeSearch(apiKey:String, searchEngineId:String, searchText:String, page:Int=0, callback:@escaping ([SearchResult]) -> ()) {
    let start = (page * 10) + 1
    
    // Check cache first
    let cachedData = loadFromCache(cacheKey: searchText + String(page))
    if cachedData != nil {
        return callback(searchResultsFromData(data: cachedData!))
    }
    
    let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@&start=%d&searchType=image", searchText + "coloring pages", searchEngineId, apiKey, start)
    
    let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let finalUrl = URL(string: url!)
    let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.httpMethod = "GET"

    let session = URLSession.shared

    let datatask = session.dataTask(with: request as URLRequest) { (data, response, error) in
        if data != nil {
            saveToCache(cacheKey: searchText + String(page), data: data!)
            callback(searchResultsFromData(data: data!))
        } else {
            callback([])
        }
    }
    datatask.resume()
}
