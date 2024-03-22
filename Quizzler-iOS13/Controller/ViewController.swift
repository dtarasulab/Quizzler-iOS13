//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Edited by Dennis Tarasula on March 21, 2024.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
//  Enhancements:
//  1. The questions are randomly shuffled when the a new game is played.
//  2. A timer for each question and a scoring system that gives more points for answering faster, similar to Kahoot.
//  3. Added a label to keep track of the high score.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeProgressBar: UIProgressView!
    
    var quizBrain = QuizBrain()
    var timeRemaining = QuizBrain().questionTime
    var questionTimer: Timer?
    var timeTaken = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizBrain.shuffleQuestions()
        startQuestionTimer()
        updateUI()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        timeTaken = QuizBrain().questionTime - timeRemaining
        let userAnswer = sender.currentTitle!
        if timeRemaining > 0.01 {
            let userGotItRight = quizBrain.checkAnswer(userAnswer: userAnswer, timeTaken: timeTaken)
            if userGotItRight {
                sender.backgroundColor = UIColor.green
            } else {
                sender.backgroundColor = UIColor.red
            }
        }
        quizBrain.nextQuestion()
        timeProgressBar.setProgress(1, animated: false)
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        timeRemaining = QuizBrain().questionTime
        startQuestionTimer()
    }
    
    @objc func updateUI() {
        questionLabel.text = quizBrain.getQuestionText()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "Score: \(String(format: "%.0f", quizBrain.getScore()))"
        highScoreLabel.text = "High Score: \(String(format: "%.0f", quizBrain.getHighScore()))"
        trueButton.backgroundColor = UIColor.clear
        falseButton.backgroundColor = UIColor.clear
    }
    
    func startQuestionTimer() {
        questionTimer?.invalidate()
        questionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if timeRemaining > 0.01 {
            timeRemaining -= 0.01
            timeLabel.text = "Time left: \(String(format: "%.2f", timeRemaining))"
            let currentProgress = Float(timeRemaining) / Float(QuizBrain().questionTime)
            timeProgressBar.setProgress(currentProgress, animated: true)
        } else {
            questionTimer?.invalidate()
            timeLabel.text = "Out of time!"
            if quizBrain.getQuestionAnswer() == "True" {
                trueButton.backgroundColor = UIColor.green
                falseButton.backgroundColor = UIColor.red
            } else {
                trueButton.backgroundColor = UIColor.red
                falseButton.backgroundColor = UIColor.green
            }
        }
    }
}
