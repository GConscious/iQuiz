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
    @IBOutlet weak var backButton: UIButton!
    
    var isCorrect: Bool = false
    var correctAnswer: String = ""
    var questionText: String = ""
    var selectedAnswer: String = ""
    var totalQuestions: Int = 0
    var currentScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        question.text = questionText
        answerLabel.text = isCorrect ? "Correct!" : "Incorrect."
        correctLabel.text = "Your answer: \(selectedAnswer)\nCorrect answer: \(correctAnswer)"
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "nextQuestion", sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            let finalScore = isCorrect ? currentScore + 1 : currentScore
            finishedVC.score = finalScore
            finishedVC.totalQuestions = totalQuestions
        }
    }
}
