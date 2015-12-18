//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Joshua Kuehn on 12/13/15.
//  Copyright © 2015 Kuehn LLC. All rights reserved.
//

import Foundation

private let displayNamesForKind = [ "album": NSLocalizedString("Album", comment: "Localized kind: Album"),
    "audioBook": NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book"),
    "book": NSLocalizedString("Book", comment: "Localized kind: Book"),
    "ebook": NSLocalizedString("E-Book", comment: "Localized kind: E-Book"),
    "feature-movie": NSLocalizedString("Movie", comment: "Localized kind: Movie"),
    "music-video": NSLocalizedString("Music Video", comment: "Localized kind: Music Video"),
    "podcast": NSLocalizedString("Podcast", comment: "Localized kind: Podcast"),
    "software": NSLocalizedString("App", comment: "Localized kind: App"),
    "song": NSLocalizedString("Song", comment: "Localized kind: Song"),
    "tv-episode": NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode")

]

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
    
    func kindForDisplay() -> String {
        return displayNamesForKind[kind] ?? kind 
    }
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .OrderedAscending
}