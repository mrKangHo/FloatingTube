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
                Button("클립보드 링크 재생") {
                    AppState.shared.pasteAndPlayFromClipboard()
                }
                .keyboardShortcut("v", modifiers: [.command])
                
                Button("항상 위에 고정 토글") {
                    AppState.shared.toggleAlwaysOnTop()
                }
                .keyboardShortcut("t", modifiers: [.command])
                
                Button("새로고침") {
                    AppState.shared.reloadVideo()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
            
            CommandMenu("보기") {
                Button("클린 뷰 (영상 100% 꽉 찬 화면)") {
                    AppState.shared.isCleanMode = true
                    AppState.shared.toggleCleanMode()
                }
                
                Button("유튜브 웹 뷰 (댓글/사이드바)") {
                    AppState.shared.isCleanMode = false
                    AppState.shared.toggleCleanMode()
                }
                
                Button("창 맞춤 전체화면 토글") {
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
