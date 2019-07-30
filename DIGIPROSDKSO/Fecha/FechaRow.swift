//
//  FechaRow.swift
//  customForm
//
//  Created by Jonathan Viloria M on 15/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

open class _FechaRow: _FechaFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = DateFormatter()
        dateFormatter?.timeStyle = .none
        dateFormatter?.dateStyle = .medium
        dateFormatter?.locale = Locale(identifier: "es")
        cellProvider = CellProvider<FechaCell>(nibName: "FechaRow", bundle: nil)
    }
}

open class _HoraRow: _FechaFieldRow {
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = DateFormatter()
        dateFormatter?.timeStyle = .short
        dateFormatter?.dateStyle = .none
        dateFormatter?.locale = Locale.current
        cellProvider = CellProvider<FechaCell>(nibName: "FechaRow", bundle: nil)

    }
}

/// A row with an Date as value where the user can select a date from a picker view.
public final class FechaRow: _FechaRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A row with an Date as value where the user can select a time from a picker view.
public final class HoraRow: _HoraRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

open class _FechaFieldRow: Row<FechaCell>, DatePickerRowProtocol, NoValueDisplayTextConformance {
    
    /// The minimum value for this row's UIDatePicker
    open var minimumDate: Date?
    
    /// The maximum value for this row's UIDatePicker
    open var maximumDate: Date?
    
    /// The interval between options for this row's UIDatePicker
    open var minuteInterval: Int?
    
    /// The formatter for the date picked by the user
    open var dateFormatter: DateFormatter?
    
    open var noValueDisplayText: String? = nil
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
