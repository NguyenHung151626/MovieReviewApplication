//
//  ListMovieViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ListMovieViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mostRecentCollectionView: UICollectionView!
    @IBOutlet weak var mostRatedCollectionView: UICollectionView!
    @IBOutlet weak var pinLeftImageView1: UIImageView!
    @IBOutlet weak var pinLeftImageView2: UIImageView!
    @IBOutlet weak var pinLeftImageView3: UIImageView!
    let bag = DisposeBag()
    var listMovieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpUIComponents
        pinLeftImageView1.rotate180degrees()
        pinLeftImageView2.rotate180degrees()
        pinLeftImageView3.rotate180degrees()
        navigationController?.navigationBar.topItem?.title = "Discover"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "AppleGothic", size: 16.0)!]
        //navigationController?.navigationBar.barTintColor = .white
        //
        bindCollectionView()
    }
    
    func bindCollectionView() {
        listMovieViewModel.mostPopularMovieSubject
            .asObserver()
            .bind(to: collectionView.rx.items(cellIdentifier: "PopularMovieCollectionViewCell", cellType: PopularMovieCollectionViewCell.self)) {  _, movie, cell in
                    cell.movieNameLabel.text = movie.title ?? "Not Found"
                    let imageURL = MovieImageURL.imageURLHead + (movie.poster_path ?? "")
                    cell.movieImageView.download(url: imageURL, cornerRadius: 3)
                    cell.labelView.layer.cornerRadius = 3
                    cell.labelView.clipsToBounds = true
            }
            .disposed(by: bag)
        //moving to DetailViewController on click
        collectionView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else {
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.movieDetailViewModel = self.listMovieViewModel
                vc.movieIdSubject.onNext("\(movie.id)")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        listMovieViewModel.mostRecentMovieSubject
            .asObserver()
            .bind(to: mostRecentCollectionView.rx.items(cellIdentifier: "MostRecentCollectionViewCell", cellType: MostRecentCollectionViewCell.self)) {  _, movie, cell in
                cell.movieNameLabel.text = movie.title ?? "Not Found"
                let imageURL = MovieImageURL.imageURLHead + (movie.poster_path ?? "")
                cell.movieImageView.download(url: imageURL, cornerRadius: 3)
                cell.labelView.layer.cornerRadius = 3
                cell.labelView.clipsToBounds = true
            }
            .disposed(by: bag)
        //moving to DetailViewController on click
        mostRecentCollectionView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else {
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.movieDetailViewModel = self.listMovieViewModel
                vc.movieIdSubject.onNext("\(movie.id)")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        listMovieViewModel.mostRatedMovieSubject
            .asObserver()
            .bind(to: mostRatedCollectionView.rx.items(cellIdentifier: "MostRatedCollectionViewCell", cellType: MostRatedCollectionViewCell.self)) {  _, movie, cell in
                cell.movieNameLabel.text = movie.title ?? "Not Found"
                let imageURL = MovieImageURL.imageURLHead + (movie.poster_path ?? "")
                cell.movieImageView.download(url: imageURL, cornerRadius: 3)
                cell.labelView.layer.cornerRadius = 3
                cell.labelView.clipsToBounds = true
            }
            .disposed(by: bag)
        mostRatedCollectionView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else {
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.movieDetailViewModel = self.listMovieViewModel
                vc.movieIdSubject.onNext("\(movie.id)")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
}

extension ListMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.36 * collectionView.frame.width, height: 240)
    }
}

