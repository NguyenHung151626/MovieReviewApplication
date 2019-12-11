//
//  Movie.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation

class JSONObject: Decodable {
    let results: [Movie]
}

class Movie: Decodable {
    let title: String?
    let poster_path: String?
    let id: Int
    
    init(title: String?, poster_path: String?, id: Int) {
        self.title = title
        self.poster_path = poster_path
        self.id = id
    }
}

class MovieDetail: Decodable {
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
class Genre: Decodable {
    let name: String?
}
//
class ProductionCompany: Decodable {
    let id: Int
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

//Casts
class CastResults: Decodable {
    let cast: [Cast]
    
    init() {
        self.cast = []
    }
}
class Cast: Decodable {
    let profile_path: String?
    let name: String?
}
// Reviews
class ReviewResults: Decodable {
    let results: [Review]
    
    init() {
        results = []
    }
}
class Review: Decodable {
    let author: String?
    let content: String?
    let id: String?
    let url: String?
}
// Similar Movies
class SimilarResults: Decodable {
    let results: [SimilarMovie]
    
    init() {
        results = []
    }
}

class SimilarMovie: Decodable {
    let poster_path: String?
    let title: String?
    
    init() {
        self.poster_path = nil
        self.title = nil
    }
}

