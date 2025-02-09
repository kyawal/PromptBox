//
//  PromptBox_v0_1App.swift
//  PromptBox-v0.1
//
//  Created by Dhiraj Kyawal on 09/02/25.
//

import SwiftUI

@main
struct PromptBox_v0_1App: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
