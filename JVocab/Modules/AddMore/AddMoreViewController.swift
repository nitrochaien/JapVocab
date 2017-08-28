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
    @IBOutlet weak var tvDefinition: UITextField!
    
    let model = AddMoreViewModel()
    var delegate: IAddMore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if model.isEditWord() {
            tvWord.text = model.getItemEditName()
            tvDefinition.text = model.getItemEditDefinition()
        }
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
        let definition = tvDefinition.text ?? ""
        
        if word.isEmpty || definition.isEmpty {
            return
        }
        
        if model.wordIsExisted(word, definition: definition) {
            if model.isEditWord() {
                if model.getItemEditName() == word && model.getItemEditDefinition() == definition {
                    navigationController?.popViewController(animated: true)
                    return
                }
            }
            showAlert(word)
            return
        }
        
        model.saveNewWord(word, definition: definition)
        if model.isEditWord() {
            navigationController?.popViewController(animated: true)
        } else {
            alertContinue()
        }
    }
    
    func showAlert(_ word: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "The word \(word) is existed! Overwrite?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                self.model.replaceWord(word)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                self.tvDefinition.text = ""
                self.tvWord.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setEdit(_ itemToEdit: WordDB) {
        model.setEdit(itemToEdit)
    }
}
