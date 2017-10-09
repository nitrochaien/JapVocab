//
//  Sequence+Extension.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/13/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
