//
//  PasswordRow.swift
//  Franklin
//
//  Created by Jonathan Viloria M on 20/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class _TextoRow: Row<TextoCell>, KeyboardReturnHandler{
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let v = value else { return nil }
            self.value = String(describing: v)
            return String(describing: v)
        }
        cellProvider = CellProvider<TextoCell>(nibName: "TextoRow", bundle: Bundle(path: "org.cocoapods.PODDIGIPROSDK"))
    }
}

public final class TextoRow: _TextoRow, RowType { }
