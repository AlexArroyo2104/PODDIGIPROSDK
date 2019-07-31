//
//  SeccionRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/25/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

// MARK: SeccionRow
open class _SeccionRowOf<T: Equatable> : Row<SeccionCell> {
    open var presentationMode: PresentationMode<UIViewController>?
    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<SeccionCell>>) -> Void)?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
        cellProvider = CellProvider<SeccionCell>(nibName: "SeccionRow", bundle: nil)
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.makeController() {
                    presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
                    onPresentCallback?(cell.formViewController()!, controller as! SelectorViewController<SelectorRow<SeccionCell>>)
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

/// A row with a button and String value. The action of this button can be anything but normally will push a new view controller
//public typealias ImagenRow = ImagenRowOf<String>
public final class SeccionRow: _SeccionRowOf<String>, RowType { }
