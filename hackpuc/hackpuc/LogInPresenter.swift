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
    
    var myView: LogInView {
        
        get {
            return self.view as! LogInView
        }
    }
    
    override func viewDidLoad() {
        
        self.view = LogInView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        self.myView.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String) {
        
        let user = FPName()
        user.name = name
        
        let realm = try! Realm()
        try! realm.write({
            
            realm.add(user)
        })
    }
}

