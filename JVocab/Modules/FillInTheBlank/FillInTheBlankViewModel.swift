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
        return currentList.isEmpty
    }
    
    func reset() {
        currentList = DBUtils.current.fetchKanjies()
    }
    
    func noWords() -> Bool {
        return DBUtils.current.fetchKanjies().isEmpty
    }
    
    func generateSelections(_ input: [String], num: Int) -> [String] {
        var result = [String]()
        result.append(contentsOf: input)
        let count = num - result.count
        var list = DBUtils.current.getAllKana()
        for _ in 0...count {
            let randomQuizIndex = Int(arc4random_uniform(UInt32(list.count)))
            let kana = list.remove(at: randomQuizIndex)
            result.append(kana)
        }
        var kana = ""
        repeat {
            let randomQuizIndex = Int(arc4random_uniform(UInt32(list.count)))
            kana = list.remove(at: randomQuizIndex)
        } while !input.contains(kana) && list
    }
}
