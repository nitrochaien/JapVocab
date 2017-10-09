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
    @IBOutlet var scrollView: UIScrollView!
    
    let model = AddMoreViewModel()
    var delegate: IAddMore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.borderAndCorner()
        labelAlert.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertEnterKanji), name: AddMoreViewModel.enterKanjiNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wordIsSaved), name: AddMoreViewModel.savedWordNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AddMoreViewModel.enterKanjiNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AddMoreViewModel.savedWordNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil {
            delegate.onReturnToMainViewController()
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
            if model.name == word && model.meaning == meaning {
                navigationController?.popViewController(animated: true)
                return
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
    
    func showEmptyInputAlert() {
        labelAlert.text = "Please enter both 'word' and 'meaning' to save."
        labelAlert.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.labelAlert.isHidden = true
        })
    }
    
    @objc func showAlertEnterKanji() {
        labelAlert.text = "'Kanji' must not empty."
        labelAlert.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.labelAlert.isHidden = true
        })
    }
    
    @objc func wordIsSaved() {
        updateWordIsSavedUI()
    }
}

extension AddMoreViewController {
    @objc func keyboardWillShow(withNotification notification: Notification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(withNotification notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
