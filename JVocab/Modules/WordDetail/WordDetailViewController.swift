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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPlaySound(_ sender: Any) {
    }
}
