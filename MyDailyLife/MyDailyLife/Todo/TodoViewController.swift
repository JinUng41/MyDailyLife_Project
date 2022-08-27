//
//  TodoViewController.swift
//  FloatingActionButton
//
//  Created by 김진웅 on 2022/08/13.
//

import UIKit
import RealmSwift

class TodoViewController: UIViewController {

    @IBOutlet weak var applyButton: UIButton! // 저장 버튼
    @IBOutlet weak var titleTextField: UITextField! // 할 일 제목
    @IBOutlet weak var todoDatePicker: UIDatePicker! // 할 일 datePicker
    
    private var todoTitle: String!
    private var todoDate: Date!

    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITextField를 다루기 위해
        titleTextField.delegate = self
    }
    
    // 입력이 끝나고 화면 빈 곳을 터치했을 때 키보드가 사라지게끔..
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
    }
    
    // datepicker를 이용해 날짜를 지정하기
    @IBAction func changeTodoDate(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        todoDate = datePickerView.date
        
    }
    
    // 저장 버튼을 눌렀을 때
    @IBAction func applyButtonPressed(_ sender: Any) {
        checkDateIsNil(&todoDate)
        todoTitle = titleTextField.text
        let task = Todo(content: todoTitle, writeDate: todoDate)
        
        // 만든 task를 localRealm에 저장
        try! localRealm.write {
            localRealm.add(task)
        }
    
        
        // 모달 닫는 동작
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkDateIsNil(_ todoDate: inout Date?) {
        if(todoDate == nil) {
            todoDate = Date()
            
            let timeZone = TimeZone.autoupdatingCurrent
            let secondsFromGMT = timeZone.secondsFromGMT(for: todoDate!)
            todoDate = todoDate?.addingTimeInterval(TimeInterval(secondsFromGMT))
        }
    }
}

// 키보드에서 done이 눌렸을 때, 키보드가 사라지게끔 한다.
extension TodoViewController: UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        return true
    }
}
