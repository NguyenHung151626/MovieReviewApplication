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
    let production_companies: [ProductionCompany]?
    let reviews: ReviewResults
    let similar: SimilarResults
    
    init(backdrop_path: String?, production_companies: [ProductionCompany]?) {
        self.backdrop_path = backdrop_path
        self.production_companies = production_companies
        self.reviews = ReviewResults()
        self.similar = SimilarResults()
    }
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
//
class ProductionCompany: Decodable {
    let id: Int
    let logo_path: String?
    let name: String?
    let origin_country: String?
}
