//
//  WordDetailViewModel.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/8/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import Speech

class WordDetailViewModel {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speak(_ input: String) {
        let utterance = AVSpeechUtterance.init(string: input)
        utterance.voice = getVoice(input)
        speechSynthesizer.speak(utterance)
    }
    
    func setSpeaker() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Error")
        }
    }
    
    func getVoice(_ input: String) -> AVSpeechSynthesisVoice? {
        return input.isJapanese ? AVSpeechSynthesisVoice.init(language: "ja-JP") : AVSpeechSynthesisVoice()
    }
}
