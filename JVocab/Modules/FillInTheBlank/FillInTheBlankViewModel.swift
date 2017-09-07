//
//  FillInTheBlankViewModel.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 8/31/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class FillInTheBlankViewModel {
    var currentList = [Kanji]()
    
    init() {
        currentList = DBUtils.current.fetchKanjies()
    }
    
    func generateQuestion() -> FillInTheBlankObj {
        var question = ""
        var answer = ""
        let randomQuizIndex = Int(arc4random_uniform(UInt32(currentList.count)))
        let kanjiDB = currentList.remove(at: randomQuizIndex)
        question = kanjiDB.meaning!
        if let word = kanjiDB.word {
            answer = word.word!
        }
        let obj = FillInTheBlankObj()
        obj.question = question
        obj.answer = answer
        return obj
    }
    
    func finished() -> Bool {
        return currentList.count == 0
    }
    
    func reset() {
        currentList = DBUtils.current.fetchKanjies()
    }
}
