//
//  FELogaltySaml.swift
//  DIGIPROSDK
//
//  Created by Jonathan Viloria M on 5/10/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import Foundation

public class FELogaltySaml: EVObject {
    public var Uuid = ""
    public var Guid = ""
    public var Url = ""
    public var GuidFormato = ""
    public var filedownloaded = Array<FELogaltyDocuments>()
    public var downloaded = false
    public var status = ""
}
