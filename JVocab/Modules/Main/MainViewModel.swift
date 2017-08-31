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
    
    fileprivate var type = ListType.japanese
    
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
    }
    
    func reloadData(_ type : ListType) {
        japList.removeAll()
        chiList.removeAll()
        
        self.type = type
        
        if type == .japanese {
            fetchJapaneseWords()
        } else if type == .chinese {
            fetchChineseWords()
        }
        
        NotificationCenter.default.post(name: MainViewModel.refreshDataNotification, object: nil, userInfo: nil)
    }
    
    func reloadData() {
        reloadData(type)
    }
    
    func getCount() -> Int {
        return type == .japanese ? japList.count : chiList.count
    }
    
    func getJapWords() -> [WordDB] {
        return japList
    }
    
    func getChiWords() -> [KanjiDB] {
        return chiList
    }
    
    func getJapAtIndex(_ index: Int) -> WordDB {
        return japList[index]
    }
    
    func getChiAtIndex(_ index: Int) -> KanjiDB {
        return chiList[index]
    }
    
    func getType() -> ListType {
        return type
    }
    
    func deleteItemAtIndex(_ index: Int) {
        if type == .japanese {
            let item = japList[index]
            context.delete(item)
            do {
                try context.save()
            } catch {
                print("Cant commit delete record")
            }
        } else if type == .chinese {
            let item = chiList[index]
            context.delete(item)
            do {
                try context.save()
            } catch {
                print("Cant commit delete record")
            }
        }
        reloadData()
    }
}
