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
  fileprivate static var historyEventPool: [HistoryEvent] {
    var ret: [HistoryEvent]
    do {
      ret = try HistoryEventUnarchiver.getHistoryEventsArray()
      assert(ret.count >= eventNum,
          "Events per question is more than the total number of events in pool")
    } catch HistoryEventUnarchiveError.DictionaryConversionError(let data) {
      print("Cannot convert to [String: String] dictionary: ")
      print(data)
      fatalError()
    } catch HistoryEventUnarchiveError.MissingDescription(let dictData){
      print("Lack event description:")
      print(dictData)
      fatalError()
    } catch HistoryEventUnarchiveError.MissingTime(let dictData) {
      print("Lack time information of event:")
      print(dictData)
      fatalError()
    } catch HistoryEventUnarchiveError.InvalidTimeFormat(
      let dictData, let timeString) {
        print("Invalid time format: \(timeString)")
        print(dictData)
        fatalError()
    } catch HistoryEventUnarchiveError.MissingWikiUrl(let dictData) {
      print("Lack the wikipedia url of event:")
      print(dictData)
      fatalError()
    } catch HistoryEventUnarchiveError.InvalidWikiUrl(
      let dictData, let wikiUrlString) {
        print("Invalid wikipedia url: \(wikiUrlString)")
        print(dictData)
        fatalError()
    } catch {
      fatalError()
    }
    
    return ret
  }
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
   * Returns an initial order of events when question is displayed.
   */
   func getQuestionInitialOrder() -> [HistoryEvent] {
    return eventList
  }
  
  
  /**
   * Returns initial event descriptions list.
   */
  func getQuestionInitialOrderDesc() -> [String] {
    var descs: [String] = []
    for event in eventList {
      descs.append(event.description)
    }
    return descs
  }
}
