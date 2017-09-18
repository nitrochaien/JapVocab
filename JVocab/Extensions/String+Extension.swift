//
//  String+Extension.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

extension String {
    func splitCharacter() -> [String] {
        var split = [String]()
        for w in self.characters {
            split.append(String(w))
        }
        return split
    }
    
    var isHiragana: Bool {
        return self.range(of: "([ぁ-ん])", options: .regularExpression) != nil
    }
}
