//
//  Cells.swift
//  DIGIPROSDKSO
//
//  Created by Alejandro López Arroyo on 5/30/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import UIKit

class FilaCell: CellSpread {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class EditCell: CellSpread {
    
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.backgroundColor = UIColor.white
        //button.setTitle("Edit", for: .normal)
        
        contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class DataCell: CellSpread {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TitleCell: CellSpread {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class RowCell: CellSpread {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class TrashCell: CellSpread {
    
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.backgroundColor = UIColor.white
        //button.setTitle("Edit", for: .normal)
        
        contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
