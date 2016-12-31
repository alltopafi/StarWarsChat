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
        
        let image = UIImage(named: "rsz_compose_2x")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
       checkIfUserisLoggedIn()
       
    }
    
    func handleNewMessage() {
        let newmessageController = newMessageController()
        let navController = UINavigationController(rootViewController: newmessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserisLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
                
            }, withCancel: nil)
            
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

