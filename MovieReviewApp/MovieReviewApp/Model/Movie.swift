//
//  Movie.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation

struct JSONObject: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String?
    let poster_path: String?
    let id: Int
    
    init(title: String?, poster_path: String?, id: Int) {
        self.title = title
        self.poster_path = poster_path
        self.id = id
    }
}

struct MovieDetail: Decodable {
    let backdrop_path: String?
    let poster_path: String?
    let title: String?
    let genres: [Genre]
    let vote_average: Double
    let original_language: String?
    let release_date: String?
    let overview: String?
    
    let production_companies: [ProductionCompany]?
    let credits: CastResults
    let reviews: ReviewResults
    let similar: SimilarResults
    
    init() {
        self.poster_path = nil
        self.backdrop_path = nil
        self.title = nil
        self.genres = []
        self.vote_average = 0.0
        self.original_language = nil
        self.release_date = nil
        self.overview = nil
        self.production_companies = []
        self.credits = CastResults()
        self.reviews = ReviewResults()
        self.similar = SimilarResults()
    }
}
struct Genre: Decodable {
    let name: String?
}
//
struct ProductionCompany: Decodable {
    let id: Int
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

//Casts
struct CastResults: Decodable {
    let cast: [Cast]
    
    init() {
        self.cast = []
    }
}
struct Cast: Decodable {
    let profile_path: String?
    let name: String?
}
// Reviews
struct ReviewResults: Decodable {
    let results: [Review]
    
    init() {
        results = []
    }
}
struct Review: Decodable {
    let author: String?
    let content: String?
    let id: String?
    let url: String?
    init(author: String?, content: String?) {
        self.author = author
        self.content = content
        self.id = nil
        self.url = nil
    }
}
// Similar Movies
struct SimilarResults: Decodable {
    let results: [SimilarMovie]
    
    init() {
        results = []
    }
}

struct SimilarMovie: Decodable {
    let poster_path: String?
    let title: String?
    let release_date: String?
    
    init() {
        self.poster_path = nil
        self.title = nil
        self.release_date = nil
    }
}

