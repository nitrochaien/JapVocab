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
    
    let model = FillInTheBlankViewModel()
    var correctAnswer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
    }
    
    func initView() {
        btnAnswer.borderAndCorner()
        btnNextQuestion.borderAndCorner()
    }
    
    func initData() {
        generateQuiz()
    }
    
    func generateQuiz() {
        let object = model.generateQuestion()
        labelQuestion.text = object.question
        correctAnswer = object.answer!
        createAnswerView()
    }
    
    func createAnswerView() {
        let split = correctAnswer.splitCharacter()
    }
    
    func answerInputView() -> UiTextfi
}
