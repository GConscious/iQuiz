//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/12/25.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var questions: [(question: String, options: [String], correct: Int)] = []
    var currentQuestionIndex = 0
    var selectedOptionIndex: Int? = nil
    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateQuestion()
        submitBtn.isEnabled = false
    }
    
    func updateQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.question
        selectedOptionIndex = nil
        submitBtn.isEnabled = false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard currentQuestionIndex < questions.count else { return 0 }
        return questions[currentQuestionIndex].options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard currentQuestionIndex < questions.count else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        cell.textLabel?.text = questions[currentQuestionIndex].options[indexPath.row]
        cell.accessoryType = (indexPath.row == selectedOptionIndex) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOptionIndex = indexPath.row
        submitBtn.isEnabled = true
        tableView.reloadData()
    }
    @IBAction func submitAnswer(_ sender: UIButton) {
        guard let selectedIndex = selectedOptionIndex else { return }
        let correctIndex = questions[currentQuestionIndex].correct
        if selectedIndex == correctIndex {
            performSegue(withIdentifier: "showAnswer", sender: true)
        } else {
            performSegue(withIdentifier: "showAnswer", sender: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswer",
           let answerVC = segue.destination as? AnswerViewController,
           let selected = selectedOptionIndex {
            let current = questions[currentQuestionIndex]
            answerVC.questionText = current.question
            answerVC.correctAnswer = current.options[current.correct]
            answerVC.isCorrect = (selected == current.correct)
            answerVC.selectedAnswer = current.options[selected]
            answerVC.totalQuestions = questions.count
            answerVC.currentScore = score
        } else if segue.identifier == "nextQuestion" {
            if let answerVC = sender as? AnswerViewController, answerVC.isCorrect {
                score += 1
            }
            currentQuestionIndex += 1
            if currentQuestionIndex < questions.count {
                updateQuestion()
            } else {
                performSegue(withIdentifier: "showFinished", sender: self)
            }
        } else if segue.identifier == "showFinished",
                  let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.score = score
            finishedVC.totalQuestions = questions.count
        }
    }
}

