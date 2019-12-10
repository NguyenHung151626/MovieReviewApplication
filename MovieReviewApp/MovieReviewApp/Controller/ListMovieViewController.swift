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
    let bag = DisposeBag()
    
    var listMovieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        bindCollectionView()
    }
    
    func bindCollectionView() {
        listMovieViewModel.mostPopularMovieSubject
            .asObserver()
            .bind(to: collectionView.rx.items(cellIdentifier: "PopularMovieCollectionViewCell", cellType: PopularMovieCollectionViewCell.self)) {  _, movie, cell in
                    cell.movieNameLabel.text = movie.title ?? "Not Found"
                    let imageURL = MovieImageURL.imageURLHead + (movie.poster_path ?? "")
                    cell.movieImageView.download(url: imageURL)
                    cell.labelView.layer.cornerRadius = 10
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
    }

}

extension ListMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.36 * collectionView.frame.width, height: 240)
    }
}

