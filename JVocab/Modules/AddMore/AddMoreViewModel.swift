//
//  AddMoreViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class AddMoreViewModel {
    
    func saveNewWord(_ word: String, definition: String) {
        let context = AppDelegate.shared().persistentContainer.viewContext
        let wordDB = WordDB(context: context)
        wordDB.name = word
        wordDB.definition = definition
        wordDB.added_date = Date() as NSDate
        AppDelegate.shared().saveContext()
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
    
    func wordIsExisted(_ word: String, definition: String) -> Bool {
        let list = fetchData()
        for item in list {
            if item.name == word || item.definition == definition {
                return true
            }
        }
        return false
    }
}
