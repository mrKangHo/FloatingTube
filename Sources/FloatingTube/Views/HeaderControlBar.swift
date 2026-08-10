import SwiftUI
import AppKit

public struct HeaderControlBar: View {
    @ObservedObject var appState: AppState
    @ObservedObject var windowManager = WindowManager.shared
    @FocusState private var isSearchFocused: Bool
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Window Traffic Lights
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.red.opacity(0.85))
                    .frame(width: 11, height: 11)
                    .onTapGesture {
                        windowManager.closeWindow()
                    }
                Circle()
                    .fill(Color.yellow.opacity(0.85))
                    .frame(width: 11, height: 11)
                    .onTapGesture {
                        windowManager.minimizeWindow()
                    }
                Circle()
                    .fill(Color.green.opacity(0.85))
                    .frame(width: 11, height: 11)
                    .onTapGesture {
                        windowManager.toggleZoom()
                    }
            }
            .padding(.leading, 2)
            
            // Drag handle spacer
            WindowDragHandle()
                .frame(width: 10, height: 22)
            
            // URL / Search Input Field
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.5))
                
                TextField("유튜브 링크 또는 ID 입력...", text: $appState.inputUrl)
                    .textFieldStyle(.plain)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white)
                    .focused($isSearchFocused)
                    .onSubmit {
                        appState.load(input: appState.inputUrl)
                    }
                
                if !appState.inputUrl.isEmpty {
                    Button(action: { appState.inputUrl = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
                
                // Quick Paste button
                Button(action: {
                    appState.pasteAndPlayFromClipboard()
                }) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
                .help("클립보드 링크 붙여넣기 및 재생 (⌘V)")
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.45))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSearchFocused ? Color.blue.opacity(0.6) : Color.white.opacity(0.12), lineWidth: 1)
            )
            
            // Essential Action Buttons (Clean & Minimal)
            HStack(spacing: 5) {
                // 1. Always on Top Toggle
                TubeIconButton(
                    icon: appState.isAlwaysOnTop ? "pin.fill" : "pin",
                    isActive: appState.isAlwaysOnTop,
                    activeColor: .orange
                ) {
                    appState.toggleAlwaysOnTop()
                }
                .help("항상 화면 위에 고정 (⌘T)")
                
                // 2. View Mode Toggle (Clean Video ↔ Full Web)
                TubeIconButton(
                    icon: appState.isCleanMode ? "play.rectangle.fill" : "globe",
                    isActive: appState.isCleanMode,
                    activeColor: .green
                ) {
                    appState.toggleCleanMode()
                }
                .help(appState.isCleanMode ? "현재: 클린 플레이어 뷰 (클릭 시 웹 뷰로 전환)" : "현재: 웹 뷰 (클릭 시 클린 뷰로 전환)")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                .overlay(Color.black.opacity(0.35))
        )
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 0.8),
            alignment: .bottom
        )
    }
}
