//
//  ViewController.swift
//  JVocab
//
//  Created by Dinh Vu Nam on 8/24/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var slideMenu: SlideMenuController!
    @IBOutlet weak var tableView: UITableView!
    
    var model : MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = MainViewModel()
        initView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: MainViewModel.refreshDataNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: SlideMenuController.reloadListNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMultipleChoices), name: SlideMenuController.showQuizNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: SlideMenuController.reloadListNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: SlideMenuController.showQuizNotification,
                                                  object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: MainViewModel.refreshDataNotification,
                                                  object: nil)
    }
    
    func initView() {
        edgesForExtendedLayout = []
        addSlideMenu()
        initToolbar()
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        model.fetchWords()
    }
    
    func initToolbar() {
        let itemMenu = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_menu.png"), style: .plain, target: self, action: #selector(handleTapMenu))
        navigationItem.leftBarButtonItem = itemMenu
    }
    
    func addSlideMenu() {
        slideMenu = SlideMenuController()
        slideMenu.view.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        addChildViewController(slideMenu)
        view.addSubview(slideMenu.view)
        didMove(toParentViewController: slideMenu)
    }
    
    func handleTapMenu() {
        if slideMenu.isOpening() {
            slideMenu.hide()
        } else {
            slideMenu.show()
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        showAddScreen()
//        showAddAlert()
    }
    
    func showAddScreen() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddMoreViewController")
        if controller is AddMoreViewController {
            let addController = controller as! AddMoreViewController
            addController.delegate = self
            navigationController?.pushViewController(addController, animated: true)
        }
    }
    
//    func showEditScreen(_ word: Word) {
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "AddMoreViewController")
//        if controller is AddMoreViewController {
//            let addController = controller as! AddMoreViewController
//            addController.delegate = self
//            addController.setEdit(name, definition: definition, type: type)
//            navigationController?.pushViewController(addController, animated: true)
//        }
//    }
    
    func showAddAlert() {
        let alert = UIAlertController(title: "New word", message: "Add a word", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "word"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "definition"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            _ = alert?.textFields![0]
            _ = alert?.textFields![1]
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func refreshUI() {
        tableView.reloadData()
    }
    
    func openMultipleChoices(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let index = userInfo["type"] as! QuizType
        
        switch index {
        case .multipleChoices:
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "MultipleChoicesViewController")
            navigationController?.pushViewController(controller, animated: true)
            break
        }
    }
    
    func reloadList() {
        model.reloadData()
    }
}

extension ViewController : IAddMore {
    func onReturnToMainViewController() {
        model.reloadData()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        let word = model.words[indexPath.row]
        cell.textLabel?.text = word.word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.words.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteItemAt(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let word = model.getMeaningFrom(indexPath)
//        showEditScreen(word)
    }
}
