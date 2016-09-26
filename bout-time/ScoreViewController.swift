//
//  ScoreViewController.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//

import UIKit


class ScoreViewController: UIViewController {
  var delegate: ViewController!
  var scoreText: String!
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    scoreLabel.text = scoreText
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  @IBAction func dissmissView() {
    delegate.dismissScoreView()
  }
}
