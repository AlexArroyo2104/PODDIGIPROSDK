//
//  EtiquetaCell.swift
//  customForm
//
//  Created by Jonathan Viloria M on 16/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation
import WebKit


public class EtiquetaCell: Cell<String>, CellType, UIWebViewDelegate {
    
    @IBOutlet public weak var webView: UIWebView!
    @IBOutlet public weak var btnInfo: UIButton!
    
    public var formDelegate: FormularioDelegate?
    
    public var atributos: Atributos_leyenda!
    public var genericRow: EtiquetaRow! { return row as? EtiquetaRow }
    public var elemento = Elemento()
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_leyenda
        
        setVisible(atributos!.visible)
        setEncoded(atributos!.isencoded)
        
        if atributos?.ayuda != nil, atributos?.ayuda != ""{
            self.btnInfo.isHidden = false
        }else{
            self.btnInfo.isHidden = true
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblLeftWeb" {
                    constraint.constant = -20
                    self.layoutIfNeeded()
                }
            }
        }
        guard let ayuda = atributos?.ayuda, !ayuda.isEmpty else {
            self.btnInfo.isHidden = true
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblLeftWeb" {
                    constraint.constant = -20
                    self.layoutIfNeeded()
                }
            }
            return
        }
    }
    
    override open func update() {
        super.update()
    }
    
    // MARK: - INIT
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        
        let apiObject = ObjectFormManager<EtiquetaCell>()
        apiObject.delegate = self
        webView.delegate = self
        webView.layer.borderWidth = 0
        webView.layer.borderColor = UIColor.clear.cgColor
        height = {return 40}
        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        self.btnInfo.layer.borderWidth = 1.0
        self.btnInfo.layer.borderColor = UIColor.lightGray.cgColor
        self.btnInfo.layer.cornerRadius = self.btnInfo.frame.height / 2
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
        if isInfoToolTipVisible{
            toolTip!.dismiss()
            isInfoToolTipVisible = false
        }
    }
    
    // MARK: - ESTADISTICAS
    open func setEstadistica(){
        if est == nil{
            // MARK: - Estadística
            est = FEEstadistica()
            if atributos != nil{
                est!.Campo = "Leyenda"
            }
            est!.FechaEntrada = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Latitud = ConfigurationManager.shared.latitud
            est!.Longitud = ConfigurationManager.shared.longitud
            est!.Usuario = ConfigurationManager.shared.usuarioUIAppDelegate.User
            est!.Dispositivo = UIDevice().model
            est!.NombrePlantilla = ""
            est!.NombrePagina = atributos!.elementopadre
            est!.OrdenCampo = atributos!.ordencampo
            est!.Sesion = ConfigurationManager.shared.guid
            est!.PlantillaID = 0
            let idPag = atributos!.elementopadre.replacingOccurrences(of: "formElec_element", with: "")
            est!.PaginaID = Int(idPag) ?? 0
            let idElem = elemento._idelemento.replacingOccurrences(of: "formElec_element", with: "")
            est!.CampoID = Int(idElem) ?? 0
            
        }
    }
    
    // Aditional Func Objc
    @objc public func setAyuda(_ sender: Any) {
        var help = "No hay ayuda disponible"
        if self.atributos != nil{
            if isInfoToolTipVisible{
                toolTip!.dismiss()
                isInfoToolTipVisible = false
                return
            }else{
                if atributos?.ayuda != "" { help = (atributos?.ayuda)! }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if atributos!.visible{
            self.webViewResizeToContent(webView: webView)
        }
    }
    
    public func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        let height:CGFloat = webView.scrollView.contentSize.height
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: height)
        webView.addConstraint(heightConstraint)
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
        genericRow.cell.height = {return height + 50}
        self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
    }

    public func setEncoded(_ bool: Bool){
        if bool{
            webView.isHidden = false
            let decodedString = atributos!.valor.base64Decoded()
            if decodedString == nil{
                setVisible(false)
            }else{
               
                webView.loadHTMLString(decodedString?.decodeUrl() ?? "", baseURL: nil)
            }
            setEstadistica()
            // MARK: - Estadística
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = atributos!.valor
            est!.KeyStroke += 1
            elemento.estadisticas = est!
        }else{
            webView.isHidden = false
            webView.loadHTMLString(atributos!.valor, baseURL: nil)
            
        }
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
        self.webView.stringByEvaluatingJavaScript(from: "document.querySelector('meta[name=viewport]').setAttribute('content', 'user-scalable = 1;', false); ")
    }
    
}

// MARK: - OBJECTFORMDELEGATE
extension EtiquetaCell: ObjectFormDelegate{
    // Protocolos Genéricos
    public func setVariableHeight(Height h: CGFloat) {}
    public func setMessage(_ string: String, _ state: String){ }
    public func updateIfIsValid(animated: Bool = true){ }
    public func setMinMax(){ }
    public func setExpresionRegular(){ }
    public func setOcultarTitulo(_ bool: Bool){ }
    public func setOcultarSubtitulo(_ bool: Bool){ }
    public func setHabilitado(_ bool: Bool){ }
    public func setEdited(v: String){ }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
                if self.atributos != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 40}
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
    public func setRequerido(_ bool: Bool){ }
    public func triggerEvent(_ action: String) { }
}



extension String{
    
    func encodeUrl() -> String?{
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String?{
        return self.removingPercentEncoding
    }
    
}
