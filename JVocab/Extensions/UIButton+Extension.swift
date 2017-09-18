//
//  UIButton+Extension.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/7/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func borderAndCorner(_ color: UIColor = .blue) {
        self.layer.cornerRadius = 5
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func selectionStyle() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.blue
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
