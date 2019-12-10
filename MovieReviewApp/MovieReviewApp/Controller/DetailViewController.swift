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

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
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
        let observable = movieDetailViewModel.movieDetailSubject
            .asObserver()
        
        observable
            .subscribe(onNext: { movieDetail in
                let urlstr = MovieImageURL.imageURLHead + (movieDetail.backdrop_path ?? "")
                let url = URL(string: urlstr)
                self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "default-image"))
            })
            .disposed(by: bag)
        
        
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
}
