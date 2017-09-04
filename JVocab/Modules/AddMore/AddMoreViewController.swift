//
//  AddMoreViewController.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

protocol IAddMore {
    func onReturnToMainViewController();
}

class AddMoreViewController: UIViewController {
    
    @IBOutlet weak var tvWord: UITextField!
    @IBOutlet weak var tvMeaning: UITextField!
    @IBOutlet var tvKanji: UITextField!
    @IBOutlet weak var button: UIButton!
    
    let model = AddMoreViewModel()
    var delegate: IAddMore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if model.isEditWord() {
//            tvWord.text = model.getItemEditName()
//            tvMeaning.text = model.getItemEditmeaning()
//            title = "Edit"
//        } else {
//            title = "Add new"
//        }
        
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil {
            delegate.onReturnToMainViewController()
//            model.resetState()
        }
    }
    
    @IBAction func onSaveWord(_ sender: Any) {
        let word = tvWord.text ?? ""
        let meaning = tvMeaning.text ?? ""
        let kanji = tvKanji.text ?? ""
        
        if word.isEmpty || meaning.isEmpty || kanji.isEmpty {
            return
        }
        
        if model.isExisted(word, meaning: meaning, kanji: kanji) {
            if model.isEditWord() {
                if model.name == word && model.meaning == meaning {
                    navigationController?.popViewController(animated: true)
                    return
                }
            }
            return
        }
        
        model.saveNewWord(word, meaning: meaning, kan: kanji)
        if model.isEditWord() {
            navigationController?.popViewController(animated: true)
        } else {
            alertContinue()
        }
    }
    
    func alertContinue() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Word is added. Add more?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "No, Take me back", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: { (action) in
                self.tvWord.text = ""
                self.tvMeaning.text = ""
                self.tvWord.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setEdit(_ name: String, meaning: String) {
        model.setEdit(name, meaning: meaning)
    }
}
