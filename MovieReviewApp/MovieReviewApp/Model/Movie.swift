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
    
    init(backdrop_path: String?, production_companies: [ProductionCompany]?) {
        self.backdrop_path = backdrop_path
        self.production_companies = production_companies
    }
}

class ProductionCompany: Decodable {
    let id: Int
    let logo_path: String?
    let name: String?
    let origin_country: String?
}
