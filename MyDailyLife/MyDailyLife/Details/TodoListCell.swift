//
//  TodoListCell.swift
//  MyDailyLife
//
//  Created by 유영재 on 2022/09/06.
//

import UIKit
import RealmSwift

class TodoListCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var alreadyDoneButton: UIButton!
    
    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언
    
    var todoAlreadyDone: Bool!
    var todoWhatCell: ObjectId!
    
    func configure(_ todo: Todo) {
        contentsLabel.text = todo.content
        iconLabel.tintColor = UIColor.systemYellow
        
        todoAlreadyDone = todo.alreadyDone
        todoWhatCell = todo._todoId
        
        if(todo.alreadyDone) {
            alreadyDoneButton.setImage(UIImage(systemName: "checkmark.square"),for: .normal)
            contentsLabel.textColor = UIColor.lightGray
        }
        else {
            alreadyDoneButton.setImage(UIImage(systemName: "square"),for: .normal)
        }
    }
    
    // 이미지 버튼이 클릭되었을 때 액션 처리
    @IBAction func alreadyButtonTapped(_ sender: Any) {
        // 체크박스를 누르면 값을 toggle로 바꿔줌
        todoAlreadyDone.toggle()
        
        let todoTask = localRealm.objects(Todo.self)
        for i in 0...todoTask.count-1 {
            if(todoWhatCell == todoTask[i]._todoId) {
                try! localRealm.write {
                    todoTask[i].alreadyDone = todoAlreadyDone
                }
            }
            
        }
        // bool 값에 따라서 그림 바꾸기
        if(todoAlreadyDone) {
            alreadyDoneButton.setImage(UIImage(systemName: "checkmark.square"),for: .normal)
            contentsLabel.textColor = UIColor.lightGray

        }
        else {
            alreadyDoneButton.setImage(UIImage(systemName: "square"),for: .normal)
            contentsLabel.textColor = UIColor.black

        }
    }
    
    
}

