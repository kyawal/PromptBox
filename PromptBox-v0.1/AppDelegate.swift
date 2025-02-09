import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    // Add version number
    static let appVersion = "1.0.0"
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: ContentView())
        self.popover = popover
        
        if let field = popover.contentViewController?.view.window?.contentView {
            field.window?.backgroundColor = .clear
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem?.button {
            statusButton.image = NSImage(named: "MenuBarIcon")
            statusButton.action = #selector(togglePopover)
            statusButton.target = self
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                // Position the popover
                let screenFrame = NSScreen.main?.frame ?? .zero
                let buttonFrame = button.window?.convertToScreen(button.frame) ?? .zero
                
                // Calculate position (20px from the right edge and 40px from the top)
                let xPosition = buttonFrame.origin.x - (400 - buttonFrame.width)/2
                let yPosition = screenFrame.height - 40 - 600  // 40px from top
                
                let rect = NSRect(x: xPosition, y: yPosition, width: 0, height: 0)
                popover?.show(relativeTo: rect, of: button, preferredEdge: .minY)
            }
        }
    }
}
