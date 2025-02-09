//
//  Prompt.swift
//  PromptBox-v0.1
//
//  Created by Dhiraj Kyawal on 09/02/25.
//

import Foundation

struct Prompt: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    
    init(id: UUID = UUID(), title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
} 
