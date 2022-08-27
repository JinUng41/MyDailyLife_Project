//
//  ScheduleViewController.swift
//  FloatingActionButton
//
//  Created by 김진웅 on 2022/08/13.
//

import UIKit
import RealmSwift

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var memoTextField: UITextField!

    @IBOutlet weak var exitDatePicker: UIDatePicker!
    
    private var scheduleTitle: String!
    private var startDate: Date!
    private var exitDate: Date!
    
    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언

    override func viewDidLoad() {
        super.viewDidLoad()
        oneHourPlus()
        titleTextField.delegate = self
        memoTextField.delegate = self
        searchDirectory()
    }
    
    // Realm defaults가 들어있는 디렉토리를 찾는 코드, 디버거로 멈춰서 찾으면 됨
    private func searchDirectory() {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsDirectory)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    // 입력이 끝나고 화면 빈 곳을 터치했을 때 키보드가 사라지게끔..
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
        self.memoTextField.resignFirstResponder()
    }
    
    // 기본 종료 시간을 현재 시간에서 한시간 후로 설정하기 위해..
    private func oneHourPlus() {
        exitDatePicker.date = Date()+3600
    }
    
    // 시작 날짜 지정 + startDate를 Date변수로 바꿔서 코드 리팩토링
    @IBAction func changeStartDate(_ sender: UIDatePicker) {
        let datePickerView = sender
        startDate = datePickerView.date
    }
    
    // 종료 날짜 지정 + exitDate를 Date변수로 바꿔서 코드 리팩토링
    @IBAction func changeExitDate(_ sender: UIDatePicker) {
        let datePickerView = sender
        exitDate = datePickerView.date
    }
    
    // 사용자가 DatePicker를 건드리지 않고 일정을 저장할 경우, startDate와 exitDate에 nil 값이 들어가기 때문에 nil일 경우
    // startDate에는 현재 시간을, exitDate에는 현재로부터 한시간 뒤를 설정한다.
    private func checkDateIsNil(_ startDate: inout Date?, _ exitDate: inout Date?) {
        if(startDate == nil) {
            startDate = Date()
            
            let timeZone = TimeZone.autoupdatingCurrent
            let secondsFromGMT = timeZone.secondsFromGMT(for: startDate!)
            startDate = startDate?.addingTimeInterval(TimeInterval(secondsFromGMT))
        }
        
        if(exitDate == nil) {
            exitDate = Date()
            
            let timeZone = TimeZone.autoupdatingCurrent
            let secondsFromGMT = timeZone.secondsFromGMT(for: exitDate!)
            exitDate = exitDate?.addingTimeInterval(TimeInterval(secondsFromGMT))
            
            exitDate! += 3600
        }
    }
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        checkDateIsNil(&startDate, &exitDate)
        
        // 지금 사용자가 화면에서 입력한 것을 Schedule 객체로 만들어 task를 만든다
        let task = Schedule(content: titleTextField.text!, startDate: startDate, endDate: exitDate, memo: memoTextField.text!)
        
        // 만든 task를 localRealm에 저장
        try! localRealm.write {
            localRealm.add(task)
        }
    
        self.dismiss(animated: true, completion: nil) // 모달 닫는 동작
    }
}


extension ScheduleViewController:UITextFieldDelegate {
    // 자동적으로 키보드가 올라오게끔
    override func viewWillAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    // 키보드에서 done이 눌렸을 때 키보드가 사라지게 함
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        memoTextField.endEditing(true)
        return true
    }
}

