//
//  ModifyToDoVC.swift
//  DetailPractice
//
//  Created by 김진웅 on 2022/09/06.
//

import UIKit
import RealmSwift

class ModifyToDoVC: UIViewController {

    @IBOutlet weak var applyButton: UIButton! // 저장 버튼
    @IBOutlet weak var deleteButton: UIButton! // 삭제 버튼
    @IBOutlet weak var titleTextField: UITextField! // 할 일 제목
    @IBOutlet weak var todoDatePicker: UIDatePicker! // 할 일 datePicker
    
    private var todoTitle: String! // 할 일 제목 임의 변수
    private var todoDate: Date! // 할 일 날짜 임의 변수
    private var alreadyDone: Bool!
    
    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDate()
        
        // UITextField를 다루기 위해
        titleTextField.delegate = self
    }
    
    // 기본 날짜 지정 (nil값 체크 안되게..)
    private func defaultDate() {
        todoDatePicker.date = Date()
        todoDate = todoDatePicker.date
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
        UTCtoKST(&todoDate)
        todoTitle = titleTextField.text
        let task = Todo(content: todoTitle, writeDate: todoDate, alreadyDone: alreadyDone)
        
        // 만든 task를 localRealm에 저장
        try! localRealm.write {
            localRealm.add(task)
        }
    
        // 모달 닫는 동작
        self.dismiss(animated: true, completion: nil)
    }
    private func UTCtoKST(_ todoDate: inout Date?) {
        let timeZone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timeZone.secondsFromGMT(for: todoDate!)
        todoDate = todoDate?.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
    
    // 삭제 버튼이 눌렸을 때
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        // 구현해야될 것
        // 삭제 버튼이 눌리면 Realm에서 해당 내용을 담은 객체(?) 삭제
        
        self.dismiss(animated: true, completion: nil) // 모달 닫는 동작
    }
    
}

// 키보드에서 done이 눌렸을 때, 키보드가 사라지게끔 한다.
extension ModifyToDoVC: UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        return true
    }
}
