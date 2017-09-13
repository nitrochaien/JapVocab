//
//  FillInTheBlankViewController.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 8/31/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import Foundation

class FillInTheBlankViewController: UIViewController {

    @IBOutlet var labelQuestion: UILabel!
    @IBOutlet var viewAnswer: UIView!
    @IBOutlet var btnAnswer: UIButton!
    @IBOutlet var btnNextQuestion: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewAnswerHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCorrectAnswer: UILabel!
    @IBOutlet var viewSelection: UIView!
    @IBOutlet var viewSelectionHeight: NSLayoutConstraint!
    
    let model = FillInTheBlankViewModel()
    let navigationBarHeight:CGFloat = 64
    var correctAnswer = ""
    var answer = ""
    var labelResult: UILabel!
    var inputViews = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
    }
    
    func initView() {
        btnAnswer.borderAndCorner()
        btnNextQuestion.borderAndCorner()
        btnSubmit.borderAndCorner()
        labelCorrectAnswer.isHidden = true
        
        labelResult = UILabel.init(frame: CGRect.init(x: 0, y: -50, width: UIScreen.main.bounds.width, height: 50))
        labelResult.font = UIFont.init(name: "System", size: 30)
        labelResult.textAlignment = .center
        labelResult.backgroundColor = UIColor.gray
        view.addSubview(labelResult)
    }
    
    func initData() {
        if model.noWords() {
            alert("You have no words!")
            navigationController?.popViewController(animated: true)
        }
        generateQuiz()
    }
    
    func generateQuiz() {
        if model.finished() {
            showAlertReset()
            return
        }
        let object = model.generateQuestion()
        labelQuestion.text = object.question
        correctAnswer = object.answer!
        createAnswerView()
        createSelectionView()
    }
    
    func createAnswerView() {
        for view in viewAnswer.subviews {
            view.removeFromSuperview()
        }
        let split = correctAnswer.splitCharacter()
        let count = split.count
        let space: CGFloat = 16
        let spaces = space * 6
        let fullRowWidth = UIScreen.main.bounds.width - spaces
        let width: CGFloat = fullRowWidth / 5
        let height: CGFloat = 20
        var x: CGFloat = 0
        var y: CGFloat = 0
        var row = -1
        
        for index in 0...count-1 {
            if index % 5 == 0 {
                y = (space + height) * CGFloat(index / 5) + space
                row += 1
                let remainingItems = count - row * 5
                if remainingItems >= 5 {
                    x = space
                } else {
                    //Align items to center
                    let floatValue = CGFloat(remainingItems)
                    let screenWidth = UIScreen.main.bounds.width
                    let itemsWidth = space * (floatValue-1) + width * floatValue
                    x = (screenWidth - itemsWidth) / 2
                }
            } else {
                x += width + space
            }
            let textField = UITextField.init(frame: CGRect.init(x: x, y: y, width: width, height: height))
            textField.backgroundColor = UIColor.white
            textField.delegate = self
            textField.borderStyle = .none
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.tag = index
            inputViews.append(textField)
            
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.black.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
            
            border.borderWidth = width
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
            
            viewAnswer.addSubview(textField)
        }
        let heightSum = (space + height) * CGFloat(row) + space * 3
        viewAnswerHeight.constant = heightSum
    }
    
    func createSelectionView() {
        for view in viewSelection.subviews {
            view.removeFromSuperview()
        }
        let split = correctAnswer.splitCharacter()
        let count = split.count
        let numberOfSelections = count >= 10 ? 15 : 10
        var row = -1
        let height: CGFloat = 30
        var x: CGFloat = 0
        var y: CGFloat = 0
        let space: CGFloat = 8
        let spaces = space * 6
        let fullRowWidth = UIScreen.main.bounds.width - spaces
        let width: CGFloat = fullRowWidth / 5
        
        for index in 0...numberOfSelections-1 {
            if index % 5 == 0 {
                y = (space + height) * CGFloat(index / 5) + space
                row += 1
                x = space
            } else {
                x += width + space
            }
            let button = UIButton(frame: CGRect.init(x: x, y: y, width: width, height: height))
            button.selectionStyle()
            
            viewSelection.addSubview(button)
        }
        
        let heightSum = (space + height) * CGFloat(row) + space * 3
        viewSelectionHeight.constant = heightSum
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
        if model.finished() {
            showAlertReset()
        } else {
            generateQuiz()
        }
    }
    
    @IBAction func onClickShowAnswer(_ sender: Any) {
        labelCorrectAnswer.textColor = UIColor.purple
        labelCorrectAnswer.isHidden = false
        labelCorrectAnswer.text = "It's '\(correctAnswer)'"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.labelCorrectAnswer.isHidden = true
        })
    }
    @IBAction func onClickSubmit(_ sender: Any) {
        showResult(answer == correctAnswer)
    }
    
    func showAlertReset() {
        let alert = UIAlertController(title: "Alert", message: "You've reviewed all words! Take another tour?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            self.model.reset()
            self.generateQuiz()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showResult(_ correct: Bool) {
        if correct {
            labelResult.textColor = UIColor.blue
            labelResult.text = "CORRECT!!"
        } else {
            labelResult.textColor = UIColor.red
            labelResult.text = "Oh no...Please try again..."
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.labelResult.frame
            frame = CGRect.init(x: 0, y: frame.height, width: frame.width, height: frame.height)
            self.labelResult.frame = frame
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                var frame = self.labelResult.frame
                frame = CGRect.init(x: 0, y: -frame.height, width: frame.width, height: frame.height)
                self.labelResult.frame = frame
                if correct {
                    self.generateQuiz()
                }
            })
        })
    }
}

extension FillInTheBlankViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answer = ""
        for view in inputViews {
            answer += view.text ?? ""
        }
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }
}
