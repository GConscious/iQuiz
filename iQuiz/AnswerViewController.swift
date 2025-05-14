//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/13/25.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var instructions: UILabel!
    
    var isCorrect: Bool = false
    var correctAnswer: String = ""
    var questionText: String = ""
    var selectedAnswer: String = ""
    var totalQuestions: Int = 0
    var currentScore: Int = 0
    var currentQuestionIndex: Int = 0
    var questions: [(question: String, options: [String], correct: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = questionText
        answerLabel.text = isCorrect ? "Correct!" : "Incorrect."
        correctLabel.text = "Your answer: \(selectedAnswer)\nCorrect answer: \(correctAnswer)"
        nextButton.setTitle(currentQuestionIndex == totalQuestions - 1 ? "Finish" : "Next", for: .normal)
        instructions.isHidden = true
        addGestures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showInstructions()
        }
    }
    
    func addGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeRightAction() {
        performNext()
    }
    
    @objc func swipeLeftAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performNext()
    }
    
    func performNext() {
        if currentQuestionIndex < totalQuestions - 1 {
            performSegue(withIdentifier: "nextQuestion", sender: self)
        } else {
            performSegue(withIdentifier: "showFinished", sender: self)
        }
    }
    
    func showInstructions() {
        instructions.isHidden = false
        instructions.text = "Swipe Right for Next, Swipe Left to Return to Main"
        instructions.numberOfLines = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            let finalScore = isCorrect ? currentScore + 1 : currentScore
            finishedVC.score = finalScore
            finishedVC.totalQuestions = totalQuestions
        } else if segue.identifier == "nextQuestion",
                  let questionVC = segue.destination as? QuestionViewController {
            questionVC.allQuestions = questions
            questionVC.currIndex = currentQuestionIndex + 1
            questionVC.score = isCorrect ? currentScore + 1 : currentScore
            let nextQ = questions[currentQuestionIndex + 1]
            questionVC.question = nextQ.question
            questionVC.options = nextQ.options
            questionVC.correct = nextQ.correct
            questionVC.answer = nil
        }
    }
}
