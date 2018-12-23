//
//  WeekdaysView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    let weekDayStackView: UIStackView = {
        let weekDayStackView = UIStackView()
        weekDayStackView.distribution = .fillEqually
        weekDayStackView.translatesAutoresizingMaskIntoConstraints = false
        return weekDayStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(weekDayStackView)
        weekDayStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        weekDayStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekDayStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekDayStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        var daysArr = MonthAndDay.daysArr
        for i in 0..<7 {
            let lbl = UILabel()
            lbl.text = daysArr[i]
            lbl.textAlignment = .center
            lbl.textColor = Style.weekdaysLblColor
            weekDayStackView.addArrangedSubview(lbl)
        }
    } 
}
