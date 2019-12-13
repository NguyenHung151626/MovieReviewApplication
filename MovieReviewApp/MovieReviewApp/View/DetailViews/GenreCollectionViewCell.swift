//
//  GenreCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/11/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    var genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView() {
        addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: genreLabel.trailingAnchor, constant: 10).isActive = true
        genreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        genreLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
        genreLabel.font = UIFont(name: "AppleGothic", size: 13.0)
    }
}
