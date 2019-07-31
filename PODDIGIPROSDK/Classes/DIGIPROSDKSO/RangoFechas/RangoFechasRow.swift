//
//  RangoFechasRow.swift
//  FE
//
//  Created by Jonathan Viloria M on 12/3/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation
import UIKit

public class _RangoFechasRow: Row<RangoFechasCell>, KeyboardReturnHandler{
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    open var presentationMode: PresentationMode<UIViewController>?
    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<RangoFechasCell>>) -> Void)?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
        cellProvider = CellProvider<RangoFechasCell>(nibName: "RangoFechasRow", bundle: nil)
        
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
    }

}

public final class RangoFechasRow: _RangoFechasRow, RowType { }
