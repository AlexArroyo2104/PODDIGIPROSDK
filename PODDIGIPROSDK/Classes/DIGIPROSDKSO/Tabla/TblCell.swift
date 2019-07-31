//
//  TblCell.swift
//  DGFmwrk
//
//  Created by Jonathan Viloria M on 2/20/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation
import UIKit

public class TblCell: UICollectionViewCell {
    
    @IBOutlet weak var lblRow: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var trashBtn: UIButton!
    
    public var id = 0
    
}
