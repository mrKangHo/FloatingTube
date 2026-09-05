import SwiftUI
import AppKit

public struct MainContainerView: View {
    @ObservedObject private var appState: AppState
    @State private var hoverTimer: DispatchWorkItem?
    
    public init(appState: AppState = AppState.shared) {
        self.appState = appState
    }
    
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
            .animation(.spring(response: 0.28, dampingFraction: 0.82), value: !appState.isClickThrough && (appState.isHovered || appState.isControlsPinned))
            
            // 3. Click-Through Overlay Warning Pill
            if appState.isClickThrough {
                VStack {
                    HStack(spacing: 6) {
                        Image(systemName: "cursorarrow.rays")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.orange)
                        Text("마우스 관통 중 (해제: ⌘⇧C)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        ZStack {
                            VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                            Color.black.opacity(0.7)
                        }
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.orange.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 3)
                    .padding(.top, 12)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(response: 0.3, dampingFraction: 0.75), value: appState.isClickThrough)
            }
            
            // 4. Status Toast Banner (Apple Glass Pill Toast)
            if let status = appState.statusMessage {
                VStack {
                    Spacer()
                    HStack(spacing: 7) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                        Text(status)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        ZStack {
                            VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                            Color.black.opacity(0.75)
                        }
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 4)
                    .padding(.bottom, (!appState.isClickThrough && (appState.isHovered || appState.isControlsPinned)) ? 50 : 18)
                    .transition(.scale(scale: 0.92).combined(with: .opacity))
                }
                .animation(.spring(response: 0.28, dampingFraction: 0.78), value: appState.statusMessage)
            }
            
            // 5. Modal Sheet Backdrop & Dialogs
            if appState.showHistorySheet || appState.showShortcutsSheet {
                Color.black.opacity(0.55)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            appState.showHistorySheet = false
                            appState.showShortcutsSheet = false
                        }
                    }
                
                if appState.showHistorySheet {
                    HistorySheetView(appState: appState)
                        .transition(.scale(scale: 0.94).combined(with: .opacity))
                } else if appState.showShortcutsSheet {
                    ShortcutsSheetView(appState: appState)
                        .transition(.scale(scale: 0.94).combined(with: .opacity))
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
