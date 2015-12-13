//
//  ViewController.swift
//  Hackpuc
//
//  Created by Joao Nassar Galante Guedes on 11/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import UIKit
import RealmSwift

class MsgPresenter: UIViewController, LogInProtocol {
    
    var myView: MsgView {
        
        get {
            return self.view as! MsgView
        }
    }
    
    override func viewDidLoad() {
        
        self.view = MsgView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.myView.delegate = self
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(message: String) {
        
        let user = FPMessage()
        user.message = message
        
        let realm = try! Realm()
        try! realm.write({
            
            print("Saved")
            
            realm.add(user, update: true)
            
            let VC = ContactsPresenter()
            self.presentViewController(VC, animated: false, completion: nil)
        })
    }
    
    func didPressBack() {
        
        dismissViewControllerAnimated(false, completion: nil)
    }
}

