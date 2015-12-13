//
//  ViewController.swift
//  Hackpuc
//
//  Created by Joao Nassar Galante Guedes on 11/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import UIKit
import RealmSwift

class PasswordPresenter: UIViewController, LogInProtocol {
    
    var myView: PasswordView {
        
        get {
            return self.view as! PasswordView
        }
    }
    
    override func viewDidLoad() {
        
        self.view = PasswordView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        self.myView.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(password: String) {
        
        let user = FPPassword()
        user.password = password
        
        let realm = try! Realm()
        try! realm.write({
            
            realm.add(user, update: true)
            let VC = MyoConnectPresenter()
            self.presentViewController(VC, animated: true, completion: nil)
        })
    }
}

