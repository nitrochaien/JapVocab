//
//  WordDetailViewController.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/8/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {

    @IBOutlet var labelWord: UILabel!
    @IBOutlet var labelMeaning: UILabel!
    @IBOutlet var labelKanji: UILabel!
    @IBOutlet var btnSound: UIButton!
    
    var word: Word!
    let model = WordDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        model.setSpeaker()
    }
    
    func initView() {
        labelWord.text = word.word
        labelMeaning.text = DBUtils.current.getTranslate(word)
        labelKanji.text = DBUtils.current.getKanjies(word)
        
        btnSound.borderAndCorner(.black)
        btnSound.setImage(UIImage.init(named: "icon_speaker.png"), for: .normal)
    }
    
    @IBAction func onPlaySound(_ sender: Any) {
        model.speak(labelWord.text ?? "")
    }
}
