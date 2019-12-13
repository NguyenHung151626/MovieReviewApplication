//
//  DetailMoreViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/9/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailMoreViewController: UIViewController {
    var detailMoreViewModel: MovieViewModel!
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMoviesRelatedView: UIView!
    var noRelatedMovieFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        let observable = detailMoreViewModel.movieDetailSubject
            .asObservable()
            .map { movieDetail -> [SimilarMovie] in
                return movieDetail.similar.results
            }
        observable
            .bind(to: tableView.rx.items(cellIdentifier: "DetailMoreTableViewCell", cellType: DetailMoreTableViewCell.self)) { _, more, cell in
                cell.titleLabel.text = more.title
                let imageURL = MovieImageURL.imageURLHead + (more.poster_path ?? "")
                cell.posterImageView.download(url: imageURL, cornerRadius: 3)
                cell.genresLabel.text = ("Release: " + (more.release_date ?? ""))
                cell.containerView.layer.cornerRadius = 3
            }
            .disposed(by: bag)
        observable
            .subscribe(onNext: { movies in
                if movies.count == 0 {
                    self.noMoviesRelatedView.isHidden = false
                } else {
                    self.noMoviesRelatedView.isHidden = true
                }
            })
            .disposed(by: bag)
    }
}
