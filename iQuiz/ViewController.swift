//
//  ViewController.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/5/25.
//

import UIKit

class quizCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDesciption: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var quiz: UITableView!

    var topics = ["Mathematics", "Marvel Super Heros", "Science"]
    var quizDescription = ["Math Quiz", "Marvel Quiz", "Science Quiz"]
    var images = ["math", "marvel", "science"]
    var questions: [(question: String, options: [String], correct: Int)] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quiz.delegate = self
        quiz.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat{
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! quizCell
        cell.cellTitle?.text = topics[indexPath.row]
        cell.cellDesciption?.text = quizDescription[indexPath.row]
        cell.cellImage?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            questions = [
                ("What is 2 + 2?", ["3", "4", "5"], 1),
                ("What is 10 / 2?", ["3", "5", "10"], 1)
            ]
        case 1:
            questions = [
                ("Who is Iron Man?", ["Tony Stark", "Bruce Wayne", "Clark Kent"], 0),
                ("What is Captain America's shield made of?", ["Adamantium", "Vibranium", "Titanium"], 1)
            ]
        case 2:
            questions = [
                ("What planet is known as the Red Planet?", ["Earth", "Mars", "Jupiter"], 1),
                ("What gas do plants absorb from the atmosphere?", ["Oxygen", "Carbon Dioxide", "Nitrogen"], 1)
            ]
        default:
            questions = []
        }
        performSegue(withIdentifier: "questionSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionSegue" {
            let destinationVC = segue.destination as! QuestionViewController
            destinationVC.questions = questions
        }
    }
    
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
            let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}

