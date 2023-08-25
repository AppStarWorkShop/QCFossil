//
//  POSearchTableViewCell.swift
//  QCFossil
//
//  Created by pacmobile on 18/2/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class POSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoInput: UILabel!
    @IBOutlet weak var poLineNoLabel: UILabel!
    @IBOutlet weak var poLineNoInput: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleInput: UILabel!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyInput: UILabel!
    @IBOutlet weak var shipToLabel: UILabel!
    @IBOutlet weak var shipToInput: UILabel!
    @IBOutlet weak var taskScheduledLabel: UILabel!
    @IBOutlet weak var taskScheduledInput: UILabel!
    
    @IBOutlet weak var shipWinLabel: UILabel!
    @IBOutlet weak var shipWinInput: UILabel!
    
    @IBOutlet weak var osQCQtyLabel: UILabel!
    @IBOutlet weak var osQCQtyInput: UILabel!
   
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var orInput: UILabel!

    
    
    
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
        self.taskScheduledLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Scheduled?")
        self.shipWinLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
        self.osQCQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OS QC Qty")
        self.orLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
