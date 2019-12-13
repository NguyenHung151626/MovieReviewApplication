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
import MXSegmentedPager
import MXParallaxHeader

class DetailViewController: UIViewController, MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, MXScrollViewDelegate {
    @IBOutlet weak var scrollView: MXScrollView!
    @IBOutlet weak var segmentedPager: MXSegmentedPager!
    @IBOutlet weak var contentView: UIView!
    
    private enum SegmentColor {
        static let underlineColor = UIColor(red: 2.0/255.0, green: 148.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        static let textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    }
    
    let bag = DisposeBag()
    var movieIdSubject = BehaviorSubject<String>(value: "")
    //if publish emit immediately, the id is received before the viewDidLoad
    var movieDetailViewModel: MovieViewModel!

    var pages: [UIViewController] = []
    let headerView = DetailHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setUpNavigationBar()
        //
        movieIdSubject
            .asObserver()
            .bind(to: movieDetailViewModel.movieIdViewModelSubject)
            .disposed(by: bag)
        //
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 500
        scrollView.parallaxHeader.mode = .bottom
        
        //bind UI of headerView
        bindingUIComponentsHeaderView(headerView: headerView)
        
        //
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        
        segmentedPager.backgroundColor = .white
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = SegmentColor.textColor
        segmentedPager.segmentedControl.selectedTextColor = SegmentColor.underlineColor
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = SegmentColor.underlineColor
        segmentedPager.segmentedControl.font = UIFont(name: "AppleGothic", size: 13.0)!

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
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        headerView.hiddenViewHeight.constant = topBarHeight
        scrollView.delegate = self
        //
        scrollView.parallaxHeader.minimumHeight = view.safeAreaInsets.top + topBarHeight
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return pages.count
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let page = pages[index]
        return page.view
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Cast", "Reviews", "More"][index]
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != headerView.genreCollectionView {
            if scrollView.contentOffset.y < -88 {
                headerView.hiddenView.setIsHidden(true, animated: true)
            } else {
                headerView.hiddenView.setIsHidden(false, animated: true)
            }
        }
    }
}


extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
}

extension DetailViewController {
    func bindingUIComponentsHeaderView(headerView: DetailHeaderView) {
        let observable = movieDetailViewModel.movieDetailSubject
            .asObserver()
        observable
            .subscribe(onNext: { movieDetail in
                let backDropURLstr = MovieImageURL.imageURLHead + (movieDetail.backdrop_path ?? "")
                let backDropURL = URL(string: backDropURLstr)
                headerView.backDropImageView.kf.setImage(with: backDropURL, placeholder: UIImage(named: "default-image"))
                //
                let posterURLstr = MovieImageURL.imageURLHead + (movieDetail.poster_path ?? "")
                let posterURL = URL(string: posterURLstr)
                headerView.posterImageView.kf.setImage(with: posterURL, placeholder: UIImage(named: "default-image"))
            })
            .disposed(by: bag)
        observable.map { "\($0.title ?? "")" }
            .bind(to: headerView.movieNameLabel.rx.text)
            .disposed(by: bag)
        observable.map { "\($0.title ?? "")" }
            .bind(to: headerView.movieNameHiddenLabel.rx.text)
            .disposed(by: bag)
        //genre register
        headerView.genreCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCollectionViewCell")
        headerView.genreCollectionView.delegate = self
        observable
            .map { movieDetail in
                return movieDetail.genres
            }
            .bind(to: headerView.genreCollectionView.rx.items(cellIdentifier: "GenreCollectionViewCell", cellType: GenreCollectionViewCell.self)) {  _, genre, cell in
                cell.genreLabel.text = genre.name
            }
            .disposed(by: bag)
        observable
            .map { "\($0.vote_average)/10" }
            .bind(to: headerView.voteAverageLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { movieDetail in
                if movieDetail.original_language == "en" || movieDetail.original_language == "us" {
                    return "Language: English"
                }
                return "Language: " + (movieDetail.original_language ?? "")
            }
            .bind(to: headerView.languageLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { $0.release_date ?? "" }
            .bind(to: headerView.releaseTimeLabel.rx.text)
            .disposed(by: bag)
        observable
            .map { $0.overview ?? "" }
            .bind(to: headerView.overviewLabel.rx.text)
            .disposed(by: bag)
    }
}
