//
//  SelectedDateView.swift
//  myCalender2
//
//  Created by Mert KARAYEL on 23.12.2018.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class SelectedDateView: UIView {
    
    let selectedDate: UILabel = {
        let selectedDate = UILabel()
        selectedDate.text = "Default Month Year text"
        selectedDate.textColor = Style.selectedDateLabelColor
        selectedDate.textAlignment = .center
        selectedDate.font = UIFont.boldSystemFont(ofSize: 16)
        selectedDate.translatesAutoresizingMaskIntoConstraints = false
        return selectedDate
    }()
    
    let selectedDateImageView: UIImageView = {
        let selectedDateImageView = UIImageView()
        selectedDateImageView.image = UIImage(named: "calendar")
        selectedDateImageView.frame = CGRect(x: 25, y: 18, width: 20, height: 20)
        selectedDateImageView.contentMode = .scaleAspectFit
        return selectedDateImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Style.selectedDateViewBackgroundColor
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(selectedDateImageView)

        self.addSubview(selectedDate)
        selectedDate.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectedDate.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        selectedDate.widthAnchor.constraint(equalToConstant: 150).isActive = true
        selectedDate.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        selectedDate.text = "6.12.2018"
    }
}
