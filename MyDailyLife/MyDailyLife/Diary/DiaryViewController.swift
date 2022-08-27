//
//  DiaryViewController.swift
//  FloatingActionButton
//
//  Created by 김진웅 on 2022/08/13.
//

import UIKit
import RealmSwift

class DiaryViewController: UIViewController {

    @IBOutlet var currentView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    @IBOutlet weak var diaryDatePicker: UIDatePicker!
    
    @IBOutlet weak var selectEmoButton: UIButton!
    @IBOutlet weak var emotionStackView: UIStackView!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var tiredButton: UIButton!
    @IBOutlet weak var annoyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    
    private var emotionNum: Int = 1
    
    // show 상태일 때, 배경 어둡게 처리
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true
        
        self.view.insertSubview(view, belowSubview: self.emotionStackView)
        return view
    }()
    // 플로팅 상태에 대한 flag
    var isShowFloating: Bool = false
    // 버튼 배열
    lazy var buttons: [UIButton] = [self.happyButton, self.normalButton, self.tiredButton, self.annoyButton, self.sadButton]
    
    private var diaryDate: Date!
    
    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTextViewStyle()
        diaryTextView.delegate = self
        emotionStackViewStyle()
        selectImageAndTitle(1)
        
        currentView.bringSubviewToFront(emotionStackView)
    }
    
    // diaryTextView 스타일 지정
    private func diaryTextViewStyle() {
        diaryTextView.layer.borderWidth = 0.5
        diaryTextView.layer.cornerRadius = 10
        diaryTextView.layer.borderColor = UIColor.lightGray.cgColor
        diaryTextView.text =  " 오늘의 일기"
        diaryTextView.textColor = UIColor.lightGray
    }
    
    // 빈 화면을 터치했을 때 키보드가 사라지게끔..
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.diaryTextView.resignFirstResponder()
    }
    
    // 일기 날짜 바꾸기
    @IBAction func changeDiaryDate(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        diaryDate = datePickerView.date
    }
    // 저장 버튼을 눌렀을 때, 모달이 사라지면서 정보를 저장
    @IBAction func applyButtonPressed(_ sender: Any) {
        checkDateIsNil(&diaryDate)
        
        let diaryContent = diaryTextView.text
        let task = Diary(content: diaryContent, writeDate: diaryDate, emotion: emotionNum)
        
        // 만든 task를 localRealm에 저장
        try! localRealm.write {
            localRealm.add(task)
        }
        
        self.dismiss(animated: true)
    }
    
    // emotionStackView의 스타일 지정
    private func emotionStackViewStyle() {
        emotionStackView.layer.cornerRadius = 25
//        emotionStackView.layer.borderWidth = 3.0
//        emotionStackView.layer.borderColor = UIColor.lightGray.cgColor
        emotionStackView.backgroundColor = .white
    }
    // 이모션 버튼이 눌렸을 때, 다시 스택 뷰가 닫히도록
    private func emotionButtonAnimation() {
        buttons.reversed().forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.floatingDimView.alpha = 0
        }) { (_) in
            self.floatingDimView.isHidden = true
        }
        isShowFloating = !isShowFloating
    }
    
    // 이모션 버튼이 선택되었을 때, selectEmoButton 이 바뀌도록
    private func selectImageAndTitle(
        _ emotionNUM: Int) {
        switch emotionNUM {
        case 1:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("좋아", for: .normal)
            selectEmoButton.tintColor = .systemYellow
        case 2:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("평온", for: .normal)
            selectEmoButton.tintColor = .systemGreen
        case 3:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("피곤", for: .normal)
            selectEmoButton.tintColor = .systemGray
        case 4:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("짜증", for: .normal)
            selectEmoButton.tintColor = .systemRed
        case 5:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("슬퍼", for: .normal)
            selectEmoButton.tintColor = .systemBlue
        default:
            selectEmoButton.setImage(UIImage(systemName: "smiley.fill"), for: .normal)
            selectEmoButton.setTitle("좋아", for: .normal)
            selectEmoButton.tintColor = .systemYellow
        }
    }
    
    // selectEmotionButton이 눌렸을 때 다시 스택뷰가 사라지도록...
    @IBAction func selectEmoButtonTapped(_ sender: UIButton) {
        if isShowFloating {
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else {
            self.floatingDimView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.floatingDimView.alpha = 1
            }
            
            buttons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0
                
                UIView.animate(withDuration: 0.3){
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        }
        isShowFloating = !isShowFloating

    }
    
    // 각 감정이 눌렸을 때
    @IBAction func happyTapped(_ sender: UIButton) {
        emotionButtonAnimation()
        selectImageAndTitle(1)
    }
    @IBAction func normalTapped(_ sender: UIButton) {
        emotionButtonAnimation()
        selectImageAndTitle(2)
    }
    @IBAction func tiredTapped(_ sender: UIButton) {
        emotionButtonAnimation()
        selectImageAndTitle(3)
    }
    @IBAction func annoyTapped(_ sender: UIButton) {
        emotionButtonAnimation()
        selectImageAndTitle(4)
    }
    @IBAction func sadTapped(_ sender: UIButton) {
        emotionButtonAnimation()
        selectImageAndTitle(5)
    }
    
    private func checkDateIsNil(_ diaryDate: inout Date?) {
        if(diaryDate == nil) {
            diaryDate = Date()
            
            let timeZone = TimeZone.autoupdatingCurrent
            let secondsFromGMT = timeZone.secondsFromGMT(for: diaryDate!)
            diaryDate = diaryDate?.addingTimeInterval(TimeInterval(secondsFromGMT))
        }
    }
}

// textview의 placeholder 지정, 글씨를 입력하면 원래 글씨 색으로 출력
extension DiaryViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if diaryTextView.text.isEmpty {
                diaryTextView.text = " 오늘의 일기"
                diaryTextView.textColor = UIColor.lightGray
            }

        }
    func textViewDidBeginEditing(_ textView: UITextView) {
            if diaryTextView.textColor == UIColor.lightGray {
                diaryTextView.text = nil
                diaryTextView.textColor = UIColor.label
            }
        }
}
