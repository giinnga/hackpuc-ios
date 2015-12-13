//
//  ViewController.swift
//  Hackpuc
//
//  Created by Joao Nassar Galante Guedes on 11/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import RealmSwift

class MyoConnectPresenter: UIViewController, CLLocationManagerDelegate, MyoViewProtocol, OTPublisherDelegate, OTSessionDelegate {
    
    var locationManager: CLLocationManager?
    
    var session: OTSession?
    var publisher: OTPublisher?
    
    var retry = false
    
    var myo: [TLMMyo] = []
    
    var sendingInfo = false
    var waitingResponse = false
    var presented = false
    var begin = false
    var waiting = false
    
    var mainSessionId = ""
    var mainSessionToken = ""
    
    var numero = 0
    
    var lat: Double = 0
    var lon: Double = 0
    
    var APIURL = "http://6f4ca100.ngrok.com"
    
    var userId = ""
    var userFiringId = ""
    var userName = "Pega nome do Usuário"
    var userMessage = "Pega mensagem do Usuário"
    
    var contacts: [String] = []
    var phoneNumbers: [String] = []
    var name: String = ""
    var message: String = ""
    var password: String = ""
    
    var realm = try! Realm()
    
    var myView: MyoConnectView {
        
        get {
            return self.view as! MyoConnectView
        }
    }
    
    /******************************/
     //MARK: ViewController MANAGER
     /******************************/
    
