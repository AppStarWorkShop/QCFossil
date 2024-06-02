//
//  CreateTaskTableViewCell.swift
//  QCFossil
//
//  Created by pacmobile on 17/11/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class CreateTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoText: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandText: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleText: UILabel!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyText: UILabel!
    @IBOutlet weak var poLineNoLabel: UILabel!
    @IBOutlet weak var poLineNoText: UILabel!
    @IBOutlet weak var shipToLabel: UILabel!
    @IBOutlet weak var shipToText: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var bookingQtyLabel: UILabel!
    @IBOutlet weak var bookingQtyInput: UILabel!
    @IBOutlet weak var opdRsdLabel: UILabel!
    @IBOutlet weak var opdRsdInput: UILabel!
    @IBOutlet weak var shipWinLabel: UILabel!
    @IBOutlet weak var shipWinInput: UILabel!
    
    weak var pVC:CreateTaskViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func didMoveToSuperview() {
        updateLocalizedString()
    }
    
    func updateLocalizedString(){
        
        self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.poLineNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Line No.")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.orderQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Order Qty")
        self.shipToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To")
        self.bookingQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Booked Qty")
        self.opdRsdLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
        self.shipWinLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func removePoItem(_ sender: UIButton) {
        
        let index = self.pVC!.poItems.index(where: { $0.poNo == self.poNoText.text && $0.poLineNo == self.poLineNoText.text })
        
        self.pVC!.poItems.remove(at: index!)
        self.pVC?.createTaskTableview.reloadData()
    }
    
}
