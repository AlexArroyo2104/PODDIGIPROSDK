//
//  HeaderTabRow.swift
//  ReglasService
//
//  Created by Jonathan Viloria M on 6/13/19.
//  Copyright © 2019 Alejandro López Arroyo. All rights reserved.
//

import Foundation


public final class HeaderTabRow: Row<HeaderTabCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<HeaderTabCell>(nibName: "HeaderTabCell")
    }
}
