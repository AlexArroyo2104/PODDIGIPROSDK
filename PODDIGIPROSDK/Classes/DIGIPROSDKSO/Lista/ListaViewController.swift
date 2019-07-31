//
//  ListaViewController.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/23/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class ListaViewController: FormViewController, TypedRowControllerType, UINavigationControllerDelegate{
    
    /// The row that pushed or presented this controller
    public var row: RowOf<String>!
    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?
    // MARK: UIViewController+
    var isSelectedItem = false
    var isSelectedItems = false
    
    
    
    @IBAction public func cerrarAction(_ sender: Any) {
        
        let listaSeleccion = form.first as! SelectableSection<ListCheckRow<String>>
        
        if listaSeleccion.selectedRows().count > 0{
            isSelectedItems = true
        }
        if listaSeleccion.selectedRow()?.tag != nil || listaSeleccion.selectedRow() != nil{
            isSelectedItem = true
        }
        
        if isSelectedItem || isSelectedItems{
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            onDismissCallback?(self)
        }else{
            let alert = UIAlertController(
                title: "Módulo lista",
                message: "Favor de realizar su selección.",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isSelectedItem = false
        isSelectedItems = false
    }
    
    public func initForm(_ form: Form){
        self.form = form
    }
}
