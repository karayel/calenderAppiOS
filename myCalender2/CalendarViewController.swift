//
//  ViewController.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController {
    
    var theme = MyTheme.light
    
    let calendarView: CalendarView = {
        let calendarView = CalendarView(theme: MyTheme.light)
        calendarView.translatesAutoresizingMaskIntoConstraints=false
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor = Style.backgroundColor
        
        view.addSubview(calendarView)
        calendarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        calendarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive=true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive=true
        calendarView.heightAnchor.constraint(equalToConstant: 385).isActive=true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.calendarView.daysCollectionView.selectItem(at: self.calendarView.todaysDateCollectionViewIndexPath, animated: true, scrollPosition: .bottom)
        self.calendarView.collectionView(self.calendarView.daysCollectionView, didSelectItemAt: self.calendarView.todaysDateCollectionViewIndexPath)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.daysCollectionView.collectionViewLayout.invalidateLayout()
    }

}

