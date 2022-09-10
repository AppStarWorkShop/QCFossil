//
//  BackupTableViewCell.swift
//  QCFossil
//
//  Created by pacmobile on 17/1/2017.
//  Copyright © 2017 kira. All rights reserved.
//

import UIKit

class BackupTableViewCell: UITableViewCell {

    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var appVersionInput: UILabel!
    @IBOutlet weak var appReleaseLabel: UILabel!
    @IBOutlet weak var appReleaseInput: UILabel!
    @IBOutlet weak var backupProcessDateLabel: UILabel!
    @IBOutlet weak var backupProcessDateInput: UILabel!
    @IBOutlet weak var backupRemarksLabel: UILabel!
    @IBOutlet weak var backupRemarksInput: UITextView!
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var loginUserNameInput: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var taskCountInput: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.appVersionLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Version")
        self.appReleaseLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Release Date")
        self.backupProcessDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Date")
        self.backupRemarksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Remarks")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.taskCountLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Count")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
