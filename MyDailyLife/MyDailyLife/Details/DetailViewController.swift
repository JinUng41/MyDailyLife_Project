//
//  CalendarDetailView.swift
//  MyCalendar
//
//  Created by 유영재 on 2022/08/11.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var diaryButton: UIButton!

    var dateString: String!
    let scheduleList = UserData.schedule
    let todoList = UserData.todo
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = UserData
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
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDetailCell", for: indexPath) as? CalendarDetailCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as? CalendarHeaderView else {
                return nil
            }
            let allSections = Section.allCases
            let section = allSections[indexPath.section]
            header.configure(section.title)
            return header
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.schedule, .todo])
        snapshot.appendItems(scheduleList, toSection: .schedule)
        snapshot.appendItems(todoList, toSection: .todo)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)


        return UICollectionViewCompositionalLayout(section: section)
    }

    @IBAction func DiaryButtonTapped(_ sender: Any) {
        
    }
}


