
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var diaryButton: UIButton!
    
    // show 상태일 때, 배경 어둡게 처리
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
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
    @IBAction func scheduleButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
        present(vc, animated: true)
    }
    
    // todo 버튼이 눌렸을 때
    @IBAction func todoButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Todo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodoViewController") as! TodoViewController
        present(vc, animated: true)
    }
    
    // diary 버튼이 눌렸을 때
    @IBAction func diaryButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DiaryViewController") as! DiaryViewController
        present(vc, animated: true)
    }
    
    
}
