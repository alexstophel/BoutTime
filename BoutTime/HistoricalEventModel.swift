//
//  HistoricalEventModel.swift
//  BoutTime
//
//  Created by Alex Stophel on 8/3/16.
//  Copyright © 2016 Alex Stophel. All rights reserved.
//

import Foundation
import GameKit

struct HistoricalEvent {
  let descriptionOfEvent: String
  let dateOfEvent: NSDate
}

class HistoricalEventImporter {
  class func fromPlistFile(path path: String) -> [HistoricalEvent] {
    var historicalEvents: [HistoricalEvent] = []
    
    if let eventDicts = NSArray(contentsOfFile: path) as? [[String:AnyObject]] {
      for eventDict in eventDicts {
        if let description = eventDict["Description"] as? String,
           let date = eventDict["Date"] as? NSDate {
          
          let newEvent = HistoricalEvent(descriptionOfEvent: description, dateOfEvent: date)
          historicalEvents.append(newEvent)
        }
      }
    }
    
    return historicalEvents
  }
}

class HistoricalEventModel {
  var events: [HistoricalEvent]
  
  let filePath = NSBundle.mainBundle().pathForResource("AmericanRevolution", ofType: "plist")!
  
  init() {
    events = HistoricalEventImporter.fromPlistFile(path: filePath)
    print(events)
  }
  
  func getNewEventSet() -> [HistoricalEvent] {
    var eventSet: [HistoricalEvent] = []
    var indexesInEventSet: [Int] = []
    var randomIndex: Int = 0
    
    repeat {
      repeat {
        randomIndex = GKRandomSource.sharedRandom().nextIntWithUpperBound(events.count)
      } while indexesInEventSet.contains(randomIndex)
      
      indexesInEventSet.append(randomIndex)
      
      eventSet.append(events[randomIndex])
    } while eventSet.count != 4
    
    return eventSet
  }
}