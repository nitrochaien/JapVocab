//
//  MainViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import CoreData

class MainViewModel {
    
    fileprivate var wordList = [WordDB]()
    
    static let refreshDataNotification = Notification.Name("refreshDataNotification")
    
    func fetchData() {
        let context = AppDelegate.shared().persistentContainer.viewContext
        do {
            let request: NSFetchRequest<WordDB> = WordDB.fetchRequest()
            var sortDescriptor = NSSortDescriptor.init(key: "added_date", ascending: true)
            sortDescriptor = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
            request.sortDescriptors = [sortDescriptor]
            wordList = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
        
        NotificationCenter.default.post(name: MainViewModel.refreshDataNotification, object: nil, userInfo: nil)
    }
    
    func reloadData() {
        wordList.removeAll()
        fetchData()
    }
    
    func getCount() -> Int {
        return wordList.count
    }
    
    func getWords() -> [WordDB] {
        return wordList
    }
    
    func getItemAtIndex(_ index: Int) -> WordDB {
        return wordList[index]
    }
    
    func deleteItemAtIndex(_ index: Int) {
        let item = wordList[index]
        let context = AppDelegate.shared().persistentContainer.viewContext
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cant commit delete record")
        }
        reloadData()
    }
}
