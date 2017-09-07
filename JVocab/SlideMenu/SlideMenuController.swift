//
//  SlideMenuController.swift
//  SimpleUIKit
//
//  Created by Dinh Vu Nam on 7/25/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

enum State {
    case open, close
}

enum QuizType {
    case multipleChoices, fillBlanks
}

class SlideMenuController: UIViewController {

    var tableview: UITableView!
    var state: State!
    
    var quiz = [String]()
    var types = [String]()
    
    static let reloadListNotification = Notification.Name("reloadListNotification")
    static let showQuizNotification = Notification.Name("showQuizNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initGestures()
        initData()
        
        view.isHidden = true
        state = .close
    }
    
    func initData() {
        quiz = ["Multiple choices", "Fill in the blanks"]
        types = ["My words", "Hiragana", "Katakana"]
        tableview.reloadData()
    }
    
    func initTableView() {
        let width = self.view.bounds.width * 3/4
        tableview = UITableView.init(frame: CGRect.init(x: -width, y: 0, width: width, height: self.view.bounds.height))
        tableview.tableFooterView = UIView.init(frame: CGRect.zero)
        tableview.delegate = self
        tableview.dataSource = self
        
        view.addSubview(tableview)
    }
    
    func initGestures() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(handleTapGesture))
        
        let swipeLeftGesture = UISwipeGestureRecognizer()
        swipeLeftGesture.direction = .left
        swipeLeftGesture.addTarget(self, action: #selector(handleSwipeLeftGesture))
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeLeftGesture)
    }
    
    func handleTapGesture(tap: UITapGestureRecognizer) {
        if isOpening() {
            hide()
        } else {
            show()
        }
    }
    
    func handleSwipeLeftGesture(swipe: UISwipeGestureRecognizer) {
        if isOpening() {
            hide()
        }
    }
    
    func isOpening() -> Bool {
        return state == .open
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: { 
            var frame = self.tableview.frame
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0)
            frame = CGRect.init(x: -frame.width, y: 0, width: frame.width, height: frame.height)
            self.tableview.frame = frame
        }) { (isOpenned) in
            self.view.isHidden = true
            self.state = .close
        }
    }
    
    func show() {
        view.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.tableview.frame
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
            frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
            self.tableview.frame = frame
        }) { (isOpenned) in
            self.state = .open
        }
    }
}

extension SlideMenuController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuseCellId")
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = types[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = quiz[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return types.count
        }
        return quiz.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
        let row = indexPath.row
        let section = indexPath.section
        
        //List
        if section == 0 {
            //my words
            if row == 0 {
                
            }
            //hiragana
            else if row == 1 {
                
            }
            //katakana
            else if row == 2 {
                
            }
        } else {
            var userInfo = [String : QuizType]()
            if row == 0 {
                userInfo["type"] = .multipleChoices
            } else if row == 1 {
                userInfo["type"] = .fillBlanks
            }
            NotificationCenter.default.post(name: SlideMenuController.showQuizNotification, object: nil, userInfo: userInfo)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "List"
        }
        return "Quiz"
    }
}

extension SlideMenuController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: self.view)
            if (location.x  < self.view.bounds.width * 3/4) {
                return false
            }
        }
        
        return true
    }
}
