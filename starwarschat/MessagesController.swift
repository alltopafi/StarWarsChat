//
//  ViewController.swift
//  starwarschat
//
//  Created by Jesse Alltop on 12/29/16.
//  Copyright © 2016 Jesse Alltop. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = loginViewController()
        present(loginController, animated: true, completion: nil)
    }
}

