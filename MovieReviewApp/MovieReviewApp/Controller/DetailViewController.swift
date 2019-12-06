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
    @IBOutlet weak var productionCompanyLabel: UILabel!
    
    let bag = DisposeBag()
    var movieIdSubject = BehaviorSubject<String>(value: "")
    var movieDetailViewModel: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieIdSubject
            .asObserver()
            .bind(to: movieDetailViewModel.movieIdSubject)
            .disposed(by: bag)
        movieDetailViewModel.movieDetailSubject
            .asObserver()
            .asDriver(onErrorJustReturn: MovieDetail(backdrop_path: nil, production_companies: nil))
            .map { movieDetail -> String in
                let companies = movieDetail.production_companies ?? []
                return self.listProductionCompany(companies: companies)
            }
            .drive(productionCompanyLabel.rx.text)
            .disposed(by: bag)
    }
    
    func listProductionCompany(companies: [ProductionCompany]) -> String {
        var companyNames = ""
        for company in companies {
            let endIndex = companyNames.endIndex
            companyNames.insert(contentsOf: (company.name ?? "") + ", ", at: endIndex)
        }
        if companies.count != 0 {
            companyNames.remove(at: companyNames.index(before: companyNames.endIndex))
            companyNames.remove(at: companyNames.index(before: companyNames.endIndex))
        }
        return companyNames
    }
}