    override func viewDidLoad() {
        
        self.view = MyoConnectView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.myView.delegate = self
        
        let poseObserver = NSNotificationCenter.defaultCenter()
        poseObserver.addObserver(self, selector: Selector("didRecievePoseChange:"), name: TLMMyoDidReceivePoseChangedNotification, object: nil)
        
        let connectionObserver = NSNotificationCenter.defaultCenter()
        connectionObserver.addObserver(self, selector: Selector("connectionEvent:"), name: TLMHubDidConnectDeviceNotification, object: nil)
        
        self.retrieveContacts()
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("goToConfig"))
        self.myView.gear?.userInteractionEnabled = true
        self.myView.gear?.addGestureRecognizer(recognizer)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: Selector("testeFunc"))
        self.myView.pena?.userInteractionEnabled = true
        self.myView.pena?.addGestureRecognizer(recognizer2)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func testeFunc() {
        
        locationManager?.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        var contacList: [[String: AnyObject]] = []
        
        for var i = 0; i < contacts.count; i++ {
            
            contacList.append(["name": contacts[i], "number": phoneNumbers[i]])
            
        }
        
        let data = ["alert": ["name": self.name, "contacts": contacList, "message": self.message]]
        
        let authorized = CLLocationManager.authorizationStatus()
        
        if(authorized == CLAuthorizationStatus.Restricted || authorized == CLAuthorizationStatus.Denied) {
            
            //Denied to use the position test
            
        } else {
            
            locationManager = CLLocationManager()
            locationManager?.requestAlwaysAuthorization()
            CLLocationManager.locationServicesEnabled()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = kCLDistanceFilterNone
            locationManager?.pausesLocationUpdatesAutomatically = false
            locationManager?.allowsBackgroundLocationUpdates = true
        }
    }
    
    /******************************/
     //MARK: OPENTOK MANAGER
     /******************************/
     
     //STREAM
    
    func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        
        print("*******ERRO PUBLISH DID FAIL WITH ERROR")
        print(error)
    }
    
    //SESSION
    
    func sessionDidConnect(session: OTSession!) {
        
        publisher = OTPublisher(delegate: self, name: "AudioStream", audioTrack: true, videoTrack: false)
        session.publish(publisher!, error: nil)
    }
    
    func sessionDidDisconnect(session: OTSession!) {
        
        print("AudioStream Disconnected")
    }
    
    func session(session: OTSession!, didFailWithError error: OTError!) {
        
        retry = true
        print("*******ERRO SESSION DID FAIL WITH ERROR")
        print(error)
    }
    
    func session(session: OTSession!, streamCreated stream: OTStream!) {
        
        print("Stream Created")
    }
    
    func session(session: OTSession!, streamDestroyed stream: OTStream!) {
        
        print("Stream Destroyed")
    }
    
    /******************************/
     //MARK: LOCATION MANAGER
     /******************************/
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.lat = locations[locations.count - 1].coordinate.latitude
        self.lon = locations[locations.count - 1].coordinate.longitude
        
        var data = ["status": ["latitude": self.lat, "longitude": self.lon]] as [String: AnyObject]
        
        if(waitingResponse == true) {
            
            return
        }
        
        if(sendingInfo == false) {
            
            waitingResponse = true
            
            //Este array de contatos deve ser pego do realm. Deve-se colocar no array todos os contados que o usuário marcou como "quero enviar a mensagem"
            
            var contacList: [[String: AnyObject]] = []
            
            for var i = 0; i < contacts.count; i++ {
             
                contacList.append(["name": contacts[i], "number": phoneNumbers[i]])
                
            }
            
            data = ["alert": ["name": self.name, "contacts": contacList, "message": self.message], "status": ["latitude": self.lat, "longitude": self.lon]]
            
            Alamofire.request(.POST, APIURL + "/alerts", parameters: data, encoding: .JSON).responseJSON { response in
                
                let JSON = response.result.value as? [String: AnyObject]
                
                if JSON == nil {
                    
                    self.waitingResponse = false
                    return
                }
                
                let id = JSON!["id"] as? String
                
                if id == nil {
                    
                    self.waitingResponse = false
                    return
                }
                
                self.userId = id!
                
                Alamofire.request(.POST, self.APIURL + "/alerts/\(self.userId)/fire", parameters: data, encoding: .JSON).responseJSON { response in
                    
                    let JSON2 = response.result.value as? [String: AnyObject]
                    
                    if JSON2 == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    let fire = JSON2!["firing"] as? [String: AnyObject]
                    
                    if fire == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    let firingId = fire!["_id"] as? String
                    
                    if firingId == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    let openTok = JSON2!["openTok"] as? [String: AnyObject]
                    
                    if openTok == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    let sessionId = openTok!["sessionId"] as? String
                    
                    if sessionId == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    let token = openTok!["token"] as? String
                    
                    if token == nil {
                        
                        self.waitingResponse = false
                        return
                    }
                    
                    self.session = OTSession(apiKey: "45435402", sessionId: sessionId, delegate: self)
                    self.session?.connectWithToken(token, error: nil)
                    
                    self.userFiringId = firingId!
                    self.waitingResponse = false
                    self.sendingInfo = true
                    
                    self.mainSessionId = sessionId!
                    self.mainSessionToken = token!
                    
                    self.myView.upButton?.hidden = false
                    self.myView.upTextField?.hidden = false
                    self.myView.upView?.hidden = false
                }
            }
            
        } else {
            
            let newURL = self.APIURL + "/alerts/\(self.userId)/fire/\(self.userFiringId)/status"
            
            Alamofire.request(.POST, newURL, parameters: data, encoding: .JSON)
            
            print("numero \(numero)")
            numero++
            
            if (retry == true) {
                
                print("retry")
                self.session = OTSession(apiKey: "45435402", sessionId: self.mainSessionId, delegate: self)
                self.session?.connectWithToken(self.mainSessionToken, error: nil)
                retry = false
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    func startPanic() {
        
        locationManager?.startUpdatingLocation()
        self.emergency()
    }
    
    /******************************/
     //MARK: Myo MANAGER
     /******************************/
    
    func connectMyo() {
        
        if !presented{
            
            let navigationController = TLMSettingsViewController.settingsInNavigationController() as UINavigationController
            self.presentViewController(navigationController, animated: true, completion: nil)
            presented = true
        }
    }
    
    func connectionEvent(notification: NSNotification){
        
        myo = TLMHub.sharedHub().myoDevices() as! [TLMMyo]
        self.myView.cInfo?.textColor = FPColor.gColor()
        self.myView.cInfo?.text = "Conectado"
        self.myView.labelInfo?.text = "Deixe o aplicativo nesta tela. Você pode minimizar o app e utilizar seu celular normalmente."
        self.myView.myo?.image = UIImage(named: "MyoOn.png")
    }
    
    func didRecievePoseChange(notification: NSNotification){
        
        var dict:Dictionary<String,TLMPose> = notification.userInfo as! Dictionary<String,TLMPose>
        
        let pose = dict[kTLMKeyPose]
        switch pose!.type {
            
        case TLMPoseType.DoubleTap :
            
            print("double")
            break;
            
        case TLMPoseType.FingersSpread:
            print("fingers")
            break;
            
        case TLMPoseType.Fist:
            print("fist")
            if !begin { self.startPanic() ; begin = true }
            if begin && waiting { self.userAnswered() ; waiting = false }
            break;
            
            
        case TLMPoseType.WaveIn:
            print("wavvein")
            
            break;
            
        case TLMPoseType.WaveOut:
            print("waveout")
            
            break;
            
        case TLMPoseType.Unknown:
            
            print("Unknown")
            break;
            
        default:
            break;
        }
    }
    
    func emergency() {
        
        self.myo[0].vibrateWithLength(TLMVibrationLength.Short)
        
        delay(10, closure: {
            
            self.feedback()
        })
    }
    
    func feedback() {
        
        waiting = true
        
        self.myo[0].vibrateWithLength(TLMVibrationLength.Long)
        
        delay(10, closure: {
            
            if self.waiting {
                self.myo[0].vibrateWithLength(TLMVibrationLength.Long)
                self.userDidntAnswered()
                self.waiting = false
            }
        })
    }
    
    func userAnswered() {
        
        print("I'm fine")
        self.myo[0].vibrateWithLength(TLMVibrationLength.Short)
        delay(15, closure: {
            self.feedback()
        })
    }
    
    func userDidntAnswered() {
        
        print("send SMS")
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func goToConfig() {
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func didType(text: String) {
        
        if(self.password == text) {
            
            self.myView.upButton?.hidden = true
            self.myView.upTextField?.hidden = true
            self.myView.upView?.hidden = true
            
            let newURL = self.APIURL + "/alerts/\(self.userId)/fire/\(self.userFiringId)/ok"
            let data = ["status": ["latitude": self.lat, "longitude": self.lon, "isOk": true]] as [String: AnyObject]
            Alamofire.request(.POST, newURL, parameters: data, encoding: .JSON)
            
            locationManager?.stopUpdatingLocation()
            session?.disconnect()
        }
    }
    
    func retrieveContacts() {
        
        let realmContacts = realm.objects(FPContact)
        
        for RC in realmContacts {
            
            contacts.append(RC.name)
            phoneNumbers.append(RC.phone)
        }
        
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
}

