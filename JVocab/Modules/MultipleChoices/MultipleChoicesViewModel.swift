//
//  MultipleChoicesViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/28/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class MultipleChoicesViewModel {
    fileprivate var allMeanings = [String]()
    fileprivate var sessionCorrectAnswer: Int = 0
    fileprivate var allWords = [Kanji]()
    fileprivate var currentList = [Kanji]()
    
    static let updateCorrectAnswerNotification = Notification.Name("updateCorrectAnswerNotification")
    
    func setList() {
        allWords = DBUtils.current.fetchKanjies()
        resetCurrentList()
    }
    
    func resetCurrentList() {
        currentList = DBUtils.current.fetchKanjies()
        sessionCorrectAnswer = 0
    }
    
    func generateQuesion() -> MultipleChoicesObj {
        let correctQA = getCorrectQA()
        let wrongAns1 = generateWrongAnswer()
        let wrongAns2 = generateWrongAnswer()
        let wrongAns3 = generateWrongAnswer()
        
        allMeanings.removeAll()
        
        let object = MultipleChoicesObj()
        object.question = correctQA[0]
        object.correctAns = correctQA[1]
        object.wrongAns1 = wrongAns1
        object.wrongAns2 = wrongAns2
        object.wrongAns3 = wrongAns3
        
        print("Question set:")
        print("question:\(object.question!)")
        print("correct answer:\(object.correctAns!)")
        print("wrong answer 1:\(object.wrongAns1!)")
        print("wrong answer 2:\(object.wrongAns2!)")
        print("wrong answer 3:\(object.wrongAns3!)")
        
        return object
    }
    
    func getCorrectQA() -> [String] {
        let randomQuizIndex = Int(arc4random_uniform(UInt32(currentList.count)))
        let kanji = currentList.remove(at: randomQuizIndex)
        if let answer = kanji.meaning {
            if let question = kanji.word?.word {
                allMeanings.append(answer)
                return [question, answer]
            }
        }
        return ["", ""]
    }
    
    func generateWrongAnswer() -> String {
        var meaning = ""
        repeat {
            let ranIndex = Int(arc4random_uniform(UInt32(allWords.count)))
            meaning = allWords[ranIndex].meaning!
        } while allMeanings.contains(meaning)
        allMeanings.append(meaning)
        return meaning
    }
    
    func noWordsLeft() -> Bool {
        return currentList.isEmpty
    }
    
    func wordsRemaining() -> Int {
        return currentList.count
    }
    
    func getCount() -> Int {
        return allWords.count
    }
    
    func getCorrectAnswer() -> Int {
        return sessionCorrectAnswer
    }
    
    func updateCorrect() {
        sessionCorrectAnswer += 1
        NotificationCenter.default.post(name: MultipleChoicesViewModel.updateCorrectAnswerNotification, object: nil, userInfo: nil)
    }
    
    func getCorrectIndex() -> Int {
        return Int(arc4random_uniform(4) + 1)
    }
    
    func enoughWords() -> Bool {
        return allWords.count >= 4
    }
}
