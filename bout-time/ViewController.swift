//
//  ViewController.swift
//  bout-time
//
//  Created by Yi YU on 9/24/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//

import UIKit


enum MoveDirection {
  case UP
  case DOWN
}


class ViewController: UIViewController {
  fileprivate let storyBoard = UIStoryboard(name: "Main", bundle: nil)
  fileprivate let questionsPerRound = 4
  fileprivate let timeAllowedPerQuestion = 35
  fileprivate var questionPool: QuestionPool!
  fileprivate var timeLeft: Int = 0
  fileprivate var timer: Timer?
  fileprivate var resultIsShown: Bool = false

  @IBOutlet var eventDescriptionButtons: [UIButton]!
  @IBOutlet var moveDownButtons: [UIButton]!
  @IBOutlet var moveUpButtons: [UIButton]!
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var correctAnswerNextRoundButton: UIButton!
  @IBOutlet weak var incorrectAnswerNextRoundButton: UIButton!
  @IBOutlet weak var instructionLabel: UILabel!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configMoveButtons()
    questionPool = QuestionPool(questionsPerRound, timeAllowedPerQuestion)
    startNewRound()
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == UIEventSubtype.motionShake && !resultIsShown {
      showResult()
    }
  }
  

  @IBAction func onEventCardLabelTapped(_ sender: UIButton) {
    // TODO: Add model view for wiki page
    let webViewController = storyBoard.instantiateViewController(
        withIdentifier: "webViewController") as! WebViewController
    webViewController.wikiUrl =
        questionPool.getWikiUrlForEvent(atCurrentUserAnswerIndex: sender.tag)
    present(webViewController, animated: true, completion: nil)
  }
  
  
  @IBAction func onUpButtonTapped(_ sender: UIButton) {
    questionPool.updateAnswer(eventIndex: sender.tag, moveDirection: .UP)
    swapDescription(sender.tag, sender.tag - 1)
  }
  

  @IBAction func onDownButtonTapped(_ sender: UIButton) {
    questionPool.updateAnswer(eventIndex: sender.tag, moveDirection: .DOWN)
    swapDescription(sender.tag, sender.tag + 1)
  }
  
  
  @IBAction func onNextRoundButtonTapped(_ sender: UIButton) {
    if !questionPool.isGameEnded() {
      startNewRound()
    } else {
      displayScores()
    }
  }
  
  
  fileprivate func startNewRound() {
    resultIsShown = false
    displayEvents(questionPool.getNextQuestion())
    restartTimer()
    correctAnswerNextRoundButton.isHidden = true
    incorrectAnswerNextRoundButton.isHidden = true
    updateInstructionLabel(resultIsShown)
    updateMoveButtonsStatus(isEnabled: true)
    updateEventDescriptionButtonsStatus(isEnabled: false)
  }
  
  
  /**
   * Display events.
   */
  fileprivate func displayEvents(_ question: Question) {
    var descriptionList =
        question.getDefaultUserAnswer().getCurrentAnswerDescriptions()
    for i in 0..<descriptionList.count {
      for eventDescriptionButton in eventDescriptionButtons {
        if eventDescriptionButton.tag == i {
          eventDescriptionButton.setTitle(
              descriptionList[i], for: UIControlState.normal)
        }
      }
    }
  }
  
  
  /**
   * Swap event descriptions of two given card labels.
   */
  fileprivate func swapDescription(_ eventDescriptionButtonTag1: Int,
      _ eventDescriptionButtonTag2: Int) {
    var btn1: UIButton!
    var btn2: UIButton!
    for eventDescriptionButton in eventDescriptionButtons {
      if eventDescriptionButton.tag == eventDescriptionButtonTag1 {
        btn1 = eventDescriptionButton
      } else if eventDescriptionButton.tag == eventDescriptionButtonTag2 {
        btn2 = eventDescriptionButton
      }
    }
    
    let tmp = btn1.title(for: UIControlState.normal)
    btn1.setTitle(
        btn2.title(for: UIControlState.normal), for: UIControlState.normal)
    btn2.setTitle(tmp, for: UIControlState.normal)
  }
  
  
  /**
   * Restart timer
   */
  fileprivate func restartTimer() {
    timeLeft = questionPool.timeAllowedPerQuestion
    timer = Timer.scheduledTimer(
      timeInterval: 1,
      target: self,
      selector: #selector(decreaseTime),
      userInfo: nil,
      repeats: true)
    updateTimerLabel()
  }
  
  
  /**
   * Decerase the time allowed for each question per second.
   */
  func decreaseTime() {
    timeLeft -= 1
    updateTimerLabel()
    if timeLeft == 0 {
      showResult()
    }
  }
  
  
  /**
   * Update the timer label content.
   */
  fileprivate func updateTimerLabel() {
    timerLabel.isHidden = false
    timerLabel.text = "0:\(timeLeft)"
  }
  
  
  /**
   * Display the instruction label.
   */
  fileprivate func updateInstructionLabel(_ resultIsShown: Bool) {
    if (resultIsShown) {
      instructionLabel.text = "Tap events to learn more"
    } else {
      instructionLabel.text = "Shake to complete"
    }
  }
  
  
  /**
   * Shows result after users shake device or time limit expired.
   */
  fileprivate func showResult() {
    resultIsShown = true
    timer?.invalidate()
    timerLabel.isHidden = true
    let answerIsCorrect = questionPool.checkAnswer()
    if answerIsCorrect {
      correctAnswerNextRoundButton.isHidden = false
    } else {
      incorrectAnswerNextRoundButton.isHidden = false
    }
    updateInstructionLabel(resultIsShown)
    updateMoveButtonsStatus(isEnabled: false)
    updateEventDescriptionButtonsStatus(isEnabled: true)
  }
  
  
  fileprivate func configMoveButtons() {
    let state = UIControlState.highlighted
    let up_half_selected = UIImage(named: "up_half_selected")
    let up_full_selected = UIImage(named: "up_full_selected")
    let down_half_selected = UIImage(named: "down_half_selected")
    let down_full_selected = UIImage(named: "down_full_selected")
    for moveUpButton in moveUpButtons {
      if moveUpButton.tag == 3 {
        moveUpButton.setImage(up_full_selected, for: state)
      } else {
        moveUpButton.setImage(up_half_selected, for: state)
      }
    }
    
    for moveDownButton in moveDownButtons {
      if moveDownButton.tag == 0 {
        moveDownButton.setImage(
            down_full_selected, for: state)
      } else {
        moveDownButton.setImage(
            down_half_selected, for: state)
      }
    }
  }
  
  
  fileprivate func updateEventDescriptionButtonsStatus(isEnabled: Bool) {
    for eventDescriptionButton in eventDescriptionButtons {
      eventDescriptionButton.isEnabled = isEnabled
    }
  }
  
  
  fileprivate func updateMoveButtonsStatus(isEnabled: Bool) {
    for moveUpButton in moveUpButtons {
      moveUpButton.isEnabled = isEnabled
    }
    
    for moveDownButton in moveDownButtons {
      moveDownButton.isEnabled = isEnabled
    }
  }
  
  
  fileprivate func displayScores() {
    let correctAnswers = questionPool.getCorrectlyAnsweredQuestionNum()
    let totalQuestions = questionPool.getQuestionNumPerRound()
    let scoreViewController = storyBoard.instantiateViewController(
        withIdentifier: "scoreViewController") as! ScoreViewController
    scoreViewController.delegate = self
    scoreViewController.scoreText = "\(correctAnswers)/\(totalQuestions)"
    present(scoreViewController, animated: false, completion: nil)
  }
  
  
  func dismissScoreView() {
    dismiss(animated: false, completion: nil)
    questionPool.resetStats()
    startNewRound()
  }
}

