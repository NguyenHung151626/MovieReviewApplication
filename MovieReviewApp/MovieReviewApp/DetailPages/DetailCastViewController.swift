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

class DetailCastViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var detailCastViewModel = MovieViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //truyền từ đâu vào label
    }

    override func viewDidAppear(_ animated: Bool) {
        let observable = detailCastViewModel.movieDetailCastSubject
            .asObserver()
        let test = observable
            .asDriver(onErrorJustReturn: MovieDetail(backdrop_path: nil, production_companies: nil))
            .map { movieDetail -> String in
                let companies = movieDetail.production_companies ?? []
                return self.listProductionCompany(companies: companies)
        }
        test
            .drive(label.rx.text)
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
