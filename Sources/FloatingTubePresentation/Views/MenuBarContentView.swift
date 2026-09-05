import SwiftUI
import AppKit

public struct MenuBarContentView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var windowManager = WindowManager.shared
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        // 1. Current Video Header
        Button(action: {
            bringAppToFront()
        }) {
            HStack {
                Text(appState.videoTitle.isEmpty ? L10n.appTitleDefault : appState.videoTitle)
                    .lineLimit(1)
            }
        }
        
        Divider()
        
        // 2. Playback & Paste
        Button(L10n.playClipboardLink) {
            appState.pasteAndPlayFromClipboard()
            bringAppToFront()
        }
        .keyboardShortcut("v", modifiers: [.command])
        
        Button(appState.isPlaying ? L10n.pause : L10n.play) {
            appState.togglePlayPause()
        }
        
        Button(appState.isMuted ? L10n.unmute : L10n.mute) {
            appState.toggleMute()
        }
        
        Button(L10n.reloadVideo) {
            appState.reloadVideo()
        }
        .keyboardShortcut("r", modifiers: [.command])
        
        Divider()
        
        // 3. View Mode & Window Floating
        Button(action: {
            appState.toggleAlwaysOnTop()
        }) {
            HStack {
                Text(L10n.alwaysOnTop)
                if appState.isAlwaysOnTop {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .keyboardShortcut("t", modifiers: [.command])
        
        Button(action: {
            appState.isCleanMode = true
            appState.toggleCleanMode()
        }) {
            HStack {
                Text(L10n.cleanPlayerView)
                if appState.isCleanMode {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button(action: {
            appState.isCleanMode = false
            appState.toggleCleanMode()
        }) {
            HStack {
                Text(L10n.youtubeWebView)
                if !appState.isCleanMode {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button(L10n.toggleFullscreen) {
            appState.webViewCommandPublisher.send("player.toggleFullscreen();")
        }
        
        Divider()
        
        // 4. Opacity & Window Features
        Menu(L10n.opacityMenu) {
            Button(L10n.opacity100) {
                appState.opacity = 1.0
            }
            Button(L10n.opacity80) {
                appState.opacity = 0.8
            }
            Button(L10n.opacity50) {
                appState.opacity = 0.5
            }
            Button(L10n.opacity30) {
                appState.opacity = 0.3
            }
        }
        
        Button(action: {
            appState.toggleAspectRatioLock()
        }) {
            HStack {
                Text(L10n.lockAspectRatio)
                if appState.isAspectRatioLocked {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button(action: {
            appState.toggleClickThrough()
        }) {
            HStack {
                Text(L10n.clickThroughMode)
                if appState.isClickThrough {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .keyboardShortcut("c", modifiers: [.command, .shift])
        
        Divider()
        
        // 5. Account & History
        Button(L10n.googleLogin) {
            appState.openLogin()
            bringAppToFront()
        }
        
        Button(action: {
            appState.toggleBookmark()
        }) {
            HStack {
                Text(L10n.addBookmark)
                if appState.isCurrentTargetBookmarked() {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button(L10n.historySheet) {
            appState.showHistorySheet.toggle()
            bringAppToFront()
        }
        
        Button(L10n.shortcutsSheet) {
            appState.showShortcutsSheet.toggle()
            bringAppToFront()
        }
        
        Divider()
        
        // 6. Quit
        Button(L10n.quitApp) {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: [.command])
    }
    
    private func bringAppToFront() {
        NSApp.activate(ignoringOtherApps: true)
        windowManager.activeWindow?.makeKeyAndOrderFront(nil)
    }
}
