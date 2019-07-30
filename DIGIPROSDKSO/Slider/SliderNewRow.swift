//
//  SliderNewRow.swift
//  DIGIPROSDKSO
//
//  Created by Alejandro López Arroyo on 6/19/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import Foundation

public class _SliderNewRow: Row<SliderNewCell>, KeyboardReturnHandler{
    /// Configuration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<SliderNewCell>(nibName: "SliderNewRow", bundle: nil)
    }
}

public final class SliderNewRow: _SliderNewRow, RowType { }

