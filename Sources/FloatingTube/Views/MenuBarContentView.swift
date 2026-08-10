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
                Text(appState.videoTitle.isEmpty ? "FloatingTube 플레이어" : appState.videoTitle)
                    .lineLimit(1)
            }
        }
        
        Divider()
        
        // 2. Playback & Paste
        Button("클립보드 링크 재생") {
            appState.pasteAndPlayFromClipboard()
            bringAppToFront()
        }
        .keyboardShortcut("v", modifiers: [.command])
        
        Button(appState.isPlaying ? "일시정지" : "재생") {
            appState.togglePlayPause()
        }
        
        Button(appState.isMuted ? "음소거 해제" : "음소거") {
            appState.toggleMute()
        }
        
        Button("영상 새로고침") {
            appState.reloadVideo()
        }
        .keyboardShortcut("r", modifiers: [.command])
        
        Divider()
        
        // 3. View Mode & Window Floating
        Button(action: {
            appState.toggleAlwaysOnTop()
        }) {
            HStack {
                Text("항상 화면 위에 고정")
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
                Text("클린 뷰 (영상 100% 꽉 찬 화면)")
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
                Text("유튜브 웹 뷰 (댓글/사이드바)")
                if !appState.isCleanMode {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button("창 맞춤 전체화면 토글") {
            appState.webViewCommandPublisher.send("player.toggleFullscreen();")
        }
        
        Divider()
        
        // 4. Opacity & Window Features
        Menu("창 투명도") {
            Button("100% (불투명)") {
                appState.opacity = 1.0
            }
            Button("80% (약간 투명)") {
                appState.opacity = 0.8
            }
            Button("50% (반투명)") {
                appState.opacity = 0.5
            }
            Button("30% (투명)") {
                appState.opacity = 0.3
            }
        }
        
        Button(action: {
            appState.toggleAspectRatioLock()
        }) {
            HStack {
                Text("16:9 화면비율 잠금")
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
                Text("마우스 관통 모드")
                if appState.isClickThrough {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .keyboardShortcut("c", modifiers: [.command, .shift])
        
        Divider()
        
        // 5. Account & History
        Button("구글 / 유튜브 계정 로그인") {
            appState.openLogin()
            bringAppToFront()
        }
        
        Button(action: {
            appState.toggleBookmark()
        }) {
            HStack {
                Text("현재 영상 즐겨찾기 추가")
                if appState.isCurrentTargetBookmarked() {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        
        Button("최근 재생 및 즐겨찾기 목록...") {
            appState.showHistorySheet.toggle()
            bringAppToFront()
        }
        
        Button("단축키 안내...") {
            appState.showShortcutsSheet.toggle()
            bringAppToFront()
        }
        
        Divider()
        
        // 6. Quit
        Button("FloatingTube 종료") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: [.command])
    }
    
    private func bringAppToFront() {
        NSApp.activate(ignoringOtherApps: true)
        windowManager.activeWindow?.makeKeyAndOrderFront(nil)
    }
}
