//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/13/25.
//

import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var score: Int = 0
    var totalQuestions: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if score == totalQuestions {
            performanceLabel.text = "Perfect!"
        } else if score >= totalQuestions - 1 {
            performanceLabel.text = "Almost!"
        } else {
            performanceLabel.text = "Good try!"
        }
        scoreLabel.text = "\(score) of \(totalQuestions) correct"
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
}
