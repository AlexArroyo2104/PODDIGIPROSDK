//
//  NumeroRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 18/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class _NumeroRow: Row<NumeroCell>, KeyboardReturnHandler{
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let v = value else { return nil }
            self.value = String(describing: v)
            return String(describing: v)
        }
        cellProvider = CellProvider<NumeroCell>(nibName: "NumeroRow", bundle: nil)
    }
}

public final class NumeroRow: _NumeroRow, RowType { }
