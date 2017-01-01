//
//  Message.swift
//  starwarschat
//
//  Created by Jesse Alltop on 12/31/16.
//  Copyright © 2016 Jesse Alltop. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var toId: String?
    var fromId: String?
    var timestamp: NSNumber?
    var text: String?
 
    func chatPartnerId() -> String? {
        let chatPartnerId: String?
        
        if fromId == FIRAuth.auth()?.currentUser?.uid {
            return toId
        }else {
            return fromId
        }
    }
    
}
