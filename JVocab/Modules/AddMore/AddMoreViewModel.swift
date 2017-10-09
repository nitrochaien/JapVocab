//
//  AddMoreViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class AddMoreViewModel {
    var name = ""
    var meaning = ""
    
    fileprivate var words = [Word]()
    
    static let enterKanjiNotification = Notification.Name("enterKanjiNotification")
    static let savedWordNotification = Notification.Name("savedWordNotification")
    
    func fetchWords() {
        words = DBUtils.current.fetchData()
    }
    
    func saveNewWord(_ word: String, meaning: String, kan: String) {
        let context = DBUtils.current.getContext()
        
        let newKanji = Kanji(context: context)
        newKanji.meaning = meaning
        newKanji.kanji = kan
        
        //If word is existed, append new meaning to the word
        if existedWord(word) {
            if kan.isEmpty {
                NotificationCenter.default.post(name: AddMoreViewModel.enterKanjiNotification, object: nil, userInfo: nil)
                return
            }
            if let wordDB = DBUtils.current.getWordFromDB(word) {
                wordDB.addToKanjis(newKanji)
            }
        } else { //Otherwise, create new word
            let wordDB = Word(context: context)
            wordDB.word = word
            wordDB.last_update = Date()
            
            wordDB.addToKanjis(newKanji)
        }
        AppDelegate.shared().saveContext()
        
        NotificationCenter.default.post(name: AddMoreViewModel.savedWordNotification, object: nil, userInfo: nil)
    }
    
    func isExisted(_ meaning: String) -> Bool {
        let kanjies = DBUtils.current.fetchKanjies()
        for kanji in kanjies {
            if kanji.meaning == meaning {
                return true
            }
        }
        return false
    }
    
    func existedWord(_ input: String) -> Bool {
        let words = DBUtils.current.fetchData()
        for word in words {
            if word.word! == input {
                return true
            }
        }
        return false
    }
}
