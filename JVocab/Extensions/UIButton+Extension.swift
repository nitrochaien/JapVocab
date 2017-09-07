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
    func borderAndCorner() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
    }
}
