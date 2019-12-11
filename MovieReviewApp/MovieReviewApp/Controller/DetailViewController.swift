//
//  DetailViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/6/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: UIViewController {
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseTimeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    //UI segmentedControl
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlContainerView: UIView!
    
    private enum Constants {
        static let underlineViewColor: UIColor = UIColor(red: 2.0/255.0, green: 148.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        static let underlineViewHeight: CGFloat = 2
    }
    
    // The underline view below the segmented control
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()
    
    //------------------------------------
    
    let bag = DisposeBag()
    var movieIdSubject = BehaviorSubject<String>(value: "")
    var movieDetailViewModel: MovieViewModel!
    
    //
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var pages: [UIViewController] = []
    var pageController: UIPageViewController!
    var topBarHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // statusBar + navbar
        topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        //
        setUpNavigationBar()
        //
        movieIdSubject
            .asObserver()
            .bind(to: movieDetailViewModel.movieIdSubject)
            .disposed(by: bag)
        //
        updateDetailUI()
        // segmentedControl
        
        setUpSegmentedControl()
        
        //
        
        presentPageVCOnView()
        let storyboard = UIStoryboard(name: "DetailPage", bundle: nil)
        let page1 = storyboard.instantiateViewController(withIdentifier: "DetailCastViewController")
        let page2 = storyboard.instantiateViewController(withIdentifier: "DetailReviewViewController")
        let page3 = storyboard.instantiateViewController(withIdentifier: "DetailMoreViewController")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        let vc = page1 as! DetailCastViewController
        let vc1 = page2 as! DetailReviewViewController
        let vc2 = page3 as! DetailMoreViewController
        vc.detailCastViewModel = self.movieDetailViewModel
        vc1.detailReviewViewModel = self.movieDetailViewModel
        vc2.detailMoreViewModel = self.movieDetailViewModel
        pageController.setViewControllers([page1], direction: .forward, animated: true, completion: nil)
    }
}

extension DetailViewController {
    func setUpNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func updateDetailUI() {
        let observable = movieDetailViewModel.movieDetailSubject
            .asObserver()
        observable
            .subscribe(onNext: { movieDetail in
                let backDropURLstr = MovieImageURL.imageURLHead + (movieDetail.backdrop_path ?? "")
                let backDropURL = URL(string: backDropURLstr)
                self.backDropImageView.kf.setImage(with: backDropURL, placeholder: UIImage(named: "default-image"))
                //
                let posterURLstr = MovieImageURL.imageURLHead + (movieDetail.poster_path ?? "")
                let posterURL = URL(string: posterURLstr)
                self.posterImageView.kf.setImage(with: posterURL, placeholder: UIImage(named: "default-image"))
            })
            .disposed(by: bag)
        observable.map { "\($0.title ?? "")" }
            .bind(to: movieNameLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { movieDetail in
                return movieDetail.genres
            }
            .bind(to: genreCollectionView.rx.items(cellIdentifier: "GenreCollectionViewCell", cellType: GenreCollectionViewCell.self)) {  _, genre, cell in
                cell.genreLabel.text = genre.name
            }
            .disposed(by: bag)
        observable
            .map { "\($0.vote_average)/10" }
            .bind(to: voteAverageLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { movieDetail in
                if movieDetail.original_language == "en" {
                    return "Language: English"
                }
                return "Language: " + (movieDetail.original_language ?? "")
            }
            .bind(to: languageLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { $0.release_date ?? "" }
            .bind(to: releaseTimeLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { $0.overview ?? "" }
            .bind(to: overviewLabel.rx.text)
            .disposed(by: bag)
    }
}

extension DetailViewController {
    func setUpSegmentedControl() {
        segmentedControlContainerView.addSubview(bottomUnderlineView)
        
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        // Select first segment by default
        segmentedControl.selectedSegmentIndex = 0
        
        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Constants.underlineViewColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        
        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Constants.underlineViewColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
            ])
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        changeSegmentedControlLinePosition()
    }
    
    // Change position of the underline
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        pageController.setViewControllers([pages[Int(segmentIndex)]], direction: .forward, animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.view.layoutIfNeeded()
        })
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
}
