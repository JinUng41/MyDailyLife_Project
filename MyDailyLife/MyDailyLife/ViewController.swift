
import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var diaryButton: UIButton!
    
    @IBOutlet var currentView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!

    
    var events: Array<Date> = []

    // show 상태일 때, 배경 어둡게 처리
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.alpha = 0
        view.isHidden = true
        
        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        
        return view
    }()
    
    // 플로팅 상태에 대한 flag
    var isShowFloating: Bool = false
    
    // 버튼 배열
    lazy var buttons: [UIButton] = [self.scheduleButton, self.todoButton, self.diaryButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatingStackView.layer.zPosition = 99
        floatingButton.layer.zPosition = 99
        
        scheduleButton.layer.zPosition = 99
        diaryButton.layer.zPosition = 99
        todoButton.layer.zPosition = 99
        
        currentView.bringSubviewToFront(floatingStackView)
        setEvents()
        
        configureCalendar()
        
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func configureCalendar() {
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.headerHeight = 60
        calendarView.weekdayHeight = 30
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.appearance.headerTitleColor = .label
        calendarView.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Medium", size: 16)
        calendarView.appearance.titleFont = UIFont(name: "Roboto-Regular", size: 14)
        
        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .vertical
        
        calendarView.appearance.eventDefaultColor = .systemGreen
        calendarView.appearance.eventSelectionColor = .systemGreen
        
        calendarView.appearance.borderRadius = 1
        calendarView.appearance.todayColor = .blue
        calendarView.appearance.selectionColor = .lightGray
        calendarView.appearance.titleDefaultColor = .label
//        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.titleTodayColor = .white
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.weekdayTextColor = .label
//        calendarView.placeholderType = .none
//        calendarView.layer.cornerRadius = 15
        
    }
    
    private func setEvents() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let xmas = formatter.date(from: "2022-12-25")
        let sampledate = formatter.date(from: "2022-08-22")
        events = [xmas!, sampledate!]
    }
    
    // 일기, 할 일, 일기 중 버튼이 눌리면 열렸던 플로팅 버튼은 다시 닫혀야겠지? 그걸 구현할거야
    private func closeFloatingButton() {
        // 버튼이 눌렸으면 열렸던 플로팅 버튼은 다시 닫혀야겠지.....?
        buttons.reversed().forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.floatingDimView.alpha = 0
        }) { (_) in
            self.floatingDimView.isHidden = true
        }
        
        // 상태 flag 값 변경
        isShowFloating = !isShowFloating
        
        // 이미지 회전
        let rotation = isShowFloating ? CGAffineTransform(rotationAngle: .pi - (.pi / 4)) : CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            // 이미지 회전
            self.floatingButton.transform = rotation
        }
        // 여기까지 플로팅 버튼 다시 닫는 동작이야
    }
    
    // 플로팅 버튼이 눌렸을 때 동작하는 함수
    @IBAction func floatingButtonAction(_ sender: UIButton) {
        
        if isShowFloating {
            // hide 애니메이션
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else {
         
            self.floatingDimView.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.floatingDimView.alpha = 1
            }
            // show 애니메이션
            buttons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0

                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        }
        
        // 상태 flag 값 변경
        isShowFloating = !isShowFloating
        
        // 이미지 회전
        let rotation = isShowFloating ? CGAffineTransform(rotationAngle: .pi - (.pi / 4)) : CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            // 이미지 회전
            sender.transform = rotation
        }
    }
    
    // schedule 버튼이 눌렸을 때
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
        present(vc, animated: true)
        closeFloatingButton()
    }
    
    // todo 버튼이 눌렸을 때
    @IBAction func todoButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Todo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodoViewController") as! TodoViewController
        present(vc, animated: true)
        closeFloatingButton()
    }
    
    // diary 버튼이 눌렸을 때
    @IBAction func diaryButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DiaryViewController") as! DiaryViewController
        present(vc, animated: true)
        closeFloatingButton()
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd EEE요일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateString = dateFormatter.string(from: date)
        
        // 선택된 날짜 (Date객체)를 DetailViewController에 넘기기
        vc.currentDate = date
        vc.dateString = dateString
        present(vc, animated: true)
    }
}
