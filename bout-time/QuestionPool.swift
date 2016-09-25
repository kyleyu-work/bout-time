//
//  QuestionPool.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//


class QuestionPool: Trackable {
  let questionsPerRound: Int
  
  var questionsAsked: Int
  var questionsCorrectlyAnswered: Int
  var selectedQuestion: Question?
  var currentUserAnswer: UserAnswer?
  var askedQuestionSet = Set<Question>()
  
  
  init(questionsPerRound: Int) {
    self.questionsPerRound = questionsPerRound
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
  
  
  func getNextQuestion() -> Question {
    var newQuestion: Question
    repeat {
      newQuestion = Question()
    } while askedQuestionSet.contains(newQuestion)
    askedQuestionSet.insert(newQuestion)
    selectedQuestion = newQuestion
    currentUserAnswer = UserAnswer(newQuestion.getQuestionInitialOrder())
    questionsAsked += 1
    
    return newQuestion
  }
  
  
  func updateAnswer(eventIndex: Int, moveDirection: MoveDirection) {
    assert(currentUserAnswer != nil, "currentUserAnswer is nil")
    currentUserAnswer?.updateAnswer(
        eventIndex: eventIndex, moveDirection: moveDirection)
  }
  
  
  func checkAnswer() -> Bool {
    assert(selectedQuestion != nil && currentUserAnswer != nil,
        "selectedQuestion or currentUserAnswer is nil")
    return selectedQuestion!.checkAnswer(currentUserAnswer!)
  }
}
