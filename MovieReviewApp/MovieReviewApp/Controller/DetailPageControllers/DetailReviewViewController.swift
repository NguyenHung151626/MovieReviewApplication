//
//  DetailReviewViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/9/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailReviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var detailReviewViewModel: MovieViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        detailReviewViewModel.movieDetailSubject
            .asObserver()
            .map { movieDetail -> [Review] in
                var results = movieDetail.reviews.results
                if results.count < 5 {
                    for _ in 1...(5 - results.count) {
                        let defaultReview = """
                        This movie is worth trying.
                        I think noone could ever ignore this one
                        Take an hour and enjoy!
                        """
                        results.append(Review(author: "Hungbn1996", content: defaultReview))
                    }
                    return results
                } else {
                    return movieDetail.reviews.results
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: "DetailReviewTableViewCell", cellType: DetailReviewTableViewCell.self)) { _, review, cell in
                cell.authorNameLabel.text = review.author
                cell.reviewLabel.text = review.content
                cell.containerView.layer.cornerRadius = 3
            }
            .disposed(by: bag)
    }
}
