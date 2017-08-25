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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: MainViewModel.refreshDataNotification, object: nil)
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
    
    func initData() {
        
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        model.fetchData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddMore" {
            let controller = segue.destination as! AddMoreViewController
            controller.delegate = self
        }
    }
    
    func refreshUI() {
        tableView.reloadData()
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
        
        let item = model.getItemAtIndex(indexPath.row)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.definition
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCount()
    }
}
