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
    var words = [Word]()
    
    fileprivate let context = AppDelegate.shared().persistentContainer.viewContext
    
    static let refreshDataNotification = Notification.Name("refreshDataNotification")
    
    func fetchWords() {
        words = DBUtils.current.fetchData()
    }
    
    func reloadData() {
        words.removeAll()
        fetchWords()
        NotificationCenter.default.post(name: MainViewModel.refreshDataNotification, object: nil, userInfo: nil)
    }
    
    func getMeaningFrom(_ indexPath: IndexPath) -> [Kanji] {
        let word = words[indexPath.row]
        return DBUtils.current.getMeaningsOf(word)
    }
    
    func deleteItemAt(_ indexPath: IndexPath) {
        let word = words[indexPath.row]
        DBUtils.current.delete(word)
        reloadData()
    }
}
