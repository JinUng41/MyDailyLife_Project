//
//  CalendarDetailView.swift
//  MyCalendar
//
//  Created by 유영재 on 2022/08/11.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    @IBOutlet weak var todoCollectionView: UICollectionView!
    @IBOutlet weak var diaryButton: UIButton!
    
    var currentDate: Date!
    var dateString: String!
    
    let localRealm = try! Realm() // Realm 데이터를 저장할 localRealm 상수 선언

    var scheduleTask: Results<Schedule>!
    var todoTask: Results<Todo>!
    var diaryTask: Results<Diary>!
    
    var scheduleDataSource: UICollectionViewDiffableDataSource<Section, Schedule>!
    var todoDataSource: UICollectionViewDiffableDataSource<Section, Todo>!
    
    enum Section: CaseIterable {
        case schedule
        case todo
        
        var title: String {
            switch self {
            case .schedule: return "일정"
            case .todo: return "할 일"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryButton.layer.zPosition = 999
        
        dateLabel.text = dateString
        
        receiveRealmData()
        
        scheduleCollectionView.collectionViewLayout = layout()
        todoCollectionView.collectionViewLayout = layout()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func receiveRealmData() {
        
        // 배열의 Realm의 데이터 초기화
        let scheduleTask = localRealm.objects(Schedule.self)
        let todoTask = localRealm.objects(Todo.self)
        let diaryTask = localRealm.objects(Diary.self)
        
        // 데이터 가공하기 위한 List와 Array, snapshot에 데이터 저장하고 빼오기 위해서
        var scheduleList: List<Schedule> = List<Schedule>()
        var scheduleArray = Array(scheduleList)
        
        var todoList: List<Todo> = List<Todo>()
        var todoArray = Array(todoList)
    
        // Realm에서 업데이트된 데이터를 현재 셀의 array에 업데이트
        scheduleArray = Array(scheduleTask)
        todoArray = Array(todoTask)
        
        var index = 0
        var finalIndex = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd EEE요일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if(scheduleTask.count != 0)
        {
            while (index < scheduleTask.count) {
                let date = scheduleArray[index].startDate // index에 해당하는 일정의 시작날짜
                let dateStr = dateFormatter.string(from: date) // 그거의 string 형태
                
                if(dateStr == dateString!) {
                    scheduleArray[finalIndex] = scheduleArray[index]
                    finalIndex+=1
                    index+=1
                }
                else {
                    index+=1
                }
            }
        }
        let selectedDateScheduleCount = finalIndex
        
        scheduleArray.removeSubrange(selectedDateScheduleCount...scheduleArray.count-1)
        
        scheduleDataSource = UICollectionViewDiffableDataSource<Section,Schedule>(collectionView: scheduleCollectionView, cellProvider: { scheduleCollectionView, indexPath, item in
            guard let cell = scheduleCollectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCell", for: indexPath) as? ScheduleListCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        todoDataSource = UICollectionViewDiffableDataSource<Section,Todo>(collectionView: todoCollectionView, cellProvider: { todoCollectionView, indexPath, item in
            guard let cell = todoCollectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        scheduleDataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as? CalendarHeaderView else {
                return nil
            }
            header.configure("일정")
            return header
        }
        
        todoDataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as? CalendarHeaderView else {
                return nil
            }
            header.configure("할 일")
            return header
        }
        
        var scheduleSnapshot = NSDiffableDataSourceSnapshot<Section,Schedule>()
        scheduleSnapshot.appendSections([.schedule])
        scheduleSnapshot.appendItems(scheduleArray, toSection: .schedule)
        scheduleDataSource.apply(scheduleSnapshot)
        
        var todoSnapshot = NSDiffableDataSourceSnapshot<Section,Todo>()
        todoSnapshot.appendSections([.todo])
        todoSnapshot.appendItems(todoArray, toSection: .todo)
        todoDataSource.apply(todoSnapshot)
    }
    

    @IBAction func DiaryButtonTapped(_ sender: Any) {
        
    }
}



