//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Joshua Kuehn on 12/13/15.
//  Copyright © 2015 Kuehn LLC. All rights reserved.
//

import Foundation

class SearchResult {
    var name = ""
    var artistName = ""
    var artworkURL60 = ""
    var artworkURL100 = ""
    var storeURL = ""
    var kind = ""
    var curreny = ""
    var price = 0.0
    var genre = ""
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .OrderedAscending
}