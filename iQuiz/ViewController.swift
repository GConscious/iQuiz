//
//  ViewController.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/5/25.
//

import UIKit
import SystemConfiguration


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
        quiz.delegate = self
        quiz.dataSource = self
        let urlString = UserDefaults.standard.string(forKey: "quizDataURL") ?? "https://tednewardsandbox.site44.com/questions.json"
        fetchQuizData(from: urlString)
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
                ("What is 10 / 1?", ["3", "5", "10"], 2)
            ]
        case 1:
            questions = [
                ("Who is Iron Man?", ["Tony Stark", "Bruce Wayne", "Clark Kent", "Agent Coulson"], 0),
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
            destinationVC.allQuestions = questions
            if let first = questions.first {
                destinationVC.question = first.question
                destinationVC.options = first.options
                destinationVC.correct = first.correct
                destinationVC.currIndex = 0
                destinationVC.score = 0
                destinationVC.answer = nil
            }
        }
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Enter quiz data URL", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Quiz Data URL"
                textField.text = UserDefaults.standard.string(forKey: "quizDataURL") ?? "https://tednewardsandbox.site44.com/questions.json"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { [weak self] _ in
                guard let urlField = alert.textFields?.first, let urlString = urlField.text else { return }
                UserDefaults.standard.set(urlString, forKey: "quizDataURL")
                self?.fetchQuizData(from: urlString)
            }))
            present(alert, animated: true)
        }
    
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else { return false }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) { return false }
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
    func fetchQuizData(from urlString: String) {
        guard isNetworkAvailable() else {
            let alert = UIAlertController(title: "Network Error", message: "Network is not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    return
                }
                guard let data = data else { return }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        self?.parseQuizData(jsonArray)
                    }
                } catch {
                    let alert = UIAlertController(title: "Parse Error", message: "Failed to parse quiz data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
        task.resume()
    }
    
    func parseQuizData(_ jsonArray: [[String: Any]]) {
        topics = jsonArray.compactMap { $0["title"] as? String }
        quizDescription = jsonArray.compactMap { $0["desc"] as? String }
        // Optionally handle images if available in JSON
        images = Array(repeating: "defaultImage", count: topics.count)
        // Reload your table view
        quiz.reloadData()
    }
}

