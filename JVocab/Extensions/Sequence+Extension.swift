//
//  Sequence+Extension.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/13/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
