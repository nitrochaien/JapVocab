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
    @IBOutlet var viewSelection: UIView!
    @IBOutlet var viewSelectionHeight: NSLayoutConstraint!
    
    let model = FillInTheBlankViewModel()
    let navigationBarHeight:CGFloat = 64
    var labelResult: UILabel!
    var answerViews = [UIButton]()
    var selectionViews = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
    }
    
    func initView() {
        btnAnswer.borderAndCorner()
        btnNextQuestion.borderAndCorner()
        btnSubmit.borderAndCorner()
        
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
        createAnswerView()
        createSelectionView()
    }
    
    func createAnswerView() {
        for view in viewAnswer.subviews {
            view.removeFromSuperview()
        }
        answerViews.removeAll()
        
        let split = model.correctAnswerToStringArray()
        let count = split.count
        let space: CGFloat = 16
        let spaces = space * 6
        let fullRowWidth = UIScreen.main.bounds.width - spaces
        let width: CGFloat = fullRowWidth / 5
        let height: CGFloat = 30
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
            let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: width, height: height))
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: .normal)
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            button.tag = 0
            button.addTarget(self, action: #selector(tapAnswer), for: .touchUpInside)
            answerViews.append(button)
            
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.black.cgColor
            border.frame = CGRect(x: 0, y: button.frame.size.height - width, width: button.frame.size.width, height: button.frame.size.height)
            
            border.borderWidth = width
            button.layer.addSublayer(border)
            button.layer.masksToBounds = true
            
            viewAnswer.addSubview(button)
        }
        let heightSum = (space + height) * CGFloat(row) + space * 3
        viewAnswerHeight.constant = heightSum
    }
    
    func createSelectionView() {
        for view in viewSelection.subviews {
            view.removeFromSuperview()
        }
        selectionViews.removeAll()
        
        let split = model.correctAnswerToStringArray()
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
        let data = model.generateSelections(split, numberOfSelections: numberOfSelections - count)
        
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
            button.setTitle(data[index], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = index + 1
            button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            selectionViews.append(button)
            
            viewSelection.addSubview(button)
        }
        
        let heightSum = (space + height) * CGFloat(row) + height * 2
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
        showResult(true, showCorrectAns: true)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        updateAnswer()
        showResult(model.check())
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
    
    func showResult(_ correct: Bool, showCorrectAns: Bool = false) {
        if correct {
            labelResult.textColor = UIColor.blue
            labelResult.text = "CORRECT!!"
        } else {
            labelResult.textColor = UIColor.red
            labelResult.text = "Oh no...Please try again..."
        }
        if showCorrectAns {
            labelResult.textColor = UIColor.purple
            labelResult.text = "It's '\(model.getCorrectAnswer())'"
            labelResult.backgroundColor = UIColor.cyan
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
    
    func tapAnswer(_ button: UIButton) {
        deselectCharacter(button)
        button.setTitle("", for: .normal)
        button.tag = 0
    }
    
    func deselectCharacter(_ button: UIButton) {
        for selectionView in selectionViews {
            if selectionView.tag == button.tag {
                let title = button.title(for: .normal)
                selectionView.setTitle(title, for: .normal)
                return
            }
        }
    }
    
    func clickButton(_ button: UIButton) {
        let title = button.title(for: .normal) ?? ""
        if title.isEmpty {
            return
        }
        
        for answerView in answerViews {
            if answerView.tag == 0 {
                answerView.setTitle(title, for: .normal)
                answerView.tag = button.tag
                button.setTitle("", for: .normal)
                return
            }
        }
    }
    
    func updateAnswer() {
        model.answer = ""
        for answerView in answerViews {
            model.answer += answerView.title(for: .normal) ?? ""
        }
    }
}
