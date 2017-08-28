//
//  AddMoreViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class AddMoreViewModel {
    
    fileprivate var editWord = false
    fileprivate var itemToEdit: WordDB!
    
    func saveNewWord(_ word: String, definition: String) {
        let info = validWord(word, definition: definition)
        let context = AppDelegate.shared().persistentContainer.viewContext
        let wordDB = WordDB(context: context)
        wordDB.name = info[0]
        wordDB.definition = info[1]
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
    
    func replaceWord(_ word: String) {
        let list = fetchData()
        
        var selectedItem : WordDB? = nil
        for item in list {
            if item.name == word {
                selectedItem = item
                break
            }
        }
        
        if let item = selectedItem {
            deleteWord(item)
            saveNewWord(item.name!, definition: item.definition!)
        }
    }
    
    func deleteWord(_ item: WordDB) {
        let context = AppDelegate.shared().persistentContainer.viewContext
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cant commit delete record")
        }
    }
    
    func validWord(_ word: String, definition: String) -> [String] {
        let w = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let def = definition.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return [w, def]
    }
    
    func setEdit(_ item: WordDB) {
        editWord = true
        itemToEdit = item
    }
    
    func isEditWord() -> Bool {
        if editWord {
            if itemToEdit != nil {
                return true
            }
        }
        return false
    }
    
    func getItemEditName() -> String {
        return itemToEdit.name!
    }
    
    func getItemEditDefinition() -> String {
        return itemToEdit.definition!
    }
    
    func resetState() {
        editWord = false
    }
}
