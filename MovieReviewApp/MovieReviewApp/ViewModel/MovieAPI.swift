//
//  MovieAPI.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation

enum MovieAPIKey {
    static let APIKey = "c44857a232703d736a222e2af6321a35"
}

enum MovieImageURL {
    static let imageURLHead = "https://image.tmdb.org/t/p/original"
}

enum MovieListAPI {
    static let mostPopularMovieURL = "https://api.themoviedb.org/3/discover/movie?api_key=c44857a232703d736a222e2af6321a35&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
}

enum MovieDetailAPI {
    static let movieDetailURLHead = "https://api.themoviedb.org/3/movie/"
    static let movieDetailURLTail = "?api_key=c44857a232703d736a222e2af6321a35&language=en-US"
}
