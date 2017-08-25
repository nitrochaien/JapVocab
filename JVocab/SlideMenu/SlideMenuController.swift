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

class SlideMenuController: UIViewController {

    var tableview: UITableView!
    var state: State!
    
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initGestures()
        initData()
        
        view.isHidden = true
        state = .close
    }
    
    func initData() {
        list = ["This", "is", "what", "you", "looking", "for"]
        tableview.reloadData()
    }
    
    func initTableView() {
        tableview = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width * 3/4, height: self.view.bounds.height))
        tableview.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
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
        
        let swipeRightGesture = UISwipeGestureRecognizer()
        swipeRightGesture.direction = .right
        swipeRightGesture.addTarget(parent ?? self, action: #selector(handleSwipeRightGesture))
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeLeftGesture)
//        view.addGestureRecognizer(swipeRightGesture)
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
    
    func handleSwipeRightGesture(swipe: UISwipeGestureRecognizer) {
        if !isOpening() {
            show()
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
            self.state = .close
            self.view.isHidden = true
        }
    }
    
    func show() {
        view.isHidden = false
        UIView.animate(withDuration: 0.3) {
            var frame = self.tableview.frame
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
            frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
            self.tableview.frame = frame
        }
        state = .open
    }
}

extension SlideMenuController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuseCellId")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row No.\(indexPath.row)")
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
