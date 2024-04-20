//
//  GlobalDateTimePicker.swift
//  Pet adoption
//
//  Created by MekalaDeepthi on 4/17/24.
//


import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: AnyObject {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var filteredUsers = [User]()
    weak var delegate: NewMessageControllerDelegate?
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = .white
        configureUI()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.backgroundColor = self.view.backgroundColor
        
    }
    
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func fetchUsers() {
       
        Service.fetchUsers { (users) in
            
            self.users = users
            self.tableView.reloadData()
            
        }
    }
    
   
    
    func configureUI() {
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    
}



extension NewMessageController {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  users.count
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user =  users[indexPath.row]
        return cell
    }
}

extension NewMessageController {
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user  = users[indexPath.row]
        
        let controller = ChatController(user: user)
         navigationController?.pushViewController(controller, animated: true)
        
    }
}

 
