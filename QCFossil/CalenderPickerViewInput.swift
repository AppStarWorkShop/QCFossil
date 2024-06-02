//
//  CalenderPickerViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 22/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class CalenderPickerViewInput: UIView {
    
    struct DateFrameFmt {
        var xPos:CGFloat
        var yPos:CGFloat
        var size:CGFloat
        var weeDate:Int
        var monthPrefix:Int
    }
    
    let weekdayLabels = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Sun"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Mon"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Tue"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Wed"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Thu"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Fri"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Sat")]
    let monthLabels = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Jan"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Feb"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Mar"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Apr"),MylocalizedString.sharedLocalizeManager.getLocalizedString("May"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Jun"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Jul"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Aug"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Sep"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Oct"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Nov"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Dec")]
    
    let hCount = 7
    let vCount = 6
    let marginX = 2
    let marginY = Int(118)
    let offset = 45
    let cornerRadius:CGFloat = 5//24
    var dayBtns = [UIButton]()
    var dateFrames = [DateFrameFmt]()
    
    var year:Int = 0
    var month:Int = 0
    var week:Int = 0
    var day:Int = 0
    
    var currYear:Int = 0
    var currMonth:Int = 0
    var currDay:Int = 0
    var todayDate:String = ""
    
    var prevYear:Int = 0
    var prevMonth:Int = 0
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override func awakeFromNib() {
        initWeekdayLabel()
        
        for vIdx in 0...vCount-1 {
            for hIdx in 0...hCount-1 {
                let dateFrame = DateFrameFmt(xPos: CGFloat(marginX+offset*hIdx), yPos: CGFloat(marginY+offset*vIdx), size: CGFloat(offset), weeDate: 7, monthPrefix: 0)
                dateFrames.append(dateFrame)
            }
        }
        
        let date = Date()
        //let date = getDate(1,month: 4,year: 2016)
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        year =  components.year!
        currYear = year
        month = components.month!
        currMonth = month
        week = date.getWeekDateByDate(date.firstDateOfMonth())
        day = components.day!
        currDay = day
        todayDate = String(year)+String(month)+String(day)
        
        initYearLabel(String(year))
        initMonthLabel(month)
        initDays(week, month: month, year: year)
        
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(CalenderPickerViewInput.respondToSwipeGesture(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeftGesture)
        
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(CalenderPickerViewInput.respondToSwipeGesture(_:)))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRightGesture)
        
        let swipeTopGesture = UISwipeGestureRecognizer(target: self, action: #selector(CalenderPickerViewInput.respondToSwipeGesture(_:)))
        swipeTopGesture.direction = UISwipeGestureRecognizer.Direction.up
        self.addGestureRecognizer(swipeTopGesture)
        
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(CalenderPickerViewInput.respondToSwipeGesture(_:)))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.addGestureRecognizer(swipeDownGesture)
        /*
        let swipe2LeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("respondTo2SwipeGesture:"))
        swipe2LeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        swipe2LeftGesture.numberOfTouchesRequired = 2
        self.addGestureRecognizer(swipe2LeftGesture)
        */
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.subviews.forEach({ if $0.tag < 100 {$0.removeFromSuperview()} })
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                month = month > 1 ? month-1:12
                if month == 12 {
                    year = year-1
                }
                
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                month = month < 12 ? month+1:1
                if month == 1 {
                    year = year+1
                }
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped Up")
                year = year + 1
                
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped Down")
                year = year-1
                
            default:
                break
            }
            
            updateDatePicker()
            setParentTextFieldValue()
        }
    }
    
    func updateDatePicker() {
        let date = getDate(day,month: month,year: year)
        week = date.getWeekDateByDate(date.firstDateOfMonth(date))
        
        initYearLabel(String(year))
        initMonthLabel(month)
        initDays(week, month: month, year: year)
    }
    
    func getDate(_ day:Int, month:Int, year:Int) ->Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        let date = gregorian.date(from: c)
        return date!
    }
    
    func initYearLabel(_ year:String) {
        let weekdayLabel = UILabel.init()
        weekdayLabel.frame = CGRect(x: CGFloat(marginX+32), y: CGFloat(marginX), width: CGFloat(3*offset), height: CGFloat(offset))
        weekdayLabel.text = year
        weekdayLabel.textColor = UIColor.red
        weekdayLabel.backgroundColor = UIColor.clear
        weekdayLabel.layer.cornerRadius = cornerRadius
        weekdayLabel.font = weekdayLabel.font.withSize(40)
        weekdayLabel.textAlignment = .left
        
        self.addSubview(weekdayLabel)
        
        
        let UpBtn   = UIButton(type: UIButton.ButtonType.system) as UIButton
        UpBtn.frame = CGRect(x: 0,y: 10,width: 30,height: 30)
        //UpBtn.backgroundColor = UIColor.redColor()
        //UpBtn.setTitle("-", forState: UIControlState.Normal)
        //UpBtn.setTitleColor(_FOSSILBLUECOLOR, forState: UIControlState.Normal)
        UpBtn.addTarget(self, action: #selector(CalenderPickerViewInput.buttonActionUp(_:)), for: UIControl.Event.touchUpInside)
        if let image = UIImage(named: "arrow_icon_up") {
            UpBtn.setImage(image, for: UIControl.State())
            UpBtn.tintColor = _FOSSILBLUECOLOR
        }
        
        self.addSubview(UpBtn)
        
        let dnBtn   = UIButton(type: UIButton.ButtonType.system) as UIButton
        dnBtn.frame = CGRect(x: 130,y: 10,width: 30,height: 30)
        //dnBtn.backgroundColor = UIColor.redColor()
        //dnBtn.setTitle("+", forState: UIControlState.Normal)
        //dnBtn.setTitleColor(_FOSSILBLUECOLOR, forState: UIControlState.Normal)
        dnBtn.addTarget(self, action: #selector(CalenderPickerViewInput.buttonActionDown(_:)), for: UIControl.Event.touchUpInside)
        if let image = UIImage(named: "arrow_icon_down") {
            dnBtn.setImage(image, for: UIControl.State())
            dnBtn.tintColor = _FOSSILBLUECOLOR
        }
        
        self.addSubview(dnBtn)
        
    }
    
    @objc func buttonActionUp(_ sender:UIButton!){
        self.subviews.forEach({ if $0.tag < 100 {$0.removeFromSuperview()} })        //-(IBAction)
        year = year + 1
        updateDatePicker()
        setParentTextFieldValue()
        
    }
    @objc func buttonActionDown(_ sender:UIButton!){
        self.subviews.forEach({ if $0.tag < 100 {$0.removeFromSuperview()} })
        year = year - 1
        updateDatePicker()
        setParentTextFieldValue()
        
    }
    
    func initMonthLabel(_ month:Int) {
        let weekdayLabel = UILabel.init()
        weekdayLabel.frame = CGRect(x: CGFloat(320-3*offset+marginX), y: CGFloat(marginX), width: CGFloat(3*offset), height: CGFloat(offset))
        weekdayLabel.text = monthLabels[month-1]
        weekdayLabel.textColor = _FOSSILBLUECOLOR
        weekdayLabel.backgroundColor = UIColor.clear
        weekdayLabel.layer.cornerRadius = cornerRadius
        weekdayLabel.font = weekdayLabel.font.withSize(40)
        weekdayLabel.textAlignment = .center
        
        
        self.addSubview(weekdayLabel)
        
        let LeBtn   = UIButton(type: UIButton.ButtonType.system) as UIButton
        LeBtn.frame = CGRect(x: 190,y: 10,width: 30,height: 30)
        //LeBtn.backgroundColor = UIColor.redColor()
        //LeBtn.setTitle("L", forState: UIControlState.Normal)
        LeBtn.addTarget(self, action: #selector(CalenderPickerViewInput.buttonActionLeft(_:)), for: UIControl.Event.touchUpInside)
        if let image = UIImage(named: "arrow_icon_left") {
            LeBtn.setImage(image, for: UIControl.State())
            LeBtn.tintColor = _FOSSILBLUECOLOR
        }
        
        self.addSubview(LeBtn)
        
        let RtBtn   = UIButton(type: UIButton.ButtonType.system) as UIButton
        RtBtn.frame = CGRect(x: 290,y: 10,width: 30,height: 30)
        //RtBtn.backgroundColor = UIColor.redColor()
        //RtBtn.setTitle("R", forState: UIControlState.Normal)
        RtBtn.addTarget(self, action: #selector(CalenderPickerViewInput.buttonActionRight(_:)), for: UIControl.Event.touchUpInside)
        if let image = UIImage(named: "arrow_icon_right") {
            RtBtn.setImage(image, for: UIControl.State())
            RtBtn.tintColor = _FOSSILBLUECOLOR
        }
        
        self.addSubview(RtBtn)
    }
    @objc func buttonActionRight(_ sender:UIButton!){
        self.subviews.forEach({ if $0.tag < 100 {$0.removeFromSuperview()} })        //-(IBAction)
        month = month < 12 ? month+1:1
        if month == 1 {
            year = year+1
        }
        updateDatePicker()
        setParentTextFieldValue()
        
    }
    @objc func buttonActionLeft(_ sender:UIButton!){
        self.subviews.forEach({ if $0.tag < 100 {$0.removeFromSuperview()} })
        month = month > 1 ? month-1:12
        if month == 12 {
            year = year-1
        }
        updateDatePicker()
        setParentTextFieldValue()
        
    }
    
    func initWeekdayLabel() {
        let marginY = Int(72)
        
        for idx in 0...6 {
            let weekdayLabel = UILabel.init()
            weekdayLabel.frame = CGRect(x: CGFloat(idx*offset+marginX), y: CGFloat(marginY), width: CGFloat(offset), height: CGFloat(offset))
            weekdayLabel.text = weekdayLabels[idx]
            weekdayLabel.textColor = idx<1 ? UIColor.red : UIColor.black
            weekdayLabel.backgroundColor = UIColor.clear
            weekdayLabel.layer.cornerRadius = cornerRadius
            weekdayLabel.font = UIFont(name: "", size: 25)
            weekdayLabel.tag = 100
            weekdayLabel.textAlignment = .center
            
            self.addSubview(weekdayLabel)
        }
    }
    
    func initDays(_ week:Int,month:Int, year:Int) {
        //Set Dates for Current Month
        var currDateFrameIndex = week - 1
        
        /*
        let pMonth = month > 1 ? month-1:12
        var daysInMonth = getDaysInMonth(pMonth,year: year)
        
        if currDateFrameIndex > 0 {
            for pIdx in 0...currDateFrameIndex-1 {
                let dayBtn   = UIButton(type: UIButtonType.System) as UIButton
                let dateFrame = dateFrames[pIdx]
                dayBtn.frame = CGRectMake(dateFrame.xPos,dateFrame.yPos,dateFrame.size,dateFrame.size)
                dayBtn.tag = daysInMonth - (currDateFrameIndex + 1) + pIdx
                
                dayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                dayBtn.backgroundColor = UIColor.clearColor() //_FOSSILBLUECOLOR
                
                dayBtn.setTitle(String(daysInMonth - (currDateFrameIndex + 1) + pIdx), forState: UIControlState.Normal)
                dayBtn.layer.cornerRadius = cornerRadius
                dayBtn.titleLabel!.font =  UIFont(name: "", size: 25)
                dayBtn.addTarget(self, action: "prevDateOnClick:", forControlEvents: UIControlEvents.TouchDown)
                self.addSubview(dayBtn)
                dayBtns.append(dayBtn)
            }
        }*/
        
        let daysInMonth = getDaysInMonth(month,year: year)
        for idx in 1...daysInMonth {
            if idx <= dateFrames.count {
                if currDateFrameIndex > dateFrames.count{
                    break
                }
                
                let dateFrame = dateFrames[currDateFrameIndex]
                
                let dayBtn   = UIButton(type: UIButton.ButtonType.system) as UIButton
                dayBtn.frame = CGRect(x: dateFrame.xPos,y: dateFrame.yPos,width: dateFrame.size,height: dateFrame.size)
                dayBtn.tag = idx
                
                if idx == currDay && year == currYear && month == currMonth {
                    dayBtn.setTitleColor(UIColor.white, for: UIControl.State())
                    dayBtn.backgroundColor = UIColor.gray//_FOSSILYELLOWCOLOR
                }else if idx == day{
                    dayBtn.setTitleColor(UIColor.white, for: UIControl.State())
                    dayBtn.backgroundColor = _FOSSILYELLOWCOLOR
                }else{
                    dayBtn.setTitleColor(_FOSSILBLUECOLOR, for: UIControl.State())
                    dayBtn.backgroundColor = UIColor.clear //_FOSSILBLUECOLOR
                }
                
                dayBtn.setTitle(String(idx), for: UIControl.State())
                dayBtn.layer.cornerRadius = cornerRadius
                dayBtn.titleLabel!.font =  UIFont(name: "", size: 25)
                dayBtn.addTarget(self, action: #selector(CalenderPickerViewInput.currentDateOnClick(_:)), for: UIControl.Event.touchDown)
                
                self.addSubview(dayBtn)
                dayBtns.append(dayBtn)
            }
            
            currDateFrameIndex += 1
        }
        
    }
    
    override func didMoveToSuperview() {
        setParentTextFieldValue()
    }
    
    func formatDate(_ value:Int) ->String {
        if value < 10 {
            return "0\(value)"
        }else{
            return "\(value)"
        }
    }
    
    func setParentTextFieldValue() {
        if self.parentVC != nil {
            
            let dateFormat = _DATEFORMATTER.lowercased()
            var currDate = dateFormat.replacingOccurrences(of: "dd", with: formatDate(day))
            currDate = currDate.replacingOccurrences(of: "mm", with: formatDate(month))
            currDate = currDate.replacingOccurrences(of: "yyyy", with: formatDate(year))
            
            let parentVC = self.parentVC as! PopoverViewController
            parentVC.selectedValue = (currDate)
        }
    }
    /*
    func prevDateOnClick(sender: UIButton) {
        day = Int((sender.titleLabel!.text)!)!
        setParentTextFieldValue()
        
        let dateOnClick = String(prevYear)+String(prevMonth)+String(day)
        
        for dayBtn in dayBtns {
            dayBtn.setTitleColor(_FOSSILBLUECOLOR, forState: UIControlState.Normal)
            dayBtn.backgroundColor = UIColor.clearColor()//_FOSSILBLUECOLOR
            
            if isToday(String(year)+String(month)+String(dayBtn.titleLabel!.text!)) && !isToday(dateOnClick) {
                dayBtn.backgroundColor = UIColor.grayColor()
                dayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
        }
        
        sender.backgroundColor = _FOSSILYELLOWCOLOR
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }*/
    
    @objc func currentDateOnClick(_ sender: UIButton) {
        day = Int((sender.titleLabel!.text)!)!
        setParentTextFieldValue()
        
        let dateOnClick = String(year)+String(month)+String(day)
        
        for dayBtn in dayBtns {
            dayBtn.setTitleColor(_FOSSILBLUECOLOR, for: UIControl.State())
            dayBtn.backgroundColor = UIColor.clear//_FOSSILBLUECOLOR
            
            if isToday(String(year)+String(month)+String(dayBtn.titleLabel!.text!)) && !isToday(dateOnClick) {
                dayBtn.backgroundColor = UIColor.gray
                dayBtn.setTitleColor(UIColor.white, for: UIControl.State())
            }
        }
        
        sender.backgroundColor = _FOSSILYELLOWCOLOR
        sender.setTitleColor(UIColor.white, for: UIControl.State())
    }
    
    func getDaysInMonth(_ month: Int, year: Int) -> Int {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
        
        let diff = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: endDate, options: NSCalendar.Options.matchFirst)
        
        return diff.day!
    }
    
    func isToday(_ date:String) ->Bool {
        if date == todayDate {
            return true
        }else{
            return false
        }
    }
}
