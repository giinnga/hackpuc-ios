//
//  ViewController.swift
//  Hackpuc
//
//  Created by Joao Nassar Galante Guedes on 11/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import RealmSwift

class ContactsPresenter: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate, ContactsProtocol {
    
    var contacts: [String] = []
    var phoneNumbers: [String] = []
    
    var realm = try! Realm()
    
    var myView: ContactsView {
        
        get {
            return self.view as! ContactsView
        }
    }
    
    /******************************/
    //MARK: Application Methods
    /******************************/
    
    override func viewDidLoad() {
        
        self.view = ContactsView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        self.myView.cTable.delegate = self
        self.myView.cTable.dataSource = self
        
        self.myView.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. Teste commit
        
        retrieveContacts()
        self.myView.cTable.reloadData()
        self.myView.cTable.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /******************************/
    //MARK: Contacts Methods
    /******************************/
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact.givenName
        var phoneNumber = (contactProperty.value as! CNPhoneNumber).stringValue as String
        
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
        print(phoneNumber)
        
        let realmContact = FPContact()
        realmContact.name = contact
        realmContact.phone = phoneNumber
        realmContact.id = contacts.count
        self.saveContacts(realmContact)
        
        contacts.append(contact)
        phoneNumbers.append(phoneNumber)
        
        self.myView.cTable.reloadData()
        self.myView.cTable.layoutIfNeeded()
    }
    
    /******************************/
    //MARK: Protocol Methods
    /******************************/
    
    func addContact() {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    func didPressNext() {
        
        let VC = PasswordPresenter()
        presentViewController(VC, animated: false, completion: nil)
    }
    
    /******************************/
    //MARK: TableView Methods
    /******************************/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contacts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.myView.cTable.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = contacts[indexPath.row] + " / "  + phoneNumbers[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.deleteContacts(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    /******************************/
    //MARK: Realm Methods
    /******************************/
    
    func saveContacts(contacts: FPContact) {
        
        try! realm.write({
            
            self.realm.add(contacts)
        })
    }
    
    func retrieveContacts() {
        
        let realmContacts = realm.objects(FPContact)
        
        for RC in realmContacts {
            
            contacts.append(RC.name)
            phoneNumbers.append(RC.phone)
        }
    }
    
    func deleteContacts(index: Int) {
        
        try! realm.write ({
            
            let deletedNotifications = self.realm.objects(FPContact)
            self.realm.delete(deletedNotifications)
        })
        
        self.contacts.removeAtIndex(index)
        self.phoneNumbers.removeAtIndex(index)
        
        var i = 0
        let aux = FPContact()
        
        for _ in self.contacts {
            
            aux.id = i
            aux.name = self.contacts[i]
            aux.phone = self.phoneNumbers[i]
        
            try! realm.write({
            
                self.realm.add(aux, update: true)
            })
            
            i++
        }
    }
    
    func didPressBack() {
        
        dismissViewControllerAnimated(false, completion: nil)
    }
}

