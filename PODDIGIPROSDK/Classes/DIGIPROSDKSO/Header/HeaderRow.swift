//
//  HeaderRow.swift
//  ReglasService
//
//  Created by Alejandro López Arroyo on 5/22/19.
//  Copyright © 2019 Alejandro López Arroyo. All rights reserved.
//

import Foundation


public final class HeaderRow: Row<HeaderCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<HeaderCell>(nibName: "HeaderCell")
    }
}
