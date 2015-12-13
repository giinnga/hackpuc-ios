//
//  ModelView.swift
//  Hackpuc-New
//
//  Created by Tauan Flores on 12/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import Foundation
import UIKit

class MyoConnectView: UIView, UITextFieldDelegate {
    
    var delegate: MyoViewProtocol?
    var cInfo: UILabel?
    var labelInfo: UILabel?
    var myo: UIImageView?
    var gear: UIImageView?
    var pena: UIImageView?
    
    var upView: UIView?
    var upTextField: UITextField?
    var upButton: UIButton?
    
    var tapGesture = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        tapGesture.addTarget(self, action: Selector("tap:"))
        
        //Background
        let bgView = UIImageView(image: UIImage(named: "Background.png"))
        bgView.frame = CGRectMake(0, 0, FP.mW(), FP.mH())
        
        let labelInfoTx:String = "Toque na imagem para conectar o seu dispositivo."
        
        // Units
        let yOffset:        CGFloat = 50
        let mW:      CGFloat = FP.mW()
        let mH:     CGFloat = FP.mH() - yOffset
        //let cRa:   CGFloat = FP.cRa()
        let eleW:  CGFloat = FP.round(382 * FP.wP())
        let eleBor: CGFloat = FP.round((mW - eleW)/2)
        
        //Medidas
        
        //Label Parte 1
        let lP1W: CGFloat = FP.round(eleW - 2*eleBor)
        let lP1H: CGFloat = FP.round(mH - mW - 6*eleBor)
        let lP1X: CGFloat = 2*eleBor
        let lP1Y: CGFloat = 10*eleBor + 15
        
        //Botao de Continuar
        let cInfoW: CGFloat = FP.wP() * 281
        let cInfoH: CGFloat = FP.hP() * 69
        let cInfoX: CGFloat = (FP.mW() - cInfoW)/2
        let cInfoY: CGFloat = FP.mH() - cInfoH - 60
        
        //Imagem da Pena
        let penaW: CGFloat = FP.wP() * 86
        let penaH: CGFloat = FP.hP() * 119
        let penaX: CGFloat = (FP.mW() - penaW)/2
        let penaY: CGFloat = 60
        
        //Imagem do Myo
        let myoW: CGFloat = FP.mW() / 2.3
        let myoH: CGFloat = myoW
        let myoX: CGFloat = (FP.mW() - myoW)/2
        let myoY: CGFloat = lP1Y + lP1H + 20
        
        //Config
        let gearW: CGFloat = FP.mW() / 12
        let gearX: CGFloat = FP.mW() - gearW - 10
        let gearY: CGFloat = 30
        
        //Declarações
        
        //Label Parte 1
        labelInfo = UILabel(frame: CGRectMake(lP1X,lP1Y,lP1W,lP1H))
        labelInfo?.text = labelInfoTx
        labelInfo?.font = UIFont(name: "GeosansLight", size: FP.normalFS())
        labelInfo?.textColor = FPColor.wColor()
        labelInfo?.textAlignment = NSTextAlignment.Center
        labelInfo?.numberOfLines = 99
        
        //Engrenagem
        gear = UIImageView(frame: CGRectMake(gearX, gearY, gearW, gearW))
        gear?.image = UIImage(named: "gear.png")
        
        //Continue Button
        cInfo = UILabel(frame: CGRectMake(cInfoX, cInfoY, cInfoW, cInfoH))
        cInfo?.text = "Não Conectado"
        cInfo?.font = UIFont(name: "GeosansLight", size: FP.normalFS())
        cInfo?.textColor = FPColor.rColor()
        cInfo?.textAlignment = NSTextAlignment.Center
        cInfo?.numberOfLines = 99
        
        //Pena
        pena = UIImageView(image: UIImage(named: "Pena.png"))
        pena?.frame = CGRectMake(penaX, penaY, penaW, penaH)
        
        //Myo
        myo = UIImageView(image: UIImage(named: "MyoOff.png"))
        myo?.frame = CGRectMake(myoX, myoY, myoW, myoH)
        myo?.addGestureRecognizer(tapGesture)
        myo?.userInteractionEnabled = true
        
        
        
        //Overlay View
        
        //Text Field
        let fNameW: CGFloat = FP.wP() * 281
        let fNameH: CGFloat = FP.hP() * 40
        let fNameX: CGFloat = (FP.mW() - fNameW)/2
        let fNameY: CGFloat = FP.mH() - fNameH - 300
        
        //Botao de Continuar
        let bConW: CGFloat = FP.wP() * 281
        let bConH: CGFloat = FP.hP() * 69
        let bConX: CGFloat = (FP.mW() - bConW)/2
        let bConY: CGFloat = FP.mH() - bConH - 60
        
        upView = UIView(frame: CGRectMake(0,0,FP.mW(),FP.mH()))
        upView?.backgroundColor = UIColor.blackColor()
        upView?.alpha = 0.85
        upView?.hidden = true
        
        upTextField = UITextField(frame: CGRectMake(fNameX, fNameY, fNameW, fNameH))
        upTextField!.placeholder = NSLocalizedString("Senha para fim de alerta", comment: "Nome")
        upTextField!.font = UIFont.systemFontOfSize(20)
        upTextField!.borderStyle = UITextBorderStyle.RoundedRect
        upTextField!.keyboardType = UIKeyboardType.Default
        upTextField!.returnKeyType = UIReturnKeyType.Done
        upTextField!.clearButtonMode = UITextFieldViewMode.WhileEditing;
        upTextField!.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        upTextField!.borderStyle = UITextBorderStyle.Line
        upTextField!.borderStyle = UITextBorderStyle.RoundedRect
        upTextField!.backgroundColor = FPColor.wColor()
        upTextField!.delegate = self
        upTextField!.hidden = true
        
        upButton = UIButton(frame: CGRectMake(bConX, bConY, bConW, bConH))
        upButton?.backgroundColor = FPColor.bColor()
        upButton?.setTitle("Cancelar Alerta", forState: UIControlState.Normal)
        upButton?.addTarget(self, action: Selector("tryCancel"), forControlEvents: UIControlEvents.TouchUpInside)
        upButton?.hidden = true
        
        //Acrescentar views
        self.addSubview(bgView)
        self.addSubview(labelInfo!)
        self.addSubview(pena!)
        self.addSubview(cInfo!)
        self.addSubview(myo!)
        self.addSubview(gear!)
        
        self.addSubview(upView!)
        self.addSubview(upTextField!)
        self.addSubview(upButton!)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        
        self.delegate?.connectMyo()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func tryCancel() {
        
        delegate?.didType(upTextField!.text!)
    }
}
