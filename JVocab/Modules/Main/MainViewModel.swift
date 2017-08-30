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
    
    fileprivate var japList = [WordDB]()
    fileprivate var chiList = [KanjiDB]()
    
    fileprivate let context = AppDelegate.shared().persistentContainer.viewContext
    
    static let refreshDataNotification = Notification.Name("refreshDataNotification")
    
    func fetchJapaneseWords() {
        do {
            let request: NSFetchRequest<WordDB> = WordDB.fetchRequest()
            var sortDescriptor = NSSortDescriptor.init(key: "added_date", ascending: true)
            sortDescriptor = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
            request.sortDescriptors = [sortDescriptor]
            japList = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
        
        NotificationCenter.default.post(name: MainViewModel.refreshDataNotification, object: nil, userInfo: nil)
    }
    
    func fetchChineseWords() {
        do {
            let request: NSFetchRequest<KanjiDB> = KanjiDB.fetchRequest()
            var sortDescriptor = NSSortDescriptor.init(key: "added_date", ascending: true)
            sortDescriptor = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
            request.sortDescriptors = [sortDescriptor]
            chiList = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
        
        NotificationCenter.default.post(name: MainViewModel.refreshDataNotification, object: nil, userInfo: nil)
    }
    
    func reloadData() {
        japList.removeAll()
        fetchJapaneseWords()
    }
    
    func getCount() -> Int {
        return japList.count
    }
    
    func getWords() -> [WordDB] {
        return japList
    }
    
    func getItemAtIndex(_ index: Int) -> WordDB {
        return japList[index]
    }
    
    func deleteItemAtIndex(_ index: Int) {
        let item = japList[index]
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cant commit delete record")
        }
        reloadData()
    }
}
