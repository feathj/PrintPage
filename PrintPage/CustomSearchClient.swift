//
//  CustomSearchClient.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/2/21.
//

import Foundation
import CryptoKit

let apiKey = "AIzaSyAeTRnDVTCLBwFC2UHy_YNCx-x3BHJ8aq0"
let searchEngineId = "f691fd6c1caba4962"

// https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list
struct SearchResult {
    var title = ""
    var link = ""
}
func saveToCache(searchText: String, data: Data) {
    let cachePath = cachePathFromSearchText(searchText: searchText)
    try? data.write(to: cachePath)
}
func loadFromCache(searchText: String) -> Data? {
    let cachePath = cachePathFromSearchText(searchText: searchText)
    do{
        let data = try Data(contentsOf: cachePath)
        return data
    } catch {
        return nil
    }
}
func cachePathFromSearchText(searchText: String) -> URL {
    let urlHash = SHA256.hash(data: Data(searchText.utf8)).description
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return cachesDirectory.appendingPathComponent(urlHash)
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
func executeSearch(searchText:String, callback: @escaping ([SearchResult]) -> ()) {
    // Check cache first
    let cachedData = loadFromCache(searchText: searchText)
    if cachedData != nil {
        return callback(searchResultsFromData(data: cachedData!))
    }
    
    let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@&searchType=image", searchText + "coloring pages", searchEngineId, apiKey)
    
    let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let finalUrl = URL(string: url!)
    let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.httpMethod = "GET"

    let session = URLSession.shared

    let datatask = session.dataTask(with: request as URLRequest) { (data, response, error) in
        if data != nil {
            saveToCache(searchText: searchText, data: data!)
            callback(searchResultsFromData(data: data!))
        } else {
            callback([])
        }
    }
    datatask.resume()
}
