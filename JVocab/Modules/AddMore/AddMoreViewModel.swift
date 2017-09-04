//
//  AddMoreViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class AddMoreViewModel {
    
    var editWord = false
    var name = ""
    var meaning = ""
    
    fileprivate var words = [Word]()
    
    func fetchWords() {
        words = DBUtils.current.fetchData()
    }
    
    func saveNewWord(_ word: String, meaning: String, kan: String) {
        let context = DBUtils.current.getContext()
        let wordDB = Word(context: context)
        wordDB.word = word
        wordDB.last_update = Date() as NSDate
        
        let kanji = Kanji(context: context)
        kanji.meaning = meaning
        kanji.kanji = kan
        
        wordDB.addToKanjis(kanji)
        
        AppDelegate.shared().saveContext()
    }
    
    func isExisted(_ word:String, meaning: String, kanji: String) -> Bool {
        let selectedWord = getWordDBFrom(word)
        
        guard let existedWord = selectedWord else {
            return false
        }
        let meanings = DBUtils.current.getMeanings(existedWord)
        let result = meanings.contains { (key, value) -> Bool in
            return key == kanji && value == meaning
        }
        return result
    }
    
    func getWordDBFrom(_ word: String) -> Word? {
        var selectedWord: Word? = nil
        for wrd in words {
            let w = wrd.word
            if w == word {
                selectedWord = wrd
                break
            }
        }
        return selectedWord
    }

    func setEdit(_ name: String, meaning: String) {
        editWord = true
        self.name = name
        self.meaning = meaning
    }
    
    func isEditWord() -> Bool {
        if editWord {
            if name.isEmpty || meaning.isEmpty {
                return false
            }
        }
        return true
    }
    
    func resetState() {
        editWord = false
    }
}
