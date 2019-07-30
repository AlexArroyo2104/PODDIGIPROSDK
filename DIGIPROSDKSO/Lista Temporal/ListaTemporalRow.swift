//
//  ListaTemporalRow.swift
//  DIGIPROSDKSO
//
//  Created by Alejandro López Arroyo on 6/27/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import UIKit


open class _ListaTemporalRowOf<T: Equatable> : Row<ListaTemporalCell> {
    
    open var presentationMode: PresentationMode<UIViewController>?
    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<ListaTemporalCell>>) -> Void)?
    open var customController: ListaTemporalViewController?
    
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
        cellProvider = CellProvider<ListaTemporalCell>(nibName: "ListaTemporalRow", bundle: nil)
        customController = ListaTemporalViewController(nibName: "ListaTemporalViewController", bundle: nil)
    }
    
    
    
    open override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.makeController() {
                    presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
                    onPresentCallback?(cell.formViewController()!, controller as! SelectorViewController<SelectorRow<ListaTemporalCell>>)
                } else {
                    presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
    }
    
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        
        guard let rowVC = segue.destination as Any as? SelectorViewController<SelectorRow<Cell>> else { return }
        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
        
        (segue.destination as? RowControllerType)?.onDismissCallback = presentationMode?.onDismissCallback
    }
    
   
    
}

 public final class ListaTemporalRow: _ListaTemporalRowOf<String>, RowType { }
