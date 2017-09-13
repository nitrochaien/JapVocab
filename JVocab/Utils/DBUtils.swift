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
    
    let higarana = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","ゐ","ゑ","を", "ん"]
    let katakana = ["イ","ウ","エ","オ","カ","キ","ク","ケ","コ","サ","シ","ス","セ","ソ","タ","チ","ツ","テ","ト","ナ","ニ","ヌ","ネ","ノ","ハ","ヒ","フ","ヘ","ホ","マ","ミ","ム","メ","モ","ヤ","ユ","ヨ","ラ","リ","ル","レ","ロ","ワ","ヰ","ヱ","ヲ", "ン"]
    
    
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
        var kanjies = [Kanji]()
        do {
            let request: NSFetchRequest<Kanji> = Kanji.fetchRequest()
            var sortDescriptor = NSSortDescriptor.init(key: "kanji", ascending: true)
            sortDescriptor = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
            request.sortDescriptors = [sortDescriptor]
            kanjies = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
        
        return kanjies
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
    
    func getTranslate(_ word: Word) -> String {
        var value = [String]()
        let kanjies = word.kanjis?.allObjects as! [Kanji]
        for kanji in kanjies {
            value.append(kanji.meaning!)
        }
        return value.joined(separator: ",")
    }
    
    func getKanjiDB(_ word: Word) -> [Kanji] {
        guard let kanjiSet = word.kanjis else {
            return [Kanji]()
        }
        return kanjiSet.allObjects as! [Kanji]
    }
    
    func getWordFromDB(_ input: String) -> Word? {
        let words = DBUtils.current.fetchData()
        for word in words {
            if word.word! == input {
                return word
            }
        }
        return nil
    }

    func getAllMeanings() -> [String] {
        var result = [String]()
        let kanjies = fetchKanjies()
        for kanji in kanjies {
            result.append(kanji.meaning!)
        }
        return result
    }
    
    func getAllKana() -> [String] {
        return higarana + katakana
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
