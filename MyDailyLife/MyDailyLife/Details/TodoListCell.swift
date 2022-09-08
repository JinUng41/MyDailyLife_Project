//
//  TodoListCell.swift
//  MyDailyLife
//
//  Created by 유영재 on 2022/09/06.
//

import UIKit

class TodoListCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var checkBoxImageView: UIImageView!

    func configure(_ todo: Todo) {
        contentsLabel.text = todo.content
        iconLabel.tintColor = UIColor.systemYellow
    }
}
