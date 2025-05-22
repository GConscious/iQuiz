//
//  Storage.swift
//  iQuiz
//
//  Created by Amrith Gandham on 5/21/25.
//

import Foundation

class Storage {
    static let shared = Storage()
    private let fileName = "quizzes.json"
    
    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }
    
    func saveQuizzes(_ quizzes: [[String: Any]]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: quizzes, options: [])
            try data.write(to: fileURL)
        } catch {
            print("Failed to save quizzes: \(error)")
        }
    }
    
    func loadQuizzes() -> [[String: Any]]? {
        do {
            let data = try Data(contentsOf: fileURL)
            if let quizzes = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                return quizzes
            }
        } catch {
            print("Failed to load quizzes: \(error)")
        }
        return nil
    }
}
