//
//  Question.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//
import GameplayKit


class Question: Hashable {
  fileprivate static let eventNum: Int = 4
  fileprivate static var historyEventPool =
      HistoryEventUnarchiver.getHistoryEventsArray()
  
  let hashValue: Int
  
  fileprivate var eventSet = Set<HistoryEvent>()
  fileprivate var eventList: [HistoryEvent] = []
  
  
  /**
   * Generate a question of evenNum historical events randomly from the give
   * hisotry events pool.
   */
  init() {
    let gkRandomSource = GKRandomSource.sharedRandom()
    var newEvent: HistoryEvent
    
    for _ in 0..<Question.eventNum {
      repeat {
        let index = gkRandomSource.nextInt(
            upperBound: Question.historyEventPool.count)
        newEvent = Question.historyEventPool[index]
      } while eventSet.contains(newEvent)
      eventSet.insert(newEvent)
      eventList.append(newEvent)
    }
    
    hashValue = eventSet.hashValue
  }
  
  
  /**
   * Two questions are regarded as same if they contain the same set of
   * history events.
   */
  static func ==(q1: Question, q2: Question) -> Bool {
    return q1.eventSet.symmetricDifference(q2.eventSet).count == 0
  }
  
  
  /**
   * Checks whether the given user answer is correct.
   */
  func checkAnswer(_ userAnswer: UserAnswer) -> Bool {
    let userAnswerEventOrder = userAnswer.getCurrentEventOrder()
    for i in 0..<userAnswerEventOrder.count - 1 {
      if userAnswerEventOrder[i].laterThan(userAnswerEventOrder[i + 1]) {
        return false
      }
    }
    return true
  }
  
  
  /**
   * Returns an initial order of events when question is displayed as a
   * default user answer.
   */
   func getDefaultUserAnswer() -> UserAnswer {
    return UserAnswer(eventList)
  }
}
