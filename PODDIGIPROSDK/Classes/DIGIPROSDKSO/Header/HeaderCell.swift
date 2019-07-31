//
//  HeaderCell.swift
//  ReglasService
//
//  Created by Alejandro López Arroyo on 5/22/19.
//  Copyright © 2019 Alejandro López Arroyo. All rights reserved.
//

import Foundation


open class HeaderCell: Cell<String>, CellType{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var indent: UIImageView!
    @IBOutlet public weak var bgHabilitado: UIView!
    
    public var genericRow: HeaderRow! {return row as? HeaderRow}
    public var isSectionHeader: Bool = false
    public var elemento = Elemento()
    public var atributos: Atributos_seccion!
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setup() {
        super.setup()
        selectionStyle = .none
        // specify the desired height for our cell
        height = { return 40 }
    }
    
    override open func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
    }
    
    public func setOpen(){
        if !switcher.isOn{ return }
        switcher.isOn = false
        hideElements(hide: false, masterTag: row.tag!)
    }
    
    public func setObject(obj: Elemento, title: String, isSctHeader: Bool){
        elemento = obj
        atributos = obj.atributos as? Atributos_seccion
        self.backgroundColor = UIColor.init(hexFromString: atributos.colorheader, alpha: 0.8)
        titleLabel.textColor = UIColor.init(hexFromString: atributos.colorheadertexto, alpha: 1)
        infoLabel.textColor = UIColor.init(hexFromString: atributos.colorheadertexto, alpha: 1)
        isSectionHeader = isSctHeader
        titleLabel.text = title.uppercased()
        if isSctHeader{
            switcher.isHidden = !isSctHeader
            infoLabel.isHidden = !isSctHeader
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblTop" {
                    constraint.constant = 0
                    self.layoutIfNeeded()
                }
            }
        }else{
            switcher.isHidden = !isSctHeader
            infoLabel.isHidden = !isSctHeader
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblTop" {
                    constraint.constant = -8
                    self.layoutIfNeeded()
                }
            }
        }
        if (genericRow.tag?.contains("-inner"))! && isSctHeader{ indent.isHidden = false }else{ indent.isHidden = true }
    }
    
    func hideElements(hide: Bool, masterTag: String){
        
        var deletingHeader = false
        var deletingFooter = false
        var hasInnerSection = false
        
        var tagInit = ""
        var tagFinal = ""
        for singleRow in (genericRow.baseCell.formViewController()?.form.allRows)!{
            
            if deletingHeader && deletingFooter{ break }
            
            if masterTag == singleRow.tag{
                tagInit = masterTag
                tagFinal = "\(tagInit)-f"
                deletingHeader = true
                continue
            }
            
            if singleRow.tag! == tagFinal{
                deletingFooter = true
                continue
            }
            
            if deletingHeader {
                // Detect if there is an inner section
                // If there is an inner section always hide
                let header = singleRow as? HeaderRow
                if header != nil{
                    if (singleRow.tag?.contains("-inner-f"))!{
                        hasInnerSection = false
                        continue
                    }
                    if (singleRow.tag?.contains("-inner"))!{
                        hasInnerSection = true
                        header?.cell.switcher.isOn = true
                        continue
                    }
                }else{
                    if hasInnerSection{
                        singleRow.hidden = Condition(booleanLiteral: true)
                        singleRow.evaluateHidden()
                    }else{
                        singleRow.hidden = Condition(booleanLiteral: hide)
                        singleRow.evaluateHidden()
                    }
                    
                }
            }
            
        }
        genericRow.baseCell.formViewController()?.tableView.reloadData()
        
    }
    
    @IBAction func actionSwitch(_ sender: UISwitch) {
        if sender.isOn{
            hideElements(hide: true, masterTag: row.tag!)
        }else{
            hideElements(hide: false, masterTag: row.tag!)
        }
    }
    
}

extension HeaderCell: ObjectFormDelegate{
    public func setVariableHeight(Height h: CGFloat) { }
    
    public func setMessage(_ string: String, _ state: String) { }
    
    public func updateIfIsValid(animated: Bool) { }
    
    public func setMinMax() { }
    
    public func setExpresionRegular() { }
    
    public func setOcultarTitulo(_ bool: Bool) { }
    
    public func setOcultarSubtitulo(_ bool: Bool) { }
    
    public func setHabilitado(_ bool: Bool) {
        
        self.elemento.validacion.habilitado = bool
        DispatchQueue.main.async {
            if bool{
                self.bgHabilitado.isHidden = true;
                self.row.baseCell.isUserInteractionEnabled = true
                self.row.disabled = false
                self.row.evaluateDisabled()
            }else{
                self.bgHabilitado.isHidden = false;
                self.row.baseCell.isUserInteractionEnabled = false
                self.row.disabled = true
                self.row.evaluateDisabled()
            }
            self.layoutIfNeeded()
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
        
    }
    
    public func setEdited(v: String) { }
    
    public func setVisible(_ bool: Bool) {
        
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
            if self.atributos != nil{
                if bool{
                    self.row.hidden = false
                    self.height = {return 72}
                    self.atributos?.visible = true
                }else{
                    self.row.hidden = true
                    self.height = {return 0}
                    self.atributos?.visible = false
                }
            }
            self.layoutIfNeeded()
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
        
    }
    
    public func setRequerido(_ bool: Bool) { }
    
    public func triggerEvent(_ action: String) { }

}
