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
    }
}
