//
//  CommonData.swift
//  QCFossil
//
//  Created by Yin Huang on 17/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import Foundation
import UIKit

//Debug mode, if for production please set to false
let _DEBUG_MODE = false

//Version
var _VERSION = "1.0"
var _RELEASE = ""
var _VERSIONCODE = ""
var _RELEASECODE = ""
var _NEEDDATAUPDATE = false
var _NEEDRESIZEIMAGE = true

//Device
let _DEVICE_WIDTH = UIScreen.main.bounds.width
let _DEVICE_HEIGHT = UIScreen.main.bounds.height

//Set background color, for displaying tableCell clearly
let _TABLECELL_BG_COLOR1 = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
let _TABLECELL_BG_COLOR2 = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let _TEXTVIEWBORDORCOLOR = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
let _DEFAULTBUTTONTEXTCOLOR = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)

let _FOSSILBLUECOLOR = UIColor.init(red: 29.0/255.0, green: 55.0/255.0, blue: 94.0/255.0, alpha: 1.0)
let _FOSSILYELLOWCOLOR = UIColor.init(red: 250.0/255.0, green: 184.0/255.0, blue: 10.0/255.0, alpha: 1.0)

//EmbedContainer Segue Identifier
let _SEGUEIDENTIFIER = "segueIdentifier"
let _SEGUEIDENTIFIERTASKSEARCH = "TaskSearchSegue"
let _SEGUEIDENTIFIERTASKDETAIL = "TaskDetailSegue"
let _SEGUEIDENTIFIERPOSEARCH = "PoSearchSegue"
let _SEGUEIDENTIFIERDATASYNC = "DataSyncSegue"
let _SEGUEIDENTIFIERDATACTRL = "DataControlSegue"
let _SEGUEIDENTIFIERUSERSETTING = "UserSettingSegue"

//Switch Tab View With Offset
let _DEFECTLISTOFFSET = "defectlistoffset"

//Popver Source View Types
let _NAVIBARHEIGHT:CGFloat = 44
let _POPOVERVIEWSIZE_S = CGSize(width: 320, height: 216)
let _PRODTYPE = "ProdType"
let _INPTTYPE = "InptType"
let _TMPLTYPE = "TmplType"
let _BOOKINGDATEFROMDATETYPE = "BookingDateFromDateType"
let _SHAPEPREVIEWTYPE = "ShapePreviewType"

//Database Access
let _DBNAME_PRD = "/fossil_qc_prd"
let _DBNAME_UAT = "/fossil_qc_uat"
let _DBNAME_USING = _DBNAME_PRD

//Button Layer
let _BTNTITLECOLOR = UIColor.white
let _CORNERRADIUS:CGFloat = 8.0

//TaskDetail SubView Tag
let _MASKVIEWTAG = 999999997
let _TASKDETAILVIEWTAG = 999999998
let _TASKINSPCATVIEWTAG = 999999999
let _TASKRESULTSETID = 6
let _SHAPEVIEWTAG = 999999996

//Sanbox Task Folder Path Name
var _INSPECTORWORKINGPATH = ""
let _TASKSPHYSICALPATHPREFIX = NSHomeDirectory()+"/Documents/"
var _TASKSPHYSICALPATH = NSHomeDirectory()+"/Documents/Tasks/"
let _CASEBACKPHOTOSPHYSICALPATH = NSHomeDirectory()+"/Documents/style_photo/caseback/"
let _WATCHSSPHOTOSPHYSICALPATH = NSHomeDirectory()+"/Documents/style_photo/watch_ss/"
let _JEWELRYSSPHOTOSPHYSICALPATH = NSHomeDirectory()+"/Documents/style_photo/jewelry_ss/"
let _TASKSPHYSICALFOLDERNAME = "Tasks"
let _THUMBSPHYSICALNAME = "Thumbs"

//Date Format
let _DATEFORMATTER = "MM/dd/yyyy"
let _DATEFORMATTER2 = "MM/dd/yy"

//iPad default frame
var _FULLSCRENNFRAME = CGRect(x: 0,y: 0,width: _DEVICE_WIDTH,height: _DEVICE_HEIGHT)
var _BRUSHSTYLE = ["red":255.0,"green":0.0,"blue":0.0,"brush":2.0]
let _GREY_BACKGROUD = UIColor.init(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)

//Popover Data Type
let _POPOVERDATATPYE = "DataPick"
let _POPOVERDATETPYE = "DatePick"
let _POPOVERPOITEMTYPE = "PoItemDisplay"
let _POPOVERPOITEMTYPESHIPWIN = "PoItemShipWinDisplay"
let _POPOVERTASKSTATUSDESC = "TaskStatusDesc"
let _SHAPEDATATYPE = "ShapeDataType"
let _POPOVERPRODDESC = "ProdDesc"
let _POPOVERPOPDRSD = "OpdRsd"
let _DEFECTPPDESC = "DefectPPDesc"
let _POPOVERNOTITLE = "NoTitle"
let _DOWNLOADTASKSTATUSDESC = "DownloadTaskStatusDesc"

//Sing Images Name
let _INSPECTORSIGNIMAGE = "inspectorSignImage.jpg"
let _VENDORSIGNIMAGE = "vendorSignImage.jpg"

//Input Modes
let _INPUTMODE01 = "INPUT01"
let _INPUTMODE02 = "INPUT02"
let _INPUTMODE03 = "INPUT03"
let _INPUTMODE04 = "INPUT04"

//Photo Edit Size //600x800, 800x1200, 1200x1600
var _RESIZEIMAGEWIDTH:CGFloat = 600
var _RESIZEIMAGEHEIGHT:CGFloat = 800
let _THUMBNAILWIDTH:CGFloat = 128
let _THUMBNAILHEIGHT:CGFloat = 128

//Number Textfield Max Length
let _MAXIMUNINT:Int = 10

//NSSESSIONURL DownloadTask background mode flag
var _IS_BACKGROUNDSESSION_MODE = true
let _DROPDOWNLISTHEIGHT:CGFloat = 750

let _TAG1 = 1000001
let _TAG2 = 1000002
let _TAG3 = 1000003
let _TAG4 = 1000004
let _TAG5 = 1000005
let _TAG6 = 1000006
let _TAG7 = 1000007
let _TAG8 = 1000008
let _TAG9 = 1000009
let _TAG20 = 1000010

enum Languages: String {
    case en = "en"
    case zh = "zh-Hans"
    case fr = "fr-CH"
}
