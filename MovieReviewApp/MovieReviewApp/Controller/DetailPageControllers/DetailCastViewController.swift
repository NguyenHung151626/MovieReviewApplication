//
//  CastViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/9/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailCastViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var detailCastViewModel: MovieViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        //
        detailCastViewModel.movieDetailSubject
            .asObserver()
            .map { $0.credits.cast }
            .bind(to: collectionView.rx.items(cellIdentifier: "DetailCastCollectionViewCell", cellType: DetailCastCollectionViewCell.self)) {  _, cast, cell in
                cell.castNameLabel.text = cast.name
                let imageURL = MovieImageURL.imageURLHead + (cast.profile_path ?? "")
                cell.profileImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "default-image"))
            }
            .disposed(by: bag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
}


