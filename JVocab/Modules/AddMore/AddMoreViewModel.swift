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
    fileprivate var name = ""
    fileprivate var definition = ""
    fileprivate var type = ListType.japanese
    fileprivate let context = AppDelegate.shared().persistentContainer.viewContext
    
    func saveNewWord(_ word: String, definition: String) {
        let info = validWord(word, definition: definition)
        
        if type == .japanese {
            let wordDB = WordDB(context: context)
            wordDB.name = info[0]
            wordDB.definition = info[1]
            wordDB.added_date = Date() as NSDate
            AppDelegate.shared().saveContext()
        } else if type == .chinese {
            let kanjiDB = KanjiDB(context: context)
            kanjiDB.name = info[0]
            kanjiDB.definition = info[1]
            kanjiDB.added_date = Date() as NSDate
            AppDelegate.shared().saveContext()
        }
    }
    
    func fetchJapData() -> [WordDB] {
        var list = [WordDB]()
        do {
            list = try context.fetch(WordDB.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        return list
    }
    
    func fetchChiData() -> [KanjiDB] {
        var list = [KanjiDB]()
        do {
            list = try context.fetch(KanjiDB.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        return list
    }
    
    func wordIsExisted(_ word: String, definition: String) -> Bool {
        if type == .japanese {
            let list = fetchJapData()
            for item in list {
                if item.name == word || item.definition == definition {
                    return true
                }
            }
            return false
        } else if type == .chinese {
            let list = fetchChiData()
            for item in list {
                if item.name == word || item.definition == definition {
                    return true
                }
            }
            return false
        }
        return false
    }
    
    func replaceJapWord(_ word: String) {
        let list = fetchJapData()
        
        var selectedItem : WordDB? = nil
        for item in list {
            if item.name == word {
                selectedItem = item
                break
            }
        }
        
        if let item = selectedItem {
            deleteJapWord(item)
            saveNewWord(item.name!, definition: item.definition!)
        }
    }
    
    func replaceChiWord(_ word: String) {
        let list = fetchChiData()
        
        var selectedItem : KanjiDB? = nil
        for item in list {
            if item.name == word {
                selectedItem = item
                break
            }
        }
        
        if let item = selectedItem {
            deleteChiWord(item)
            saveNewWord(item.name!, definition: item.definition!)
        }
    }
    
    func deleteJapWord(_ item: WordDB) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cant commit delete record")
        }
    }
    
    func deleteChiWord(_ item: KanjiDB) {
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
    
    func setEdit(_ name: String, definition: String, type: ListType) {
        editWord = true
        self.name = name
        self.definition = definition
        self.type = type
    }
    
    func setType(_ type: ListType) {
        self.type = type
    }
    
    func isEditWord() -> Bool {
        if editWord {
            if name.isEmpty || definition.isEmpty {
                return false
            }
        }
        return true
    }
    
    func getItemEditName() -> String {
        return name
    }
    
    func getItemEditDefinition() -> String {
        return definition
    }
    
    func getType() -> ListType {
        return type
    }
    
    func resetState() {
        editWord = false
    }
}
