//
//  DetailMoreTableViewCell.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/10/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit

class DetailMoreTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
