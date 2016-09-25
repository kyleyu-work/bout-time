//
//  UserAnswer.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//


class UserAnswer {
  fileprivate var currentEventOrder: [HistoryEvent] = []
  
  
  init(_ eventList: [HistoryEvent]) {
    for event in eventList {
      currentEventOrder.append(event)
    }
  }
  
  
  func getCurrentEventOrder() -> [HistoryEvent] {
    return currentEventOrder
  }
  
  
  /**
   * Updates the user answer.
   */
  func updateAnswer(eventIndex: Int, moveDirection: MoveDirection) {
    var swappedEventIndex: Int
    
    switch moveDirection {
    case .UP:
      swappedEventIndex = eventIndex - 1
    case .DOWN:
      swappedEventIndex = eventIndex + 1
    }
    
    swapTwoEventOrder(eventIndex1: eventIndex, eventIndex2: swappedEventIndex)
  }
  
  
  fileprivate func swapTwoEventOrder(eventIndex1: Int, eventIndex2: Int) {
    var tmp: HistoryEvent
    tmp = currentEventOrder[eventIndex2]
    currentEventOrder[eventIndex2] = currentEventOrder[eventIndex1]
    currentEventOrder[eventIndex1] = tmp
  }
}
