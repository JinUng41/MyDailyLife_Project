//
//  Object.swift
//  MyDailyLife
//
//  Created by 유영재 on 2022/08/19.
//

import Foundation
import RealmSwift


class Schedule: Object {
    @Persisted var content: String? // 내용
    @Persisted var startDate = Date() // 시작날짜
    @Persisted var endDate = Date() // 종료날짜
    @Persisted var memo: String? // 메모
    @Persisted var allDay: Bool // 하루종일인지, 아닌지 토글

    @Persisted(primaryKey: true) var _scheduleId: ObjectId
    
    convenience init(content: String?, startDate: Date, endDate: Date, memo: String?, allDay: Bool) {
        self.init()
        self.content = content
        self.startDate = startDate
        self.endDate = endDate
        self.memo = memo
        self.allDay = allDay
    }
}

class Todo: Object {
    @Persisted var content: String? // 내용
    @Persisted var writeDate = Date() // 날짜
    @Persisted var alreadyDone: Bool // 이 할 일을 했는지 안했는지
    
    @Persisted(primaryKey: true) var _todoId: ObjectId

    convenience init(content: String?, writeDate: Date, alreadyDone: Bool) {
        self.init()
        self.content = content
        self.writeDate = writeDate
        self.alreadyDone = false
    }
}

class Diary: Object {
    @Persisted var content: String? // 내용
    @Persisted var writeDate = Date() // 날짜
    @Persisted var emotion: Int? // 감정
    
    @Persisted(primaryKey: true) var _diaryId: ObjectId
    
    convenience init(content: String?, writeDate: Date, emotion: Int?) {
        self.init()
        self.content = content
        self.writeDate = writeDate
        self.emotion = emotion
    }
}


