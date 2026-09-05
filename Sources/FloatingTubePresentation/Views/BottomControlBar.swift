import SwiftUI
import AppKit
import FloatingTubeDomain

public struct BottomControlBar: View {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Drag handle with subtle grip styling
            HStack(spacing: 3) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
                WindowDragHandle()
                    .frame(width: 8, height: 22)
            }
            
            // Video Title & Live Status
            HStack(spacing: 6) {
                Image(systemName: appState.isPlaying ? "play.circle.fill" : "pause.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(appState.isPlaying ? Color.red : Color.gray)
                
                Text(appState.videoTitle.isEmpty ? L10n.appTitleDefault : appState.videoTitle)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer(minLength: 8)
            
            // Player HUD Controls
            HStack(spacing: 5) {
                // Play / Pause
                TubeIconButton(
                    icon: appState.isPlaying ? "pause.fill" : "play.fill",
                    isActive: appState.isPlaying,
                    activeColor: .red
                ) {
                    appState.togglePlayPause()
                }
                .help(appState.isPlaying ? "\(L10n.pause) (Space)" : "\(L10n.play) (Space)")
                
                // Mute / Unmute
                TubeIconButton(
                    icon: appState.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill",
                    isActive: appState.isMuted,
                    activeColor: .orange
                ) {
                    appState.toggleMute()
                }
                .help("\(L10n.mute) (M)")
                
                // Reload
                TubeIconButton(
                    icon: "arrow.clockwise",
                    isActive: false,
                    activeColor: .white
                ) {
                    appState.reloadVideo()
                }
                .help("\(L10n.reloadVideo) (⌘R)")
                
                // Pin HUD Controls Toggle
                TubeIconButton(
                    icon: appState.isControlsPinned ? "lock.fill" : "lock.open",
                    isActive: appState.isControlsPinned,
                    activeColor: .indigo
                ) {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        appState.isControlsPinned.toggle()
                    }
                }
                .help(appState.isControlsPinned ? "컨트롤 고정됨 (Hover 없어도 유지)" : "컨트롤 자동 숨김 모드")
                
                // In-App Fullscreen Toggle
                TubeIconButton(
                    icon: "viewfinder",
                    isActive: false,
                    activeColor: .white
                ) {
                    appState.webViewCommandPublisher.send("player.toggleFullscreen();")
                }
                .help("\(L10n.toggleFullscreen) (F)")
                
                // Open in External Browser
                if let target = appState.currentTarget {
                    TubeIconButton(
                        icon: "arrow.up.right.square",
                        isActive: false,
                        activeColor: .white
                    ) {
                        if let url = URL(string: target.watchURLString) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .help(L10n.openInBrowserTooltip)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            ZStack {
                VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                Color.black.opacity(0.4)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.9
                )
        )
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: -2)
        .padding(.horizontal, 8)
        .padding(.bottom, 6)
    }
}
