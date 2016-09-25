//
//  HistoryEventUnarchiver.swift
//  bout-time
//
//  Created by Yi YU on 9/24/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//

import Foundation


enum HistoryEventUnarchiveError: Error {
  case DictionaryConversionError(data: Any)
  case MissingDescription(dictData: [String: String])
  case MissingTime(dictData: [String: String])
  case InvalidTimeFormat(dictData: [String: String], timeString: String)
  case MissingWikiUrl(dictData: [String: String])
  case InvalidWikiUrl(dictData: [String: String], wikiUrlString: String)
}


class HistoryEventUnarchiver {
  class func getHistoryEventsArray() throws -> [HistoryEvent] {
    let historyEventFileName = "history-events"
    let historyEventFileType = "plist"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    
    var historyEvents: [HistoryEvent] = []

    do {
      let data = try PlistConverter.getArrayFromPlist(
          fileName: historyEventFileName, fileType: historyEventFileType)
      
      for eventData in data {
        guard let eventDict = eventData as? [String: String] else {
          throw HistoryEventUnarchiveError.DictionaryConversionError(
            data: eventData)
        }
        
        guard let description = eventDict["description"] else {
          throw HistoryEventUnarchiveError.MissingDescription(
              dictData: eventDict)
        }
        
        guard let timeString = eventDict["time"] else {
          throw HistoryEventUnarchiveError.MissingTime(dictData: eventDict)
        }
        
        guard let time = dateFormatter.date(from: timeString) else {
          throw HistoryEventUnarchiveError.InvalidTimeFormat(
            dictData: eventDict, timeString: timeString)
        }
        
        guard let wikiUrlString = eventDict["wikiUrl"] else {
          throw HistoryEventUnarchiveError.MissingWikiUrl(dictData: eventDict)
        }
        
        guard let wikiUrl = URL(string: wikiUrlString) else {
          throw HistoryEventUnarchiveError.InvalidWikiUrl(
            dictData: eventDict, wikiUrlString: wikiUrlString)
        }
        
        historyEvents.append(HistoryEvent(description, time, wikiUrl))
      }
    } catch PlistConversionError.InvalidResource {
      print("Invalid file name or file type, please check.")
      fatalError()
    } catch PlistConversionError.ArrayConversionError {
      print("Failed to conver to swift array")
      fatalError()
    } catch {
      fatalError()
    }
    
    return historyEvents
  }
}
