//
//  UIImageView+Rotate.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/13/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit

extension UIImageView {
    func rotate180degrees() {
        let degrees: CGFloat = 180.0
        let radians: CGFloat = degrees * (.pi / 180)
        transform = CGAffineTransform(rotationAngle: radians)
    }
}
