//
//  MonedaRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 16/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class _MonedaRow: Row<MonedaCell>, KeyboardReturnHandler {
    
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let v = value else { return nil }
            self.value = String(describing: v)
            return String(describing: v)
        }
        cellProvider = CellProvider<MonedaCell>(nibName: "MonedaRow", bundle: nil)
    }
}

/// A row where the user can enter a decimal number.
public final class MonedaRow: _MonedaRow, RowType { }
