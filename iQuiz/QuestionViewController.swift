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
    @IBOutlet weak var instructions: UILabel!
    
    var question: String = ""
    var options: [String] = []
    var correct: Int = 0
    var answer: Int?
    var allQuestions: [(question: String, options: [String], correct: Int)] = []
    var currIndex: Int = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question
        questionLabel.numberOfLines = 2
        tableView.delegate = self
        tableView.dataSource = self
        submitBtn.isEnabled = false
        instructions.isHidden = true
        gestures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gestureDisplay()
        }
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        submit()
    }
    
    func gestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightfunc))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftfunc))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeRightfunc() {
        submit()
    }

    @objc func swipeLeftfunc() {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    func gestureDisplay() {
        instructions.isHidden = false
        instructions.text = "Swipe Right to Submit, Swipe Left to Return to Main"
        instructions.numberOfLines = 2
    }

    func submit() {
        guard let _ = answer else { return }
        performSegue(withIdentifier: "showAnswer", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return options.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") ?? UITableViewCell(style: .default, reuseIdentifier: "optionCell")
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = (indexPath.row == answer) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        answer = indexPath.row
        submitBtn.isEnabled = true
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswer",
           let destination = segue.destination as? AnswerViewController,
           let selected = answer {
            destination.questionText = question
            destination.correctAnswer = options[correct]
            destination.isCorrect = (selected == correct)
            destination.selectedAnswer = options[selected]
            destination.totalQuestions = allQuestions.count
            destination.currentScore = score + (selected == correct ? 1 : 0)
            destination.currentQuestionIndex = currIndex
            destination.questions = allQuestions
        }
    }
}

