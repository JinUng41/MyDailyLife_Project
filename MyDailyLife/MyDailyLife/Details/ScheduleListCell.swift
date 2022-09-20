//
//  ScheduleListCell.swift
//  MyDailyLife
//
//  Created by 유영재 on 2022/09/06.
//

import UIKit

class ScheduleListCell: UICollectionViewCell {
    

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    func configure(_ schedule: Schedule) {
        contentsLabel.text = schedule.content
        iconImageView.tintColor = UIColor.systemRed
        
        if(schedule.allDay) {
            startTimeLabel.text = "All"
            endTimeLabel.text = "Day"
            endTimeLabel.textColor = UIColor.label
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            startTimeLabel.text = dateFormatter.string(from: schedule.startDate)
            endTimeLabel.text = dateFormatter.string(from: schedule.endDate)
        }
    }
    
}
