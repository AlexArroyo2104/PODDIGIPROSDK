//
//  LogoRow.swift
//  customForm
//
//  Created by Jonathan Viloria M on 16/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class _LogoRow: Row<LogoCell>, KeyboardReturnHandler {
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<LogoCell>(nibName: "LogoRow", bundle: nil)
    }
}

public final class LogoRow: _LogoRow, RowType { }
