//
//  LogicoRow.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/3/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

// MARK: SwitchRow

open class _LogicoRow: Row<LogicoCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

/// Boolean row that has a UISwitch as accessoryType
public final class LogicoRow: _LogicoRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<LogicoCell>(nibName: "LogicoRow", bundle: nil)
    }
}
