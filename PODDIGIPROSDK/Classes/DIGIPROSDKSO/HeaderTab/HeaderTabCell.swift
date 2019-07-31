//
//  HeaderTabCell.swift
//  ReglasService
//
//  Created by Jonathan Viloria M on 6/13/19.
//  Copyright © 2019 Alejandro López Arroyo. All rights reserved.
//

import Foundation

open class HeaderTabCell: Cell<String>, CellType{
    
    @IBOutlet weak public var segmentedControl: ScrollableSegmentedControl!
    
    public var genericRow: HeaderTabRow! {return row as? HeaderTabRow}
    public var sects: [(id:String, title:String)] = [(id:String, title:String)]()
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setup() {
        super.setup()
        selectionStyle = .none
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        segmentedControl.segmentContentColor = .white
        segmentedControl.selectedSegmentContentColor = .white
        segmentedControl.fixedSegmentWidth = false
        height = { return 40 }
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if sender.selectedSegmentIndex == -1{ return }
        segmentedControlAction(sender.selectedSegmentIndex)
    }
    
    override open func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
    }
    
    public func setObject(_ sections: [(id:String, title:String)]){
        sects = sections
        var counter = 0
        for pagina in sects{
            segmentedControl.insertSegment(withTitle: "\(pagina.title)", at: counter)
            counter += 1
        }
    }
    
    public func selectOption(_ index: Int){
        segmentedControl.selectedSegmentIndex = index
    }
    
    public func segmentedControlAction(_ ii: Int) {
        print("Selected: \(ii)")
        print("Displaying: \(sects[ii])")
        
        for (index, ss) in sects.enumerated(){
            var deletingHeader = false
            var undoDeletingHeader = false
            var deletingFooter = false
            
            var tagInit = ""
            var tagFinal = ""
            
            for singleRow in (genericRow.baseCell.formViewController()?.form.allRows)!{
                
                if deletingHeader && deletingFooter{ break }
                
                if ss.id == singleRow.tag{
                    tagInit = ss.id
                    tagFinal = "\(tagInit)-f"
                    deletingHeader = true
                    if index == ii{ undoDeletingHeader = true }
                }
                
                if singleRow.tag! == tagFinal{
                    deletingFooter = true
                }
                
                if deletingHeader && undoDeletingHeader{
                    singleRow.hidden = Condition(booleanLiteral: false)
                    singleRow.evaluateHidden()
                }else if deletingHeader {
                    singleRow.hidden = Condition(booleanLiteral: true)
                    singleRow.evaluateHidden()
                }
                
            }
            
        }
        genericRow.baseCell.formViewController()?.tableView.reloadData()
    }
    
}
