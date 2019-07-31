//
//  ListaRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/2/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

// MARK: ListaRow

open class _ListaRowOf<T: Equatable> : Row<ListaCell> {
    open var presentationMode: PresentationMode<UIViewController>?
    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<ListaCell>>) -> Void)?
    open var customController: ListaViewController?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
        cellProvider = CellProvider<ListaCell>(nibName: "ListaRow", bundle: nil)
        customController = ListaViewController(nibName: "ListaViewController", bundle: nil)
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.makeController() {
                    presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
                    onPresentCallback?(cell.formViewController()!, controller as! SelectorViewController<SelectorRow<ListaCell>>)
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

/// A generic row with a button. The action of this button can be anything but normally will push a new view controller
/// A row with a button and String value. The action of this button can be anything but normally will push a new view controller
public final class ListaRow: _ListaRowOf<String>, RowType { }
