//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {

    var monthsArr = MonthAndDay.monthsArr
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    let monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.text = "Default Month Year text"
        monthYearLabel.textColor = Style.monthViewLabelColor
        monthYearLabel.textAlignment = .center
        monthYearLabel.font = UIFont.boldSystemFont(ofSize: 16)
        monthYearLabel.translatesAutoresizingMaskIntoConstraints = false
        return monthYearLabel
    }()
    
    let nextMonthButton: UIButton = {
        let nextMonthButton = UIButton()
        nextMonthButton.setTitle(">", for: .normal)
        nextMonthButton.setTitleColor(Style.nextMonthButtonColor, for: .normal)
        nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        nextMonthButton.addTarget(self, action: #selector(nextAndPreviousMonthAction(sender:)), for: .touchUpInside)
        return nextMonthButton
    }()
    
    let previousMonthButton: UIButton = {
        let previousMonthButton = UIButton()
        previousMonthButton.setTitle("<", for: .normal)
        previousMonthButton.setTitleColor(Style.previousMonthButtonColor, for: .normal)
        previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
        previousMonthButton.addTarget(self, action: #selector(nextAndPreviousMonthAction(sender:)), for: .touchUpInside)
        previousMonthButton.setTitleColor(UIColor.lightGray, for: .disabled)
        return previousMonthButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
        previousMonthButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(monthYearLabel)
        monthYearLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthYearLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        monthYearLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        monthYearLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        monthYearLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(nextMonthButton)
        nextMonthButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nextMonthButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nextMonthButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextMonthButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(previousMonthButton)
        previousMonthButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        previousMonthButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        previousMonthButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        previousMonthButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    @objc func nextAndPreviousMonthAction(sender: UIButton) {
        if sender == nextMonthButton {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        monthYearLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
}

