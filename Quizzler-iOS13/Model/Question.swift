//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Dennis Tarasula on 3/13/24.
//

import Foundation

struct Question {
    let text: String
    let answer: String
    
    init(q: String, a: String) {
        text = q
        answer = a
    }
}
