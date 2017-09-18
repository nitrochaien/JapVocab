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
    
    fileprivate var correctAnswer = ""
    var answer = ""
    
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
        correctAnswer = answer
        
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
    
    func generateSelections(_ input: [String], numberOfSelections: Int) -> [String] {
        var result = [String]()
        result.append(contentsOf: input)
        var list = [String]()
        if correctAnswer.isHiragana {
            list = DBUtils.current.getAllHira()
        } else {
            list = DBUtils.current.getAllKata()
        }
        let filtered = Set(list).subtracting(input)
        let shuffledFilter = filtered.shuffled()
        for i in 0...numberOfSelections - 1 {
            result.append(shuffledFilter[i])
        }
        return result.shuffled()
    }
    
    func check() -> Bool {
        return answer == correctAnswer
    }

    func correctAnswerToStringArray() -> [String] {
        return correctAnswer.splitCharacter()
    }
    
    func getCorrectAnswer() -> String {
        return correctAnswer
    }
}
