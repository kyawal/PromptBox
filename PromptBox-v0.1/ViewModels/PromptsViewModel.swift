//
//  PromptsViewModel.swift
//  PromptBox-v0.1
//
//  Created by Dhiraj Kyawal on 09/02/25.
//

import Foundation
import AppKit

class PromptsViewModel: ObservableObject {
    @Published var prompts: [Prompt] = []
    private let saveKey = "savedPrompts"
    
    init() {
        loadPrompts()
    }
    
    func addPrompt(title: String, content: String) {
        let prompt = Prompt(title: title, content: content)
        prompts.append(prompt)
        savePrompts()
    }
    
    func deletePrompt(at offsets: IndexSet) {
        prompts.remove(atOffsets: offsets)
        savePrompts()
    }
    
    func copyToClipboard(_ content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
    }
    
    private func savePrompts() {
        if let encoded = try? JSONEncoder().encode(prompts) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadPrompts() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Prompt].self, from: data) {
            prompts = decoded
        }
    }
}

