//
//  MainViewModel.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class MainViewModel {
    
    fileprivate var wordList = [WordDB]()
    
    static let refreshDataNotification = Notification.Name("refreshDataNotification")
    
    func fetchData() {
        let context = AppDelegate.shared().persistentContainer.viewContext
        do {
            wordList = try context.fetch(WordDB.fetchRequest())
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
    
    func getItemAtIndex(_ index: Int) -> WordDB {
        return wordList[index]
    }
}
