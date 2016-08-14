//
//  ViewController.swift
//  BoutTime
//
//  Created by Alex Stophel on 8/2/16.
//  Copyright © 2016 Alex Stophel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let gameTimerInterval: NSTimeInterval = 1.0
  let roundsInGame: Int = 6

  var historicalEventModel = HistoricalEventModel()
  var gameTimer: NSTimer = NSTimer()
  var secondsRemainingInRound: Int = 60
  var currentRound: Int = 1
  var gameScore: Int = 0

  @IBOutlet weak var nextRoundButton: UIButton!
  @IBOutlet weak var timeLabel: UILabel!

  enum EventPositions: Int {
    case One = 1, Two, Three, Four
  }

  @IBOutlet weak var firstEventView: UIEventView!
  @IBOutlet weak var secondEventView: UIEventView!
  @IBOutlet weak var thirdEventView: UIEventView!
  @IBOutlet weak var fourthEventView: UIEventView!

  override func viewDidLoad() {
    super.viewDidLoad()
    startNewRound()
  }
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    roundDidEnd()
  }
  
  @IBAction func moveEventUp(sender: UIButton) {
    if let eventView = sender.superview as? UIEventView {
      moveEvent(byPositionInterval: -1, eventView: eventView)
    }
  }
  
  @IBAction func moveEventDown(sender: UIButton) {
    if let eventView = sender.superview as? UIEventView {
      moveEvent(byPositionInterval: 1, eventView: eventView)
    }
  }
  
  @IBAction func startNewRound() {
    nextRoundButton.hidden = true
    timeLabel.hidden = false
    
    if (currentRound == roundsInGame) {
      showGameScore()
    } else {
      currentRound += 1
      enableMoveButtons()
    
      var events = historicalEventModel.getNewEventSet()
      let eventViews = [firstEventView, secondEventView, thirdEventView, fourthEventView]
    
      for eventView in eventViews {
        if let historicalEvent = events.popLast() {
          eventView.updateEventValues(historicalEvent)
        }
      }
    
      secondsRemainingInRound = 60
      timeLabel.text = "0:\(secondsRemainingInRound)"
      gameTimer = NSTimer.scheduledTimerWithTimeInterval(gameTimerInterval,
                    target: self,
                    selector: #selector(ViewController.gameTimerCountDown),
                    userInfo: nil,
                    repeats: true)
    }
  }
  
  func resetGame() {
    currentRound = 0
    gameScore = 0
    startNewRound()
  }

  // MARK: Private Methods

  @objc private func gameTimerCountDown() {
    secondsRemainingInRound -= 1
    
    if (secondsRemainingInRound > 9) {
      timeLabel.text = "0:\(secondsRemainingInRound)"
    } else if (secondsRemainingInRound > 0) {
      timeLabel.text = "0:0\(secondsRemainingInRound)"
    } else {
      timeLabel.text = "0:00"
      roundDidEnd()
    }
  }

  private func showGameScore() {
    let gameOverController = self.storyboard?.instantiateViewControllerWithIdentifier("gameOverViewController")
    
    if let gameOverController = gameOverController {
      presentViewController(gameOverController, animated: true, completion: nil)
    } else {
      fatalError()
    }
  }

  private func getEventView(atPosition: EventPositions) -> UIEventView {
    switch atPosition {
      case .One: return firstEventView
      case .Two: return secondEventView
      case .Three: return thirdEventView
      case .Four: return fourthEventView
    }
  }

  private func moveEvent(byPositionInterval interval: Int, eventView: UIEventView) {
    let currentEventPosition = eventView.position
    let newEventPositionValue = currentEventPosition + interval
      
    if let newEventPosition = EventPositions(rawValue: newEventPositionValue) {
      let newEventView = getEventView(newEventPosition)
      
      swapEvents(eventViewA: newEventView, eventViewB: eventView)
    }
  }
  
  private func swapEvents(eventViewA viewA: UIEventView, eventViewB viewB: UIEventView) {
    if let viewAEvent = viewA.historicalEvent, let viewBEvent = viewB.historicalEvent {
      viewA.updateEventValues(viewBEvent)
      viewB.updateEventValues(viewAEvent)
    }
  }
  
  private func roundDidEnd() {
    timeLabel.hidden = true
    gameTimer.invalidate()
    nextRoundButton.hidden = false
    
    disableMoveButtons()
    
    if (!areEventsOrderedCorrectly(currentEventsInOrder())) {
      nextRoundButton.setImage(UIImage(named: "NextRoundFail"), forState: .Normal)
    } else {
      nextRoundButton.setImage(UIImage(named: "NextRoundSuccess"), forState: .Normal)
      self.gameScore += 1
    }
  }
  
  private func disableMoveButtons() {
    let eventViews = [firstEventView, secondEventView, thirdEventView, fourthEventView]
    
    
    for eventView in eventViews {
      eventView.disableEventButtons()
    }
  }
  
  private func enableMoveButtons() {
    let eventViews = [firstEventView, secondEventView, thirdEventView, fourthEventView]
    
    for eventView in eventViews {
      eventView.enableEventButtons()
    }
  }
  
  private func currentEventsInOrder() -> [HistoricalEvent] {
    if let eventOne = firstEventView.historicalEvent,
       let eventTwo = secondEventView.historicalEvent,
       let eventThree = thirdEventView.historicalEvent,
       let eventFour = fourthEventView.historicalEvent {
      return [eventOne, eventTwo, eventThree, eventFour]
    } else {
      fatalError()
    }
  }
  
  private func areEventsOrderedCorrectly(events: [HistoricalEvent]) -> Bool {
    var lastEventDate: NSDate?
    
    for historicalEvent in currentEventsInOrder() {
      
      guard (lastEventDate != nil) else {
        lastEventDate = historicalEvent.dateOfEvent
        continue
      }
      
      if (historicalEvent.dateOfEvent.compare(lastEventDate!) == NSComparisonResult.OrderedAscending) {
        return false
      }
      
      lastEventDate = historicalEvent.dateOfEvent
    }
    
    return true
  }
}
