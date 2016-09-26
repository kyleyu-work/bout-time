//
//  QuestionPool.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//
import Foundation


class QuestionPool: Trackable {
  let questionsPerRound: Int
  let timeAllowedPerQuestion: Int
  
  var questionsAsked: Int
  var questionsCorrectlyAnswered: Int
  fileprivate var selectedQuestion: Question!
  fileprivate var currentUserAnswer: UserAnswer!
  fileprivate var askedQuestionSet = Set<Question>()
  
  
  init(_ questionsPerRound: Int, _ timeAllowedPerQuestion: Int) {
    self.questionsPerRound = questionsPerRound
    self.timeAllowedPerQuestion = timeAllowedPerQuestion
    self.questionsAsked = 0
    self.questionsCorrectlyAnswered = 0
  }
  
  
  /**
   * Returns whether the game should be ended.
   */
  func isGameEnded() -> Bool {
    return questionsAsked == questionsPerRound
  }
  
  
  /**
   * Returns the number of questions answered correctly.
   */
  func getCorrectlyAnsweredQuestionNum() -> Int {
    return questionsCorrectlyAnswered
  }
  
  
  /**
   * Returns the number of questions for each round.
   */
  func getQuestionNumPerRound() -> Int {
    return questionsPerRound
  }
  
  
  /**
   * Reset the tracking stats.
   */
  func resetStats() {
    questionsAsked = 0
    questionsCorrectlyAnswered = 0
  }
  
  
  func getNextQuestion() -> Question {
    var newQuestion: Question
    repeat {
      newQuestion = Question()
    } while askedQuestionSet.contains(newQuestion)
    askedQuestionSet.insert(newQuestion)
    selectedQuestion = newQuestion
    currentUserAnswer = newQuestion.getDefaultUserAnswer()
    questionsAsked += 1
    
    return newQuestion
  }
  
  
  func updateAnswer(eventIndex: Int, moveDirection: MoveDirection) {
    assert(currentUserAnswer != nil, "currentUserAnswer is nil")
    currentUserAnswer.updateAnswer(
        eventIndex: eventIndex, moveDirection: moveDirection)
  }
  
  
  func checkAnswer() -> Bool {
    assert(selectedQuestion != nil && currentUserAnswer != nil,
        "selectedQuestion or currentUserAnswer is nil")
    let isAnswerCorrect = selectedQuestion.checkAnswer(currentUserAnswer)
    if isAnswerCorrect {
      questionsCorrectlyAnswered += 1
    }
    return isAnswerCorrect
  }
  
  
  func getUserAnswerEventDescriptions() -> [String] {
    return currentUserAnswer.getCurrentAnswerDescriptions()
  }
  
  
  func getWikiUrlForEvent(atCurrentUserAnswerIndex: Int) -> URL {
    return currentUserAnswer.getCurrentEventOrder()[atCurrentUserAnswerIndex]
        .wikiUrl
  }
}
