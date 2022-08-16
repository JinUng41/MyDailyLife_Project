//
//  CalendarHeaderView.swift
//  MyCalendar
//
//  Created by 유영재 on 2022/08/16.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    var dateString: String!
    func configure(_ title: String) {
        titleLabel.text = title
        
    }
}
