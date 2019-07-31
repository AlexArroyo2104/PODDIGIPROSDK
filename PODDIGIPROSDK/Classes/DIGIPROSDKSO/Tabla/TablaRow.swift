//
//  TablaRow.swift
//  FE
//
//  Created by Jonathan Viloria M on 12/7/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

// MARK: SeccionRow
open class _TablaRowOf<T: Equatable> : Row<TablaCell> {
    open var presentationMode: PresentationMode<UIViewController>?
    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<TablaCell>>) -> Void)?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
        cellProvider = CellProvider<TablaCell>(nibName: "TablaRow", bundle: nil)
    }
    
    
    open override func customUpdateCell() {
        super.customUpdateCell()
    }
    
}

/// A row with a button and String value. The action of this button can be anything but normally will push a new view controller
public final class TablaRow: _TablaRowOf<String>, RowType { }
