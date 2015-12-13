//
//  ModelView.swift
//  Hackpuc-New
//
//  Created by Tauan Flores on 12/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import Foundation
import UIKit

class MsgView: UIView , UITextFieldDelegate {
    
    var delegate: LogInProtocol?
    var tFM: UITextField?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        //declaracao
        tFM = UITextField()
        var lTit:UILabel?
        var lTitTx:String = "Qual mensagem deseja enviar?"
        
        
        //Background
        let bgView = UIImageView(image: UIImage(named: "Background.png"))
        bgView.frame = CGRectMake(0, 0, FP.mW(), FP.mH())
        
        // Units
        let yOffset:        CGFloat = 50
        let mW:      CGFloat = FP.mW()
        let mH:     CGFloat = FP.mH() - yOffset
        let cRa:   CGFloat = FP.cRa()
        let eleW:  CGFloat = FP.round(382 * FP.wP())
        let eleBor: CGFloat = FP.round((mW - eleW)/2)
        
        //TextField
        //Name
        let fMW: CGFloat = FP.wP() * 281
        let fMH: CGFloat = FP.hP() * 40
        let fMX: CGFloat = (FP.mW() - fMW)/2
        let fMY: CGFloat = FP.mH() - fMH - 300
        
        //Label Parte 1
        
        let lP1W: CGFloat = FP.round(eleW - 2*eleBor)
        let lP1H: CGFloat = FP.round(mH - mW - 6*eleBor)
        let lP1X: CGFloat = 2*eleBor
        let lP1Y: CGFloat = 11*eleBor
        
        //def Botao de Continuar
        let bConW: CGFloat = FP.wP() * 281
        let bConH: CGFloat = FP.hP() * 69
        let bConX: CGFloat = (FP.mW() - bConW)/2
        let bConY: CGFloat = FP.mH() - bConH - 60
        
        //Back Button
        let bbW: CGFloat = FP.wP() * 18
        let bbH: CGFloat = FP.hP() * 32
        let bbX: CGFloat = 20
        let bbY: CGFloat = 40
        
        //Imagem da Pena
        let penaW: CGFloat = FP.wP() * 86
        let penaH: CGFloat = FP.hP() * 119
        let penaX: CGFloat = (FP.mW() - penaW)/2
        let penaY: CGFloat = 60
        
        //Create part -------------------------------*
        
        
        //FieldMSg
        tFM = UITextField(frame: CGRectMake(fMX, fMY, fMW, fMH))
        tFM?.placeholder = NSLocalizedString(" Escreva seu alerta", comment: "Nome")
        //tFName.center = CGPointMake(fNameW, fNameH)
        tFM?.font = UIFont.systemFontOfSize(20)
        tFM?.borderStyle = UITextBorderStyle.RoundedRect
        //tFName.autocorrectionType = UITextAutocorrectionType.No
        tFM?.keyboardType = UIKeyboardType.Default
        tFM?.returnKeyType = UIReturnKeyType.Done
        tFM?.clearButtonMode = UITextFieldViewMode.WhileEditing;
        tFM?.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tFM?.borderStyle = UITextBorderStyle.Line
        tFM?.borderStyle = UITextBorderStyle.RoundedRect
        tFM?.backgroundColor = FPColor.wColor()
        tFM?.delegate = self
        
        //Back Button
        let bbImage = UIImage(named: "back.png")! as UIImage
        let bb = UIButton(type: UIButtonType.System) as UIButton
        bb.frame = CGRectMake(bbX, bbY, bbW, bbH)
        bb.setBackgroundImage(bbImage, forState: UIControlState.Normal)
        bb.addTarget(self, action: Selector("pressBack"), forControlEvents:UIControlEvents.TouchUpInside)
        
        //Label Parte 1
        lTit = UILabel(frame: CGRectMake(lP1X,lP1Y,lP1W,lP1H))
        lTit?.text = lTitTx
        lTit?.font = UIFont(name: "GeosansLight", size: FP.titFS())
        lTit?.textColor = FPColor.wColor()
        lTit?.textAlignment = NSTextAlignment.Center
        lTit?.highlighted = true
        lTit?.numberOfLines = 99
        
        //Continue Button
        let bCon = UIButton(frame: CGRectMake(bConX, bConY, bConW, bConH))
        bCon.backgroundColor = FPColor.bColor()
        bCon.setTitle("Continuar", forState: UIControlState.Normal)
        bCon.addTarget(self, action: Selector("saveName"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //Pena
        let pena = UIImageView(image: UIImage(named: "Pena.png"))
        pena.frame = CGRectMake(penaX, penaY, penaW, penaH)
        
        //adding
        
        self.addSubview(bgView)
        self.addSubview(bb)
        self.addSubview(bCon)
        self.addSubview(lTit!)
        self.addSubview(tFM!)
        self.addSubview(pena)
    }
    
    func saveName() {
        
        delegate?.saveName(self.tFM!.text!)
    }
    
    func pressBack() {
        
        delegate?.didPressBack()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
