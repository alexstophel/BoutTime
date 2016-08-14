//
//  GameOverViewController.swift
//  BoutTime
//
//  Created by Alex Stophel on 8/14/16.
//  Copyright © 2016 Alex Stophel. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    if let presentingController = presentingViewController as? ViewController {
      scoreLabel.text = "\(presentingController.gameScore)/\(presentingController.roundsInGame)"
    }
  }

  @IBAction func restartGame(sender: AnyObject) {
    if let presentingController = presentingViewController as? ViewController {
      presentingController.resetGame()
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}
