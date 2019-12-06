//
//  CallAPI.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

extension MovieViewModel {
    func callAPI(url: String) -> Observable<[Movie]> {
        return Observable<[Movie]>.create { observer in
            AF.request(url).responseJSON { response in
                //
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        observer.onError(NetworkError.emptyData)
                        return
                    }
                    do {
                        let movies = try JSONDecoder().decode(JSONObject.self, from: data).results
                        observer.onNext(movies)
                    } catch {
                        observer.onError(NetworkError.dummyData)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func callMovieDetailAPI(url: String) -> Observable<MovieDetail> {
        return Observable<MovieDetail>.create { observer in
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        observer.onError(NetworkError.emptyData)
                        return
                    }
                    do {
                        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                        observer.onNext(movieDetail)
                    } catch {
                        observer.onError(NetworkError.dummyData)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
