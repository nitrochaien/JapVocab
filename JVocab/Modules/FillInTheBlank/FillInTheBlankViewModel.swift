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
    var correctAns = 0
    let words = DBUtils.current.fetchKanjies()
    
    init() {
        currentList = words
    }
    
    func generateQuestion() -> FillInTheBlankObj {
        if correctAns == words.count {
            //TODO: ask if want to take another tour
            //If yes, reset currentList & correctAns
        }
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
}
