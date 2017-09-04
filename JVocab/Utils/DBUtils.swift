//
//  DBUtils.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 8/31/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import CoreData

class DBUtils {
    static let current = DBUtils()
    
    fileprivate let context = AppDelegate.shared().persistentContainer.viewContext
    
    func fetchData() -> [Word] {
        var words = [Word]()
        do {
            let request: NSFetchRequest<Word> = Word.fetchRequest()
            var sortDescriptor = NSSortDescriptor.init(key: "last_update", ascending: true)
            sortDescriptor = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
            request.sortDescriptors = [sortDescriptor]
            words = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
        
        return words
    }
    
    func fetchKanjies() -> [Kanji] {
        var list = [Kanji]()
        let words = fetchData()
        
        for word in words {
            guard let kanjiSet = word.kanjis else {
                return list
            }
            let kanjies = kanjiSet.allObjects as! [Kanji]
            for kanji in kanjies {
                list.append(kanji)
            }
        }
        return list
    }
    
    func getMeanings(_ word: Word) -> [String : String] {
        var results = [String : String]()
        
        guard let kanjiSet = word.kanjis else {
            return results
        }
        let kanjies = kanjiSet.allObjects as! [Kanji]
        let count = kanjies.count
        for i in 0...count-1 {
            let kanji = kanjies[i]
            results[kanji.kanji!] = kanji.meaning!
        }
        return results
    }
    
    func getMeaningsOf(_ word: Word) -> [Kanji] {
        guard let kanjiSet = word.kanjis else {
            return [Kanji]()
        }
        return kanjiSet.allObjects as! [Kanji]
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    func delete(_ word: Word) {
        context.delete(word)
        do {
            try context.save()
        } catch {
            print("Delete failed")
        }
    }
}
