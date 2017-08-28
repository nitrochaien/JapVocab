//
//  MultipleChoicesViewController.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/28/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class MultipleChoicesViewController: UIViewController {
    
    @IBOutlet weak var labelQuiz: UILabel!
    @IBOutlet weak var btnAns1: UIButton!
    @IBOutlet weak var btnAns2: UIButton!
    @IBOutlet weak var btnAns3: UIButton!
    @IBOutlet weak var btnAns4: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var labelResult: UILabel!
    
    let model = MultipleChoicesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
        
        //TODO: Add label to show how many words are correct
        //Check if there are not enough words to create multiple choices question ( < 4)
    }
    
    func initView() {
        edgesForExtendedLayout = []
        title = "Quiz"
        initButtons()
        
        labelResult = UILabel.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 50))
        labelResult.font = UIFont.init(name: "System", size: 30)
        labelResult.textAlignment = .center
        labelResult.backgroundColor = UIColor.gray
        view.addSubview(labelResult)
    }
    
    func initButtons() {
        setButtonBorder(btnAns1)
        setButtonBorder(btnAns2)
        setButtonBorder(btnAns3)
        setButtonBorder(btnAns4)
        
        btnAns1.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        btnAns2.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        btnAns3.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        btnAns4.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        
        btnContinue.addTarget(self, action: #selector(onRefreshQuiz), for: .touchUpInside)
    }
    
    func setButtonBorder(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.blue.cgColor
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 5
    }
    
    func initData() {
        model.setList()
        autoGenerateQuiz()
    }
    
    func autoGenerateQuiz() {
        if model.noWordsLeft() {
            showAlertReset()
            return
        }
        let object = model.generateQuesion()
        
        labelQuiz.text = object.question
        
        resetAllButtons()
        let correctAnsIndex = model.getCorrectIndex()
        
        switch correctAnsIndex {
        case 1:
            btnAns1.setTitle(object.correctAns, for: .normal)
            btnAns2.setTitle(object.wrongAns1, for: .normal)
            btnAns3.setTitle(object.wrongAns2, for: .normal)
            btnAns4.setTitle(object.wrongAns3, for: .normal)
            
            btnAns1.tag = 1
            break
        case 2:
            btnAns1.setTitle(object.wrongAns1, for: .normal)
            btnAns2.setTitle(object.correctAns, for: .normal)
            btnAns3.setTitle(object.wrongAns2, for: .normal)
            btnAns4.setTitle(object.wrongAns3, for: .normal)
            
            btnAns2.tag = 1
            break
        case 3:
            btnAns1.setTitle(object.wrongAns1, for: .normal)
            btnAns2.setTitle(object.wrongAns2, for: .normal)
            btnAns3.setTitle(object.correctAns, for: .normal)
            btnAns4.setTitle(object.wrongAns3, for: .normal)
            
            btnAns3.tag = 1
            break
        case 4:
            btnAns1.setTitle(object.wrongAns1, for: .normal)
            btnAns2.setTitle(object.wrongAns2, for: .normal)
            btnAns3.setTitle(object.wrongAns3, for: .normal)
            btnAns4.setTitle(object.correctAns, for: .normal)
            
            btnAns4.tag = 1
            break
        default:
            break
        }
    }
    
    func resetAllButtons() {
        btnAns1.setTitle("", for: .normal)
        btnAns2.setTitle("", for: .normal)
        btnAns3.setTitle("", for: .normal)
        btnAns4.setTitle("", for: .normal)
        
        btnAns1.tag = 0
        btnAns2.tag = 0
        btnAns3.tag = 0
        btnAns4.tag = 0
    }
    
    func setButtonsState(_ state: Bool) {
        btnAns1.isEnabled = state
        btnAns2.isEnabled = state
        btnAns3.isEnabled = state
        btnAns4.isEnabled = state
    }
    
    func onSelect(_ sender: UIButton) {
        showResult(sender.tag == 1)
    }
    
    func onRefreshQuiz(_ sender: UIButton) {
        autoGenerateQuiz()
    }
    
    func showAlertReset() {
        let alert = UIAlertController(title: "Alert", message: "You've reviewed all words! Take another tour?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            self.model.resetCurrentList()
            self.autoGenerateQuiz()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func showResult(_ correct: Bool) {
        setButtonsState(false)
        if correct {
            labelResult.textColor = UIColor.blue
            labelResult.text = "CORRECT!!"
        } else {
            labelResult.textColor = UIColor.red
            labelResult.text = "Oh no...Please try again..."
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.labelResult.frame
            frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - frame.height * 3, width: frame.width, height: frame.height)
            self.labelResult.frame = frame
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                var frame = self.labelResult.frame
                frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: frame.width, height: frame.height)
                self.labelResult.frame = frame
                self.setButtonsState(true)
                
                if correct {
                    self.autoGenerateQuiz()
                }
            })
        })
    }
}
