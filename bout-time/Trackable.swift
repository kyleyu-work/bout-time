//
//  Trackable.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//


protocol Trackable {
  var questionsPerRound: Int { get }
  var questionsAsked: Int { get set }
  var questionsCorrectlyAnswered: Int { get set }
  
  
  /**
   * Returns whether the game should be ended.
   */
  func isGameEnded() -> Bool
  
  
  /**
   * Returns the number of questions answered correctly.
   */
  func getCorrectlyAnsweredQuestionNum() -> Int
  
  
  /**
   * Returns the number of questions for each round.
   */
  func getQuestionNumPerRound() -> Int
  
  
  /**
   * Reset the tracking stats.
   */
  func resetStats()
}
