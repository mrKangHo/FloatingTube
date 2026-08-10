import SwiftUI
import AppKit

public struct MainContainerView: View {
    @ObservedObject private var appState = AppState.shared
    @State private var hoverTimer: DispatchWorkItem?
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Window Accessor hook to attach NSWindow
            WindowAccessor()
                .frame(width: 0, height: 0)
            
            // 1. YouTube Player View (Full content)
            YouTubePlayerView(appState: appState)
                .edgesIgnoringSafeArea(.all)
            
            // 2. HUD Overlays (Header & Bottom Bar)
            VStack(spacing: 0) {
                if !appState.isClickThrough && (appState.isHovered || appState.isControlsPinned) {
                    HeaderControlBar(appState: appState)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .move(edge: .top))
                        ))
                }
                
                Spacer()
                
                if !appState.isClickThrough && (appState.isHovered || appState.isControlsPinned) {
                    BottomControlBar(appState: appState)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.combined(with: .move(edge: .bottom))
                        ))
                }
            }
            .ignoresSafeArea(.all)
            .animation(.easeInOut(duration: 0.22), value: !appState.isClickThrough && (appState.isHovered || appState.isControlsPinned))
            
            // 3. Status Toast Banner
            if let status = appState.statusMessage {
                VStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Text(status)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.85))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 3)
                    .padding(.bottom, (!appState.isClickThrough && (appState.isHovered || appState.isControlsPinned)) ? 42 : 16)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: appState.statusMessage)
            }
            
            // 4. Modal Sheet Backdrop & Dialogs
            if appState.showHistorySheet || appState.showShortcutsSheet {
                Color.black.opacity(0.45)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            appState.showHistorySheet = false
                            appState.showShortcutsSheet = false
                        }
                    }
                
                if appState.showHistorySheet {
                    HistorySheetView(appState: appState)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                } else if appState.showShortcutsSheet {
                    ShortcutsSheetView(appState: appState)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
        }
        .frame(minWidth: 280, minHeight: 157.5)
        .background(Color.black)
        .onContinuousHover { phase in
            guard !appState.isClickThrough else {
                appState.isHovered = false
                return
            }
            switch phase {
            case .active(_):
                appState.isHovered = true
                resetHoverTimer()
            case .ended:
                appState.isHovered = false
            }
        }
        .onAppear {
            setupGlobalKeyShortcuts()
        }
    }
    
    private func resetHoverTimer() {
        hoverTimer?.cancel()
        let work = DispatchWorkItem { [weak appState] in
            // Auto hide controls after 3 seconds of inactivity if not pinned
            if let appState = appState, !appState.isControlsPinned {
                withAnimation {
                    appState.isHovered = false
                }
            }
        }
        hoverTimer = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: work)
    }
    
    private func setupGlobalKeyShortcuts() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            
            // Cmd + Shift + C: Toggle Click-through
            if flags == [.command, .shift] && event.charactersIgnoringModifiers?.lowercased() == "c" {
                appState.toggleClickThrough()
                return nil
            }
            
            // Cmd + T: Toggle Always-on-top
            if flags == [.command] && event.charactersIgnoringModifiers?.lowercased() == "t" {
                appState.toggleAlwaysOnTop()
                return nil
            }
            
            // Cmd + R: Reload
            if flags == [.command] && event.charactersIgnoringModifiers?.lowercased() == "r" {
                appState.reloadVideo()
                return nil
            }
            
            // Cmd + 1: Small (360x202)
            if flags == [.command] && event.charactersIgnoringModifiers == "1" {
                appState.setPresetSize(width: 360, height: 202.5, label: "소형")
                return nil
            }
            // Cmd + 2: Medium (512x288)
            if flags == [.command] && event.charactersIgnoringModifiers == "2" {
                appState.setPresetSize(width: 512, height: 288, label: "중형")
                return nil
            }
            // Cmd + 3: Large (720x405)
            if flags == [.command] && event.charactersIgnoringModifiers == "3" {
                appState.setPresetSize(width: 720, height: 405, label: "대형")
                return nil
            }
            // Cmd + 4: Extra Large (960x540)
            if flags == [.command] && event.charactersIgnoringModifiers == "4" {
                appState.setPresetSize(width: 960, height: 540, label: "특대형")
                return nil
            }
            
            // Space: Play / Pause (when not focusing textfield)
            if flags.isEmpty && event.keyCode == 49 { // Spacebar
                let firstResponder = NSApp.keyWindow?.firstResponder
                if !(firstResponder is NSTextView) && !(firstResponder is NSTextField) {
                    appState.togglePlayPause()
                    return nil
                }
            }
            
            // 'M': Mute / Unmute
            if flags.isEmpty && event.charactersIgnoringModifiers?.lowercased() == "m" {
                let firstResponder = NSApp.keyWindow?.firstResponder
                if !(firstResponder is NSTextView) && !(firstResponder is NSTextField) {
                    appState.toggleMute()
                    return nil
                }
            }
            
            // 'F': Toggle In-App Fullscreen within current window size
            if flags.isEmpty && event.charactersIgnoringModifiers?.lowercased() == "f" {
                let firstResponder = NSApp.keyWindow?.firstResponder
                if !(firstResponder is NSTextView) && !(firstResponder is NSTextField) {
                    appState.webViewCommandPublisher.send("player.toggleFullscreen();")
                    return nil
                }
            }
            
            return event
        }
    }
}
