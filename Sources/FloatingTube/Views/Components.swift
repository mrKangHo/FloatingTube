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

// MARK: - Modern Icon Button
public struct TubeIconButton: View {
    let icon: String
    let title: String?
    let isActive: Bool
    let activeColor: Color
    let action: () -> Void
    
    @State private var isHovered = false
    
    public init(
        icon: String,
        title: String? = nil,
        isActive: Bool = false,
        activeColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.isActive = isActive
        self.activeColor = activeColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                if let title = title {
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                }
            }
            .foregroundColor(isActive ? activeColor : (isHovered ? .white : .white.opacity(0.8)))
            .padding(.horizontal, title != nil ? 8 : 6)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isActive ? activeColor.opacity(0.25) : (isHovered ? Color.white.opacity(0.15) : Color.black.opacity(0.2)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isActive ? activeColor.opacity(0.6) : Color.white.opacity(0.1), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
