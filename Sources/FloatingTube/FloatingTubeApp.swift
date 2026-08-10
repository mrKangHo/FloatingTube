import SwiftUI
import AppKit

@main
struct FloatingTubeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            MainContainerView()
                .ignoresSafeArea(.all)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(L10n.playClipboardLink) {
                    AppState.shared.pasteAndPlayFromClipboard()
                }
                .keyboardShortcut("v", modifiers: [.command])
                
                Button(L10n.alwaysOnTop) {
                    AppState.shared.toggleAlwaysOnTop()
                }
                .keyboardShortcut("t", modifiers: [.command])
                
                Button(L10n.reloadVideo) {
                    AppState.shared.reloadVideo()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
            
            CommandMenu(L10n.viewMenu) {
                Button(L10n.cleanPlayerView) {
                    AppState.shared.isCleanMode = true
                    AppState.shared.toggleCleanMode()
                }
                
                Button(L10n.youtubeWebView) {
                    AppState.shared.isCleanMode = false
                    AppState.shared.toggleCleanMode()
                }
                
                Button(L10n.toggleFullscreen) {
                    AppState.shared.webViewCommandPublisher.send("player.toggleFullscreen();")
                }
                .keyboardShortcut("f", modifiers: [])
            }
        }
        
        // macOS Status Bar (Menu Bar Extra Item)
        MenuBarExtra("FloatingTube", systemImage: "play.rectangle.fill") {
            MenuBarContentView(appState: AppState.shared)
        }
    }
}

public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Keep app running in menu bar even if window is closed
    }
}
