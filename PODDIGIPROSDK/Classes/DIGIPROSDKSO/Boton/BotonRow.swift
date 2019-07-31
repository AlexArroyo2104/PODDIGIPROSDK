//
//  BotonRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 24/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class _BotonRow: Row<BotonCell> {
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()        
    }
    
    public override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
    }
}

/// A row where the user can enter a decimal number.
public final class BotonRow: _BotonRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<BotonCell>(nibName: "BotonRow", bundle: nil)
    }
}
