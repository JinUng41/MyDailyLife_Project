//
//  CalendarDetailCell.swift
//  MyCalendar
//
//  Created by 유영재 on 2022/08/16.
//

import UIKit

class CalendarDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    func configure(_ userData: UserData) {
        iconLabel.textColor = UIColor.systemRed // 얘는 일정이냐 할일이냐에 따라서 텍스트 컬러 바꿔주면 됨
        contentsLabel.text = userData.contents
    }
}
