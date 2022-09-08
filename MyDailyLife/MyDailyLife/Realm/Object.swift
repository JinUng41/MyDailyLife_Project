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
    
    @Persisted(primaryKey: true) var _scheduleId: ObjectId
    
    convenience init(content: String?, startDate: Date, endDate: Date, memo: String?) {
        self.init()
        self.content = content
        self.startDate = startDate
        self.endDate = endDate
        self.memo = memo
    }
    
}

class Todo: Object {
    @Persisted var content: String? // 내용
    @Persisted var writeDate = Date() // 날짜

    @Persisted(primaryKey: true) var _todoId: ObjectId

    convenience init(content: String?, writeDate: Date) {
        self.init()
        self.content = content
        self.writeDate = writeDate
    }
    override var hash: Int {
        return _todoId.hash
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
    override var hash: Int {
        return _diaryId.hash
    }
}


