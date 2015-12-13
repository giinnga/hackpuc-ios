//
//  ViewController.swift
//  Hackpuc
//
//  Created by Joao Nassar Galante Guedes on 11/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import UIKit
import RealmSwift

class LogInPresenter: UIViewController, LogInProtocol {
    
    var message = ""
    var name = ""
    var password = ""
    
    var firstTime = false
    
    var myView: LogInView {
        
        get {
            return self.view as! LogInView
        }
    }
    
    override func viewDidLoad() {
        
        self.view = LogInView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        self.myView.delegate = self
        
        super.viewDidLoad()
        
        retrieveContacts()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        print(name)
        print(message)
        print(password)
        
        if(!name.isEmpty && !message.isEmpty && !password.isEmpty && firstTime == false) {
            
            firstTime = true
            let VC = MyoConnectPresenter()
            presentViewController(VC, animated: false, completion: nil)
        }
    }
    
    func saveName(name: String) {
        
        let user = FPName()
        user.name = name
        
        let realm = try! Realm()
        try! realm.write({
            
            print("Saved")
            
            realm.add(user, update: true)
            let VC = MsgPresenter()
            self.presentViewController(VC, animated: false, completion: nil)
        })
    }
    
    func retrieveContacts() {
        
        let realm = try! Realm()
        
        let realmMessage = realm.objects(FPMessage)
        
        for R in realmMessage {
            
            self.message = R.message
        }
        
        let realmPassword = realm.objects(FPPassword)
        
        for P in realmPassword {
            
            self.password = P.password
        }
        
        let realmName = realm.objects(FPName)
        
        for C in realmName {
            
            self.name = C.name
        }
    }
    
    func didPressBack() {
        
    }
}

