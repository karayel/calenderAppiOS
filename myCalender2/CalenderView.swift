//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
    static var white = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

struct Style {
    // DEFAULT STYLE LIGHT
    static var backgroundColor = Colors.white
    
    static var monthViewLabelColor = Colors.black
    
    static var nextMonthButtonColor = Colors.black
    static var previousMonthButtonColor = Colors.black
    
    static var activeCellLblColor = Colors.black
    static var activeCellLblColorHighlighted = Colors.white
    static var weekdaysLblColor = Colors.black
    
    static func themeDark(){
        backgroundColor = Colors.darkGray
        monthViewLabelColor = Colors.white
        nextMonthButtonColor = Colors.white
        previousMonthButtonColor = Colors.white
        activeCellLblColor = Colors.white
        activeCellLblColorHighlighted = Colors.black
        weekdaysLblColor = Colors.white
    }
    
    static func themeLight(){
        backgroundColor = Colors.white
        monthViewLabelColor = Colors.black
        nextMonthButtonColor = Colors.black
        previousMonthButtonColor = Colors.black
        activeCellLblColor = Colors.black
        activeCellLblColorHighlighted = Colors.white
        weekdaysLblColor = Colors.black
    }
}

struct MonthAndDay {
    // DEFAULT TURKISH
    static var daysArr = ["P", "S", "Ç", "P", "C", "C", "P"]
    static var monthsArr = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    
    static func englishMonthAndDay(){
        daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    }
}

class CalenderView: UIView {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    let monthView: MonthView = {
        let monthView = MonthView()
        monthView.translatesAutoresizingMaskIntoConstraints=false
        return monthView
    }()
    
    let weekdaysView: WeekdaysView = {
        let weekdaysView = WeekdaysView()
        weekdaysView.translatesAutoresizingMaskIntoConstraints=false
        return weekdaysView
    }()
    
    let daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let daysCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        daysCollectionView.showsHorizontalScrollIndicator = false
        daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        daysCollectionView.backgroundColor = UIColor.clear
        daysCollectionView.allowsMultipleSelection = false
        return daysCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupViews()
        
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "daysCollectionViewCell")
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(daysCollectionView)
        daysCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        daysCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        daysCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        daysCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func changeTheme() {
        daysCollectionView.reloadData()
        
        monthView.monthYearLabel.textColor = Style.monthViewLabelColor
        monthView.nextMonthButton.setTitleColor(Style.nextMonthButtonColor, for: .normal)
        monthView.previousMonthButton.setTitleColor(Style.previousMonthButtonColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.weekDayStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func getFirstWeekDay() -> Int {
        return ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
    }

}

extension CalenderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "daysCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.lbl.text = "\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.lbl.textColor = Style.activeCellLblColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

extension CalenderView: MonthViewDelegate{
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        daysCollectionView.reloadData()
        
        monthView.previousMonthButton.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
}

class DateCollectionViewCell: UICollectionViewCell {
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
 
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
