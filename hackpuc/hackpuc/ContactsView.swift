//
//  ModelView.swift
//  Hackpuc-New
//
//  Created by Tauan Flores on 12/12/15.
//  Copyright © 2015 Grupo13. All rights reserved.
//

import Foundation
import UIKit

class ContactsView: UIView {
    
    var cTable: UITableView = UITableView()
    var delegate: ContactsProtocol?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        //declarações
        var lTit: UILabel?
        var lTitTx:String = "Quem deseja contactar?"
        
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
        
        //Botao de Continuar
        let bConW: CGFloat = FP.wP() * 281
        let bConH: CGFloat = FP.hP() * 69
        let bConX: CGFloat = (FP.mW() - bConW)/2
        let bConY: CGFloat = FP.mH() - bConH - 60
        
        //Botao de add
        let bAW: CGFloat = FP.wP() * 281
        let bAH: CGFloat = FP.hP() * 69
        let bAX: CGFloat = (FP.mW() - bConW)/2
        let bAY: CGFloat = FP.mH() - bConH - 140
        
        //Label Titulo tamanhos
        let lTitW: CGFloat = FP.round(eleW - 2*eleBor)
        let lTitH: CGFloat = FP.round(mH - mW - 6*eleBor)
        let lTitX: CGFloat = 2*eleBor
        let lTitY: CGFloat = 6
        
        //Tamanhos tableview
        let cTW: CGFloat = FP.wP() * 281
        let cTH: CGFloat = FP.hP() * 362
        let cTX: CGFloat = (FP.mW() - cTW)/2
        let cTY: CGFloat = FP.mH() - cTH - 220
        
        //Back Button
        let bbW: CGFloat = FP.wP() * 18
        let bbH: CGFloat = FP.hP() * 32
        let bbX: CGFloat = 20
        let bbY: CGFloat = 40
        
        
        //Creation Part --------------------------*
        
        //Back Button
        let bbImage = UIImage(named: "back.png")! as UIImage
        let bb = UIButton(type: UIButtonType.System) as UIButton
        bb.frame = CGRectMake(bbX, bbY, bbW, bbH)
        bb.setBackgroundImage(bbImage, forState: UIControlState.Normal)
        bb.addTarget(self, action: Selector("pressBack"), forControlEvents:UIControlEvents.TouchUpInside)
        
        //Continue Button
        let bCon = UIButton(frame: CGRectMake(bConX, bConY, bConW, bConH))
        bCon.backgroundColor = FPColor.bColor()
        bCon.setTitle("Continuar", forState: UIControlState.Normal)
        bCon.addTarget(self, action: Selector("press"), forControlEvents: UIControlEvents.TouchUpInside)
        bCon.titleLabel!.font = UIFont(name: "GeosansLight", size: FP.normalFS())
        
        //titulo Label
        lTit = UILabel(frame: CGRectMake(lTitX,lTitY,lTitW,lTitH))
        lTit?.text = lTitTx
        lTit?.font = UIFont(name: "GeosansLight", size: FP.titFS())
        lTit?.textColor = FPColor.wColor()
        lTit?.textAlignment = NSTextAlignment.Center
        lTit?.highlighted = true
        lTit?.numberOfLines = 99
        
        //Creation tableView
        cTable.frame = CGRectMake(cTX, cTY, cTW, cTH)
        cTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Button add
        let buttonAdd = UIButton(frame: CGRect(x: bAX, y: bAY, width: bAW, height: bAH))
        buttonAdd.setTitle("Add", forState: UIControlState.Normal)
        buttonAdd.addTarget(self, action: Selector("newContact"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonAdd.backgroundColor = FPColor.lGColor()
        buttonAdd.titleLabel!.font = UIFont(name: "GeosansLight", size: FP.normalFS())
        
        
        //adding
        self.addSubview(bgView)
        self.addSubview(lTit!)
        self.addSubview(cTable)
        self.addSubview(bCon)
        self.addSubview(bb)
        self.addSubview(buttonAdd)
    }
    
    func newContact() {
        
        delegate?.addContact()
    }
    
    func press() {
        
        delegate?.didPressNext()
    }
    
    func pressBack() {
        
        delegate?.didPressBack()
    }
}
