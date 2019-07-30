//
//  EtiquetaRow.swift
//  customForm
//
//  Created by Jonathan Viloria M on 16/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class _EtiquetaRow: Row<EtiquetaCell>, KeyboardReturnHandler {
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<EtiquetaCell>(nibName: "EtiquetaRow", bundle: nil)
    }
}

public final class EtiquetaRow: _EtiquetaRow, RowType { }
