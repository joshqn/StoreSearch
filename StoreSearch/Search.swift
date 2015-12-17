//
//  Search.swift
//  StoreSearch
//
//  Created by Joshua Kuehn on 12/17/15.
//  Copyright © 2015 Kuehn LLC. All rights reserved.
//

import Foundation

class Search {
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    
    private var dataTask: NSURLSessionDataTask? = nil
    
    func performSeachForText(text:String, category: Int) {
        print("Searching...")
    }
}