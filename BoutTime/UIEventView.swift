//
//  UIEventView.swift
//  BoutTime
//
//  Created by Alex Stophel on 8/2/16.
//  Copyright © 2016 Alex Stophel. All rights reserved.
//

import UIKit

@IBDesignable
class UIEventView: UIView {
  var historicalEvent: HistoricalEvent?
  
  @IBInspectable var position: Int = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    layer.cornerRadius = 5
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  func updateEventValues(newEvent: HistoricalEvent) {
    historicalEvent = newEvent
    
    for view in subviews {
      if (view .isKindOfClass(UILabel)), let label = view as? UILabel {
        label.text = historicalEvent?.descriptionOfEvent
      }
    }
  }
  
  func disableEventButtons() {
    for subView in subviews {
      if (subView .isKindOfClass(UIEventButton)), let subView = subView as? UIEventButton {
        subView.enabled = false
      }
    }
  }
  
  func enableEventButtons() {
    for subView in subviews {
      if (subView .isKindOfClass(UIEventButton)), let subView = subView as? UIEventButton {
        subView.enabled = true
      }
    }
  }
}