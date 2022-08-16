//
//  UserData.swift
//  MyCalendar
//
//  Created by 유영재 on 2022/08/16.
//

import Foundation

struct UserData: Hashable {
    let contents: String
}

extension UserData {
    static let schedule: [UserData] = [
        UserData(contents: "진웅이랑 데이트"),
        UserData(contents: "메뉴는 딸바스"),
        UserData(contents: "가끔은 아아가 땡겨"),
        UserData(contents: "근데 오늘은 자몽"),
        UserData(contents: "얼"),
        UserData(contents: "그"),
        UserData(contents: "레"),
        UserData(contents: "이"),
        UserData(contents: "야"),
        UserData(contents: "어"),
        UserData(contents: "때"),
        UserData(contents: "?")



    ]
    
    static let todo: [UserData] = [
        UserData(contents: "공부하기"),
        UserData(contents: "Realm 언제해 ..")
    ]
    
    static let diary: [UserData] = [
        UserData(contents: "최근 블로그, 브런치 등의 기록형 SNS가 뜨면서 SNS에 일기를 작성하는 사람이 늘고 있다. 자신의 일상을 공유하는 것에서 그치는 게 아닌 전체공유로 오늘 하루 있었던 일과 당시 느꼈던 감정 등을 묘사해놓기도 한다. 굳이 SNS에 일기를 올리지 않더라도 자신의 일기장에 일기를 적는 사람들도 있다. 최근 SBS 예능프로그램 ‘집사부일체’에서 개그맨 양세형은 기분이 나쁜 날에 있었던 일을 일기로 남겨 스트레스를 해소한다고 고백했다. 이렇듯 사람마다 일기를 쓰는 방식은 가지각색이다. 대개 일기를 쓰는 행위가 정신건강에 도움이 된다고 알려져 있다. 과연 사실인지, SNS로 일기 쓰기와 손으로 쓰는 일기 중 어떤 방식이 더 정신건강에 도움이 되는지 알아봤다.")
    ]
}
