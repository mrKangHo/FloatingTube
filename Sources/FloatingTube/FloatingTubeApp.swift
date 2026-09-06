import SwiftUI
import AppKit
import FloatingTubeDomain
import FloatingTubePresentation

@main
struct FloatingTubeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var appState: AppState
    
    init() {
        let container = AppDIContainer.shared
        self._appState = ObservedObject(wrappedValue: container.appState)
    }
    
    var body: some Scene {
        WindowGroup {
            MainContainerView(appState: appState)
                .ignoresSafeArea(.all)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(L10n.playClipboardLink) {
                    appState.pasteAndPlayFromClipboard()
                }
                .keyboardShortcut("v", modifiers: [.command])
                
                Button(L10n.alwaysOnTop) {
                    appState.toggleAlwaysOnTop()
                }
                .keyboardShortcut("t", modifiers: [.command])
                
                Button(L10n.reloadVideo) {
                    appState.reloadVideo()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
            
            CommandMenu(L10n.viewMenu) {
                Button(L10n.cleanPlayerView) {
                    appState.setCleanMode(true)
                }
                
                Button(L10n.youtubeWebView) {
                    appState.setCleanMode(false)
                }
                
                Button(L10n.toggleFullscreen) {
                    appState.webViewCommandPublisher.send("player.toggleFullscreen();")
                }
                .keyboardShortcut("f", modifiers: [])
            }
        }
        
        // macOS Status Bar (Menu Bar Extra Item)
        MenuBarExtra("FloatingTube", systemImage: "play.rectangle.fill") {
            MenuBarContentView(appState: appState)
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
