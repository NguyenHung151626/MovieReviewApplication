//
//  ListMovieViewModel.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    let bag = DisposeBag()
    //var movie: Movie
    var mostPopularMovieSubject = BehaviorSubject<[Movie]>(value: [])
    
    var movieDetailSubject = BehaviorSubject<MovieDetail>(value: MovieDetail(backdrop_path: nil, production_companies: []))
    var movieIdSubject = PublishSubject<String>()
    
    init() {
        //self.movie = movie
        gettingMovieListData()
        gettingMovieDetailById()
    }

    func gettingMovieListData() {
        let url = MovieListAPI.mostPopularMovieURL
        callAPI(url: url)
            .asObservable()
            .subscribe(onNext: { movies in
                self.mostPopularMovieSubject.onNext(movies)
            }, onError: { error in
                let movieNil = Movie(title: nil, poster_path: nil, id: 0)
                let moviesNil = [movieNil, movieNil, movieNil, movieNil]
                switch error {
                default:
                    self.mostPopularMovieSubject.onNext(moviesNil)
                }
            })
            .disposed(by: bag)
    }
    
    func gettingMovieDetailById() {
        let observable = movieIdSubject
            .asObserver()
            .flatMap { movieId -> Observable<MovieDetail> in
                let url = MovieDetailAPI.movieDetailURLHead + movieId + MovieDetailAPI.movieDetailURLTail
                return self.callMovieDetailAPI(url: url)
                //noInternet die here
            }
        observable
//            .bind(to: movieDetailSubject)
            .subscribe(onNext: { movieDetail in
                self.movieDetailSubject.onNext(movieDetail)
            }, onError: { error in
                let movieDetailNil = MovieDetail(backdrop_path: nil, production_companies: [])
                switch error {
                default:
                    self.movieDetailSubject.onNext(movieDetailNil)
                }
            })
            .disposed(by: bag)
    }
}

enum NetworkError: Error {
    case dummyData
    case emptyData
}