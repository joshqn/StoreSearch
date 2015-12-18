//
//  Search.swift
//  StoreSearch
//
//  Created by Joshua Kuehn on 12/17/15.
//  Copyright © 2015 Kuehn LLC. All rights reserved.
//

import Foundation
import UIKit

typealias SearchComplete = (Bool) -> Void
class Search {
    
    enum Category: Int {
        case All = 0
        case Music = 1
        case Software = 2
        case EBooks = 3
        
        var entityName:String {
            switch self {
            case .All: return ""
            case .Music: return "musicTrack"
            case .Software: return "software"
            case .EBooks: return "ebook"
            }
        }
        
    }
    
    enum State {
        case NotSearchedYet
        case Loading
        case NoResults
        case Results([SearchResult])
    }
    
    private(set) var state:State = .NotSearchedYet
    private var dataTask: NSURLSessionDataTask? = nil
    
    func performSeachForText(text: String, category: Category, completion: SearchComplete) {
        
            if !text.isEmpty {
                dataTask?.cancel()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                state = .Loading
    
                let url = urlWithSearchText(text, category: category)
                let session = NSURLSession.sharedSession()
                dataTask = session.dataTaskWithURL(url, completionHandler: {
                    data, response, error in
                    
                    self.state = .NotSearchedYet
                    var success = false
                    if let error = error where error.code == -999 {
                        return //Search was cancelled
                    }
                    if let httpResponse = response as? NSHTTPURLResponse
                        where httpResponse.statusCode == 200, let data = data, dictionary = self.parseJSON(data) {
                            
                        var searchResults = self.parseDictionary(dictionary)
                        if searchResults.isEmpty {
                            self.state = .NoResults
                        } else {
                            searchResults.sortInPlace(<)
                            self.state = .Results(searchResults)
                        }
                        success = true
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false 
                        completion(success)
                    }

                })
                dataTask?.resume()
            }
        }
    
    
    private func urlWithSearchText(searchText:String, category: Category) -> NSURL {
        
        let entityName = category.entityName
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedSearchText, entityName)
        let url = NSURL(string: urlString)
        return url!
        
    }
    
        private func parseJSON(data:NSData) -> [String:AnyObject]? {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch {
                print("JSON error: \(error)")
                return nil
            }
        }
        
        private func parseDictionary(dictionary: [String:AnyObject]) -> [SearchResult] {
            guard let array = dictionary["results"] as? [AnyObject] else {
                print("Expected 'results' array")
                return []
            }
            var searchResults = [SearchResult]()
            for resultDict in array {
                if let resultDict = resultDict as? [String:AnyObject] {
                    var searchResult: SearchResult?
                    if let wrapperType = resultDict["wrapperType"] as? String {
                        switch wrapperType {
                        case "track":
                            searchResult = parseTrack(resultDict)
                        case "audioBook":
                            searchResult = parseAudioBook(resultDict)
                        case "software":
                            searchResult = parseSoftware(resultDict)
                        default:
                            break
                        }
                    } else if let kind = resultDict["kind"] as? String
                        where kind == "ebook" {
                            searchResult = parseEBook(resultDict)
                    }
                    
                    if let result = searchResult {
                        searchResults.append(result)
                    }
                }
            }
            return searchResults
        }
        
       private func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
            let searchResult = SearchResult()
            
            searchResult.name = dictionary["trackName"] as! String
            searchResult.artistName = dictionary["artistName"] as! String
            searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
            searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
            searchResult.storeURL = dictionary["trackViewUrl"] as! String
            searchResult.kind = dictionary["kind"] as! String
            searchResult.curreny = dictionary["currency"] as! String
            
            if let price = dictionary["trackPrice"] as? Double {
                searchResult.price = price
            }
            
            if let genre = dictionary["primaryGenreName"] as? String {
                searchResult.genre = genre
            }
            return searchResult
        }
        
        private func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
            let searchResult = SearchResult()
            
            searchResult.name = dictionary["collectionName"] as! String
            searchResult.artistName = dictionary["artistName"] as! String
            searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
            searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
            searchResult.storeURL = dictionary["collectionViewUrl"] as! String
            searchResult.kind = "audioBook"
            searchResult.curreny = dictionary["currency"] as! String
            
            if let price = dictionary["collectionPrice"] as? Double {
                searchResult.price = price
            }
            
            if let genre = dictionary["primaryGenreName"] as? String {
                searchResult.genre = genre
            }
            return searchResult
        }
        
        private func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
            let searchResult = SearchResult()
            
            searchResult.name = dictionary["trackName"] as! String
            searchResult.artistName = dictionary["artistName"] as! String
            searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
            searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
            searchResult.storeURL = dictionary["trackViewUrl"] as! String
            searchResult.kind = dictionary["kind"] as! String
            searchResult.curreny = dictionary["currency"] as! String
            
            if let price = dictionary["trackPrice"] as? Double {
                searchResult.price = price
            }
            
            if let genre = dictionary["primaryGenreName"] as? String {
                searchResult.genre = genre
            }
            return searchResult
        }
        
        private func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
            let searchResult = SearchResult()
            
            searchResult.name = dictionary["trackName"] as! String
            searchResult.artistName = dictionary["artistName"] as! String
            searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
            searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
            searchResult.storeURL = dictionary["trackViewUrl"] as! String
            searchResult.kind = dictionary["kind"] as! String
            searchResult.curreny = dictionary["currency"] as! String
            
            if let price = dictionary["trackPrice"] as? Double {
                searchResult.price = price
            }
            
            if let genre: AnyObject = dictionary["genres"] {
                searchResult.genre = (genre as! [String]).joinWithSeparator(", ")
            }
            return searchResult
        }

}