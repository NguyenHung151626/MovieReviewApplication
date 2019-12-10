//
//  ExtensionDetailViewController.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/9/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension DetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDelegate, UIScrollViewDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == 0 {
            return pages[pages.count - 1]
        } else {
            let previousIndex = abs((currentIndex - 1) % pages.count)
            return pages[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        let previousIndex = abs((currentIndex + 1) % pages.count)
        return pages[previousIndex]
    }
    
    func presentPageVCOnView() {
        let storyboard = UIStoryboard(name: "DetailPage", bundle: nil)
        pageController = storyboard.instantiateViewController(withIdentifier: "DetailPageViewController") as! DetailPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        contentView.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        //
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        pageController.view.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        pageController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pageController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let review = pageController.viewControllers?.first as? DetailReviewViewController {
            review.tableView.delegate = self
            if scrollView == review.tableView {
                let y1 = scrollView.contentOffset.y
                if y1 <= 0 {
                    self.scrollView.isScrollEnabled = true
                    scrollView.isScrollEnabled = false
                }
            }
            
            if scrollView == self.scrollView {
                let y = scrollView.contentOffset.y
                if y >= (imageView.frame.height - topBarHeight) {
                    scrollView.isScrollEnabled = false
                    review.tableView.isScrollEnabled = true
                }
            }
        }
        if let more = pageController.viewControllers?.first as? DetailMoreViewController {
            more.tableView.delegate = self
            if scrollView == more.tableView {
                let y1 = scrollView.contentOffset.y
                if y1 <= 0 {
                    self.scrollView.isScrollEnabled = true
                    scrollView.isScrollEnabled = false
                }
            }
            
            if scrollView == self.scrollView {
                let y = scrollView.contentOffset.y
                if y >= (imageView.frame.height - topBarHeight) {
                    scrollView.isScrollEnabled = false
                    more.tableView.isScrollEnabled = true
                }
            }
        }
    }
}
