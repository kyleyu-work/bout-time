//
//  HistoryEvent.swift
//  bout-time
//
//  Created by Yi YU on 9/24/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//
import Foundation

struct HistoryEvent: Hashable {
  let description: String
  let time: Date
  let wikiUrl: URL
  
  let hashValue: Int
  
  init(_ description: String, _ time: Date, _ wikiUrl: URL) {
    self.description = description
    self.time = time
    self.wikiUrl = wikiUrl
    self.hashValue = description.hashValue
  }
  
  
  func laterThan(_ event: HistoryEvent) -> Bool {
    return time > event.time
  }
  
  
  static func ==(e1: HistoryEvent, e2: HistoryEvent) -> Bool {
    return e1.description == e2.description
  }
}
