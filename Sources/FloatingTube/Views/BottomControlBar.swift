import SwiftUI
import AppKit

public struct BottomControlBar: View {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Drag handle
            WindowDragHandle()
                .frame(width: 8, height: 20)
            
            // Video Title
            HStack(spacing: 6) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.red)
                
                Text(appState.videoTitle.isEmpty ? "FloatingTube - YouTube Player" : appState.videoTitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            // Player HUD Controls
            HStack(spacing: 6) {
                // Play / Pause
                TubeIconButton(
                    icon: appState.isPlaying ? "pause.fill" : "play.fill",
                    isActive: false,
                    activeColor: .white
                ) {
                    appState.togglePlayPause()
                }
                .help(appState.isPlaying ? "\(L10n.pause) (Space)" : "\(L10n.play) (Space)")
                
                // Mute / Unmute
                TubeIconButton(
                    icon: appState.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill",
                    isActive: appState.isMuted,
                    activeColor: .red
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
                
                // Pin HUD Controls
                TubeIconButton(
                    icon: appState.isControlsPinned ? "lock.fill" : "lock.open",
                    isActive: appState.isControlsPinned,
                    activeColor: .indigo
                ) {
                    appState.isControlsPinned.toggle()
                }
                
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
            VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                .overlay(Color.black.opacity(0.4))
        )
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 0.8),
            alignment: .top
        )
    }
}
