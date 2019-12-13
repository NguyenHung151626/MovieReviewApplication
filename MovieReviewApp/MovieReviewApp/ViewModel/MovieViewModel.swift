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
    //List: Didload: Ref to ViewModel => Publish
    var mostPopularMovieSubject = PublishSubject<[Movie]>()
    var mostRatedMovieSubject = PublishSubject<[Movie]>()
    var mostRecentMovieSubject = PublishSubject<[Movie]>()
    //Detail + Cast + Review + More: More not didLoad
    var movieDetailSubject = BehaviorSubject<MovieDetail>(value: MovieDetail())
    var movieIdViewModelSubject = PublishSubject<String>()
    
    init() {
        gettingMovieListData()
        gettingMovieDetailById()
    }

    func gettingMovieListData() {
        let mostPopularURL = MovieListAPI.mostPopularMovieURL
        gettingListMoviesAPIData(url: mostPopularURL)
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
        //
        let mostRecentURL = MovieListAPI.mostRecentMovieURL
        gettingListMoviesAPIData(url: mostRecentURL)
            .asObservable()
            .subscribe(onNext: { movies in
                self.mostRecentMovieSubject.onNext(movies)
            }, onError: { error in
                let movieNil = Movie(title: nil, poster_path: nil, id: 0)
                let moviesNil = [movieNil, movieNil, movieNil, movieNil]
                switch error {
                default:
                    self.mostRecentMovieSubject.onNext(moviesNil)
                }
            })
            .disposed(by: bag)
        //
        let mostRatedURL = MovieListAPI.mostRatedMovieURL
        gettingListMoviesAPIData(url: mostRatedURL)
            .asObservable()
            .subscribe(onNext: { movies in
                self.mostRatedMovieSubject.onNext(movies)
            }, onError: { error in
                let movieNil = Movie(title: nil, poster_path: nil, id: 0)
                let moviesNil = [movieNil, movieNil, movieNil, movieNil]
                switch error {
                default:
                    self.mostRatedMovieSubject.onNext(moviesNil)
                }
            })
            .disposed(by: bag)
    }
    
    func gettingMovieDetailById() {
        movieIdViewModelSubject
            .asObserver()
            .flatMap { movieId -> Observable<MovieDetail> in
                let url = MovieDetailAPI.movieDetailURLHead + movieId + MovieDetailAPI.movieDetailURLTail + "&append_to_response=reviews,similar,credits"
                return self.callMovieDetailAPI(url: url)
                //noInternet die here
            }
            .subscribe(onNext: { movieDetail in
                self.movieDetailSubject.onNext(movieDetail)
            }, onError: { error in
                let movieDetailNil = MovieDetail()
                switch error {
                default:
                    self.movieDetailSubject.onNext(movieDetailNil)
                }
            })
            .disposed(by: bag)
    }
}


