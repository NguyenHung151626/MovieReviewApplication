//
//  UIImageView+cornerRadius.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/6/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func download(url: String?, rounded: Bool = true, cornerRadius: CGFloat) {
        guard let _url = url else {
            return
        }
        if rounded {
            let processor = ResizingImageProcessor(referenceSize: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: cornerRadius, targetSize: nil, roundingCorners: [.topLeft, .topRight], backgroundColor: .lightGray)
            self.kf.setImage(with: URL(string: _url), placeholder: UIImage(named: "default-image"), options: [.processor(processor)])
        } else {
            self.kf.setImage(with: URL(string: _url), placeholder: UIImage(named: "default-image"))
        }
    }
}

