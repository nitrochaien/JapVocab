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
    
    var model : AddMoreViewModel!
    var delegate: IAddMore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tvWord.delegate = self
//        tvDefinition.delegate = self
        
        model = AddMoreViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil {
            delegate.onReturnToMainViewController()
        }
    }
    
    @IBAction func onSaveWord(_ sender: Any) {
        let word = tvWord.text ?? ""
        let definition = tvDefinition.text ?? ""
        
        if word.isEmpty || definition.isEmpty {
            return
        }
        
        if model.wordIsExisted(word, definition: definition) {
            return
        }
        
        model.saveNewWord(word, definition: definition)
    }
    
    func showAlert(_ word: String, definition: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "The word \(word) or \(definition) is existed! Overwrite?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                self.model.saveNewWord(word, definition: definition)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
