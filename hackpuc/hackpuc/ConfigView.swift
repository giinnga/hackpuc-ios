//
//  ModelView.swift
//  Hackpuc-New
//
//  Created by Tauan Flores on 12/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import Foundation

class ConfigView: UIView , UITextFieldDelegate {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        //Declaracoes
        
        var lTit:UILabel?
        var lTitTx:String = "Configurações"
        var tFN:UITextField = UITextField()
        var tFC:UITextField = UITextField()
        var tFM:UITextField = UITextField()
        
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
        
        //TextField1
        //Name
        let fNW: CGFloat = FP.wP() * 281
        let fNH: CGFloat = FP.hP() * 58
        let fNX: CGFloat = (FP.mW() - fNW)/2
        let fNY: CGFloat = FP.mH() - fNH - 500
        
        //TextField2
        //Contatos
        let fCW: CGFloat = FP.wP() * 281
        let fCH: CGFloat = FP.hP() * 58
        let fCX: CGFloat = (FP.mW() - fCW)/2
        let fCY: CGFloat = FP.mH() - fCH - 400
        
        //TextField3
        //Msg alerta
        let fMW: CGFloat = FP.wP() * 281
        let fMH: CGFloat = FP.hP() * 58
        let fMX: CGFloat = (FP.mW() - fMW)/2
        let fMY: CGFloat = FP.mH() - fMH - 300
        
        //Label Config
        
        let lTW: CGFloat = FP.round(eleW - 2*eleBor)
        let lTH: CGFloat = FP.round(mH - mW - 6*eleBor)
        let lTX: CGFloat = 2*eleBor
        let lTY: CGFloat = 1
        
        //def Botao de Salvar
        let bSW: CGFloat = FP.wP() * 281
        let bSH: CGFloat = FP.hP() * 69
        let bSX: CGFloat = (FP.mW() - bSW)/2
        let bSY: CGFloat = FP.mH() - bSH - 60
        
        //Back Button
        let bbW: CGFloat = FP.wP() * 18
        let bbH: CGFloat = FP.hP() * 32
        let bbX: CGFloat = (FP.mW() - bbW - 350)/2
        let bbY: CGFloat = 40
        
        //Creation part ------------------------------------*
        
        //FieldMSg
        tFN = UITextField(frame: CGRectMake(fNX, fNY, fNW, fNH))
        tFN.placeholder = NSLocalizedString(" Nome Cadastrado...", comment: "Nome")
        tFN.font = UIFont.systemFontOfSize(29)
        tFN.borderStyle = UITextBorderStyle.RoundedRect
        tFN.keyboardType = UIKeyboardType.Default
        tFN.returnKeyType = UIReturnKeyType.Done
        tFN.clearButtonMode = UITextFieldViewMode.WhileEditing;
        tFN.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tFN.borderStyle = UITextBorderStyle.Line
        tFN.borderStyle = UITextBorderStyle.RoundedRect
        tFN.backgroundColor = FPColor.wColor()
        tFN.delegate = self
        
        //FieldMSg
        tFC = UITextField(frame: CGRectMake(fCX, fCY, fCW, fCH))
        tFC.placeholder = NSLocalizedString(" Contatos.", comment: "Nome")
        tFC.font = UIFont.systemFontOfSize(29)
        tFC.borderStyle = UITextBorderStyle.RoundedRect
        tFC.keyboardType = UIKeyboardType.Default
        tFC.returnKeyType = UIReturnKeyType.Done
        tFC.clearButtonMode = UITextFieldViewMode.WhileEditing;
        tFC.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tFC.borderStyle = UITextBorderStyle.Line
        tFC.borderStyle = UITextBorderStyle.RoundedRect
        tFC.backgroundColor = FPColor.wColor()
        tFC.delegate = self
        
        //FieldMSg
        tFM = UITextField(frame: CGRectMake(fMX, fMY, fMW, fMH))
        tFM.placeholder = NSLocalizedString(" Alerta Cadastrado.", comment: "Nome")
        tFM.font = UIFont.systemFontOfSize(29)
        tFM.borderStyle = UITextBorderStyle.RoundedRect
        tFM.keyboardType = UIKeyboardType.Default
        tFM.returnKeyType = UIReturnKeyType.Done
        tFM.clearButtonMode = UITextFieldViewMode.WhileEditing;
        tFM.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tFM.borderStyle = UITextBorderStyle.Line
        tFM.borderStyle = UITextBorderStyle.RoundedRect
        tFM.backgroundColor = FPColor.wColor()
        tFM.delegate = self
        
        //Label Titulo Config
        lTit = UILabel(frame: CGRectMake(lTX,lTY,lTW,lTH))
        lTit?.text = lTitTx
        lTit?.font = UIFont(name: "GeosansLight", size: FP.titFS())
        lTit?.textColor = FPColor.wColor()
        lTit?.textAlignment = NSTextAlignment.Center
        lTit?.highlighted = true
        lTit?.numberOfLines = 99
        
        //Continue Button
        let bSave = UIButton(frame: CGRectMake(bSX, bSY, bSW, bSH))
        bSave.backgroundColor = FPColor.bColor()
        bSave.setTitle("Salvar", forState: UIControlState.Normal)
        
        //Back Button
        let bbImage = UIImage(named: "back.png")! as UIImage
        let bb = UIButton(type: UIButtonType.System) as UIButton
        bb.frame = CGRectMake(bbX, bbY, bbW, bbH)
        bb.setBackgroundImage(bbImage, forState: UIControlState.Normal)
        bb.addTarget(self, action: "Action:", forControlEvents:UIControlEvents.TouchUpInside)
        
        //adding
        
        self.addSubview(bgView)
        self.addSubview(lTit!)
        self.addSubview(bSave)
        self.addSubview(tFN)
        self.addSubview(tFC)
        self.addSubview(tFM)
        self.addSubview(bb)
    }
}