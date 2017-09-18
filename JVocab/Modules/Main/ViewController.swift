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
        NotificationCenter.default.addObserver(self, selector: #selector(openQuiz), name: SlideMenuController.showQuizNotification, object: nil)
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
    
    func refreshUI() {
        tableView.reloadData()
    }
    
    func openQuiz(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let index = userInfo["type"] as! QuizType
        let storyBoard = UIStoryboard.init(name: "Quiz", bundle: nil)
        
        switch index {
        case .multipleChoices:
            let controller = storyBoard.instantiateViewController(withIdentifier: "MultipleChoicesViewController")
            navigationController?.pushViewController(controller, animated: true)
            break
        case .fillBlanks:
            let controller = storyBoard.instantiateViewController(withIdentifier: "FillInTheBlankViewController")
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
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        let word = model.words[indexPath.row]
        cell.textLabel?.text = word.word
        cell.textLabel?.textColor = UIColor.red
        cell.detailTextLabel?.text = DBUtils.current.getTranslate(word)
        
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
        let word = model.words[indexPath.row]
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WordDetailViewController")
        if controller is WordDetailViewController {
            let detailController = controller as! WordDetailViewController
            detailController.word = word
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
