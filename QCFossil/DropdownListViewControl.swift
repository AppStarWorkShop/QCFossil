//
//  DropdownListViewControl.swift
//  QCFossil
//
//  Created by Yin Huang on 20/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DropdownListViewControl: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var dropdownData = [String]()
    var dropdownDataFilter = [String]()
    weak var myParentTextField:UITextField!
    var sizeWidth = 0
    var sizeHeight = 0
    var selectedTableViewCell = [UITableViewCell]()
    var handleFun:((UITextField)->(Void))? = nil
    var allowManuallyInput = false
    var keyValues = [String:Int]()
    var selectedValues = [Int]()
    var listKeys = [String]()
    var listValues = [Int]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func longPressed(_ sender: UIGestureRecognizer) {
        if let cell = sender.view as? UITableViewCell {
            let popoverContent = PopoverViewController()
            popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//            popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
            popoverContent.dataType = _POPOVERNOTITLE
            popoverContent.selectedValue = cell.textLabel?.text ?? ""
            
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            nav.navigationBar.barTintColor = UIColor.white
            nav.navigationBar.tintColor = UIColor.black
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                navBarAppearance.backgroundColor = .black
                nav.navigationBar.standardAppearance = navBarAppearance
                nav.navigationBar.scrollEdgeAppearance = navBarAppearance
            }
            
            let popover = nav.popoverPresentationController
            popover?.delegate = nil
            popover?.sourceView = sender.view
            popover?.sourceRect = CGRect(x: 0,y: (sender.view?.parentVC?.view.frame.origin.y)!,width: sender.view!.frame.size.width,height: sender.view!.frame.size.height)
            
            sender.view?.parentVC!.present(nav, animated: true, completion: nil)
        }
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 5
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: sizeWidth, height: sizeHeight)
        self.addSubview(tableView)
        
        dropdownDataFilter = dropdownData
        
        let selectedValues = myParentTextField?.text!.replacingOccurrences(of: ", ", with: ",")
        
        let cells = selectedValues!.characters.split{$0 == ","}.map(String.init)
        for cell in cells {
            let cellObj = UITableViewCell.init()
            cellObj.textLabel?.text = cell as String
            self.selectedTableViewCell.append(cellObj)
        }
        
        self.tableView.reloadData()
        
        for key in self.keyValues.keys {
            listKeys.append(key)
        }
        
        for value in self.keyValues.values {
            listValues.append(value)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownDataFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = dropdownDataFilter[indexPath.row] as String
        
        self.selectedTableViewCell.forEach({
            if $0.textLabel?.text == cell.textLabel?.text {
                cell.textLabel?.textColor = UIColor.white
                cell.contentView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        })
        
        if indexPath.row % 2 == 0{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }
        
        if tableView.allowsMultipleSelection == true {
            updateBgColor(cell)
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DropdownListViewControl.longPressed(_:)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        return cell
    }
    
    func updateBgColor(_ cell:UITableViewCell) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cell.selectedBackgroundView = bgColorView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection == true {
            let selectedCell = tableView.cellForRow(at: indexPath)!
            var selected = false
            for cell in selectedTableViewCell {
               
                if selectedCell.textLabel!.text == cell.textLabel!.text {
                    selected = true
                }
            }
            
            if !selected {
                selectedTableViewCell.append(tableView.cellForRow(at: indexPath)!)
                selectedCell.contentView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
                selectedCell.textLabel?.textColor = UIColor.white
                
                if let aTextField = myParentTextField {
                    let text = String(dropdownDataFilter[indexPath.row])
                    
                    selectedValues.append(keyValues[text] ?? 0)
                    
                    if aTextField.text == "" {
                        aTextField.text! += text
                    }else{
                        aTextField.text! += ","+text
                    }
                    
                    if (handleFun != nil){
                        handleFun!(myParentTextField!)
                    }
                }
            }
            
        }else {
            if self.allowManuallyInput {
                
                if myParentTextField != nil {
                    guard let oldText = myParentTextField?.text else {
                        myParentTextField?.text = String(dropdownDataFilter[indexPath.row])

                        if (handleFun != nil){
                            handleFun!(myParentTextField!)
                        }
                        return
                    }
                    
                    myParentTextField!.text = oldText + String(dropdownDataFilter[indexPath.row])
                    handleFun?(myParentTextField!)
                }
                
                
            } else {
            
                if myParentTextField != nil {
                    myParentTextField?.text = String(dropdownDataFilter[indexPath.row])
                    handleFun?(myParentTextField!)
                }
            }
            
            Cache_Dropdown_Instance = nil
            self.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection == true {
        let cell = (tableView.cellForRow(at: indexPath)!)
        cell.textLabel?.textColor = UIColor.black
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            cell.contentView.backgroundColor = _TABLECELL_BG_COLOR2
        }
        
        let key = dropdownDataFilter[indexPath.row]
        let value = keyValues[key]
        self.selectedValues = self.selectedValues.filter({ $0 != value })
            
        for idx in 0...selectedTableViewCell.count-1 {
            if selectedTableViewCell[idx].textLabel?.text == cell.textLabel?.text {
                //Remove Text From Parent TextField
                
                if idx < 1 && selectedTableViewCell.count > 1 {
                    myParentTextField?.text = myParentTextField?.text!.replacingOccurrences(of: (cell.textLabel?.text)!+",", with: "", options: NSString.CompareOptions.literal, range: nil)
                }else if idx < 1 && selectedTableViewCell.count < 2 {
                    myParentTextField?.text = myParentTextField?.text!.replacingOccurrences(of: (cell.textLabel?.text)!, with: "", options: NSString.CompareOptions.literal, range: nil)
                }else{
                    myParentTextField?.text = myParentTextField?.text!.replacingOccurrences(of: ","+(cell.textLabel?.text)!, with: "", options: NSString.CompareOptions.literal, range: nil)
                }
                
                selectedTableViewCell.remove(at: idx)
                break
            }
        }
            
        if (handleFun != nil){
            handleFun!(myParentTextField!)
        }
        }
    }
    
    func dismissMyself() {
        self.removeFromSuperview()
    }
}
