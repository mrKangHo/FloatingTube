import SwiftUI
import AppKit

// MARK: - Visual Effect (Glassmorphism)
public struct VisualEffectBlur: NSViewRepresentable {
    public var material: NSVisualEffectView.Material
    public var blendingMode: NSVisualEffectView.BlendingMode
    public var state: NSVisualEffectView.State
    
    public init(
        material: NSVisualEffectView.Material = .hudWindow,
        blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
        state: NSVisualEffectView.State = .active
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
    }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        return view
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}

// MARK: - Custom Window Drag Handle
public struct WindowDragHandle: NSViewRepresentable {
    public init() {}
    
    public func makeNSView(context: Context) -> CustomDragView {
        return CustomDragView()
    }
    
    public func updateNSView(_ nsView: CustomDragView, context: Context) {}
}

public class CustomDragView: NSView {
    public override func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }
}

// MARK: - Modern Apple HIG Icon Button
public struct TubeIconButton: View {
    let icon: String
    let title: String?
    let isActive: Bool
    let activeColor: Color
    let iconSize: CGFloat
    let action: () -> Void
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    public init(
        icon: String,
        title: String? = nil,
        isActive: Bool = false,
        activeColor: Color = .blue,
        iconSize: CGFloat = 11,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.isActive = isActive
        self.activeColor = activeColor
        self.iconSize = iconSize
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(isActive ? activeColor : (isHovered ? .white : .white.opacity(0.85)))
                
                if let title = title {
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isActive ? activeColor : (isHovered ? .white : .white.opacity(0.9)))
                }
            }
            .padding(.horizontal, title != nil ? 9 : 7)
            .padding(.vertical, 5)
            .background(
                ZStack {
                    if isActive {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(activeColor.opacity(0.25))
                    } else if isHovered {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(Color.white.opacity(0.18))
                    } else {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(Color.black.opacity(0.25))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(
                        isActive
                            ? activeColor.opacity(0.65)
                            : (isHovered ? Color.white.opacity(0.3) : Color.white.opacity(0.12)),
                        lineWidth: 0.8
                    )
            )
            .scaleEffect(isPressed ? 0.94 : (isHovered ? 1.04 : 1.0))
            .shadow(color: isActive ? activeColor.opacity(0.3) : .clear, radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Apple HIG KeyCap Badge Component
public struct KeyCapView: View {
    let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public var body: some View {
        Text(key)
            .font(.system(size: 10, weight: .semibold, design: .monospaced))
            .foregroundColor(.white.opacity(0.95))
            .padding(.horizontal, 6)
            .padding(.vertical, 2.5)
            .background(
                RoundedRectangle(cornerRadius: 4.5, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.22), Color.white.opacity(0.12)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4.5, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.6)
            )
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}

// MARK: - macOS Window Traffic Light Controls with Hover Overlay
public struct MacOSTrafficLights: View {
    @ObservedObject var windowManager = WindowManager.shared
    @State private var isHovered = false
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 7) {
            // Close Button (Red)
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.36, blue: 0.34))
                    .frame(width: 12, height: 12)
                
                if isHovered {
                    Image(systemName: "xmark")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(Color.black.opacity(0.7))
                }
            }
            .onTapGesture {
                windowManager.closeWindow()
            }
            
            // Minimize Button (Yellow)
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.75, blue: 0.22))
                    .frame(width: 12, height: 12)
                
                if isHovered {
                    Image(systemName: "minus")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(Color.black.opacity(0.7))
                }
            }
            .onTapGesture {
                windowManager.minimizeWindow()
            }
            
            // Zoom Button (Green)
            ZStack {
                Circle()
                    .fill(Color(red: 0.16, green: 0.8, blue: 0.27))
                    .frame(width: 12, height: 12)
                
                if isHovered {
                    Image(systemName: "plus")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(Color.black.opacity(0.7))
                }
            }
            .onTapGesture {
                windowManager.toggleZoom()
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
}
