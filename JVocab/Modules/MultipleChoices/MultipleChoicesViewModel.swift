//
//  MultipleChoicesViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/28/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class MultipleChoicesViewModel {
    
    fileprivate var currentList = [WordDB]()
    fileprivate var selectedIndexes = [Int]()
    fileprivate var sessionCorrectAnswer: Int = 0
    fileprivate var allWords = [WordDB]()
    
    static let updateCorrectAnswerNotification = Notification.Name("updateCorrectAnswerNotification")
    
    func setList() {
        allWords = fetchData()
        resetCurrentList()
    }
    
    func resetCurrentList() {
        currentList = fetchData()
        sessionCorrectAnswer = 0
    }
    
    func generateQuesion() -> MultipleChoicesObj {
        let randomQuizIndex = Int(arc4random_uniform(UInt32(currentList.count)))
        let indexOfAllWords = getTrueIndex(randomQuizIndex)
        let selectedItem = currentList.remove(at: randomQuizIndex)
        selectedIndexes.append(indexOfAllWords)
        
        let randomWrongAns1 = getWrongQuizIndex(randomQuizIndex)
        let wrongAnsItem1 = allWords[randomWrongAns1]
        
        let randomWrongAns2 = getWrongQuizIndex(randomQuizIndex)
        let wrongAnsItem2 = allWords[randomWrongAns2]
        
        let randomWrongAns3 = getWrongQuizIndex(randomQuizIndex)
        let wrongAnsItem3 = allWords[randomWrongAns3]
        
        selectedIndexes.removeAll()
        
        let object = MultipleChoicesObj()
        object.question = selectedItem.name
        object.correctAns = selectedItem.definition
        object.wrongAns1 = wrongAnsItem1.definition
        object.wrongAns2 = wrongAnsItem2.definition
        object.wrongAns3 = wrongAnsItem3.definition
        
        return object
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
    
    func fetchData() -> [WordDB] {
        var list = [WordDB]()
            
        let context = AppDelegate.shared().persistentContainer.viewContext
        do {
            list = try context.fetch(WordDB.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
            
        return list
    }
    
    func getCorrectIndex() -> Int {
        return Int(arc4random_uniform(4) + 1)
    }
    
    func getWrongQuizIndex(_ correctIndex: Int) -> Int {
        var index = -1
        repeat {
            index = Int(arc4random_uniform(UInt32(allWords.count)))
        } while selectedIndexes.contains(index)
        selectedIndexes.append(index)
        return index
    }
    
    func updateTempListAndGetWrongAns(_ index: Int, list: [WordDB]) -> WordDB {
        let item = currentList[index]
        var result = WordDB()
        var array = list
        
        for i in 0...array.count - 1 {
            let tempItem = array[i]
            if tempItem == item {
                result = array.remove(at: i)
                break
            }
        }
        return result
    }
    
    func getTrueIndex(_ index: Int) -> Int {
        let item = currentList[index]
        var value = -1
        
        for i in 0...allWords.count - 1 {
            let word = allWords[i]
            if word == item {
                value = i
                break
            }
        }
        return value
    }
    
    func enoughWords() -> Bool {
        return allWords.count >= 4
    }
}
