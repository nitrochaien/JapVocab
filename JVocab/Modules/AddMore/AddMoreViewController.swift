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
    @IBOutlet var labelAlert: UILabel!
    
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
        
        button.borderAndCorner()
        labelAlert.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertEnterKanji), name: AddMoreViewModel.enterKanjiNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wordIsSaved), name: AddMoreViewModel.savedWordNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AddMoreViewModel.enterKanjiNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AddMoreViewModel.savedWordNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil {
            delegate.onReturnToMainViewController()
            model.resetState()
        }
    }
    
    @IBAction func onSaveWord(_ sender: Any) {
        let word = tvWord.text ?? ""
        let meaning = tvMeaning.text ?? ""
        let kanji = tvKanji.text ?? ""
        
        if word.isEmpty || meaning.isEmpty {
            showEmptyInputAlert()
            return
        }
        
        //check if meaning is existed
        if model.isExisted(meaning) {
            if model.isEditWord() {
                if model.name == word && model.meaning == meaning {
                    navigationController?.popViewController(animated: true)
                    return
                }
            }
            return
        }
        model.saveNewWord(word, meaning: meaning, kan: kanji)
    }
    
    func updateWordIsSavedUI() {
        labelAlert.text = "Yay we've got a new word!!\nLet's add another one."
        labelAlert.isHidden = false
        labelAlert.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.labelAlert.isHidden = true
        })
        tvWord.text = ""
        tvMeaning.text = ""
        tvKanji.text = ""
        tvWord.becomeFirstResponder()
    }
    
    func setEdit(_ name: String, meaning: String) {
        model.setEdit(name, meaning: meaning)
    }
    
    func showEmptyInputAlert() {
        labelAlert.text = "Please enter both 'word' and 'meaning' to save."
        labelAlert.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.labelAlert.isHidden = true
        })
    }
    
    func showAlertEnterKanji() {
        labelAlert.text = "'Kanji' must not empty."
        labelAlert.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.labelAlert.isHidden = true
        })
    }
    
    func wordIsSaved() {
        if model.isEditWord() {
            navigationController?.popViewController(animated: true)
        } else {
            updateWordIsSavedUI()
        }
    }
}
