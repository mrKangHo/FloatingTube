import AppKit
import SwiftUI
import Combine

@MainActor
public class WindowManager: NSObject, ObservableObject, NSWindowDelegate {
    public static let shared = WindowManager()
    
    public weak var activeWindow: NSWindow? {
        didSet {
            objectWillChange.send()
        }
    }
    @Published public var currentSize: CGSize = CGSize(width: 640, height: 360)
    
    public override init() {
        super.init()
    }
    
    public func register(window: NSWindow) {
        self.activeWindow = window
        window.delegate = self
        
        // Configure standard floating behavior
        window.styleMask.insert([.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView])
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.titlebarSeparatorStyle = .none
        window.toolbar = nil
        window.isMovableByWindowBackground = true
        window.isOpaque = false
        window.backgroundColor = .black
        window.hasShadow = true
        
        // Hide native system traffic light buttons (custom HUD buttons are used)
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Minimum and default sizes (16:9 ratio)
        window.minSize = NSSize(width: 280, height: 157.5)
        
        // Default floating on top
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // Default 16:9 aspect ratio lock
        window.contentAspectRatio = NSSize(width: 16, height: 9)
        
        self.currentSize = window.frame.size
    }
    
    public func setAlwaysOnTop(_ enabled: Bool) {
        guard let window = activeWindow else { return }
        window.level = enabled ? .floating : .normal
        if enabled {
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        } else {
            window.collectionBehavior = []
        }
    }
    
    public func setAspectRatioLocked(_ locked: Bool) {
        guard let window = activeWindow else { return }
        window.contentAspectRatio = locked ? NSSize(width: 16, height: 9) : NSSize.zero
    }
    
    public func setOpacity(_ opacity: Double) {
        guard let window = activeWindow else { return }
        let clamped = max(0.15, min(1.0, opacity))
        window.alphaValue = CGFloat(clamped)
    }
    
    public func setClickThrough(_ enabled: Bool) {
        guard let window = activeWindow else { return }
        window.ignoresMouseEvents = enabled
    }
    
    public func setSizePreset(width: CGFloat, height: CGFloat) {
        guard let window = activeWindow else { return }
        var currentFrame = window.frame
        let originX = currentFrame.origin.x
        // Keep top edge aligned when changing height
        let topY = currentFrame.origin.y + currentFrame.height
        let newOriginY = topY - height
        
        currentFrame = NSRect(x: originX, y: newOriginY, width: width, height: height)
        window.setFrame(currentFrame, display: true, animate: true)
        self.currentSize = currentFrame.size
    }
    
    private var preFullscreenFrame: NSRect?
    @Published public var isFillScreen: Bool = false
    
    public func toggleFillScreen() {
        guard let window = activeWindow else { return }
        guard let screen = window.screen ?? NSScreen.main else { return }
        
        if isFillScreen {
            // Restore to previous small frame
            if let prev = preFullscreenFrame {
                window.setFrame(prev, display: true, animate: true)
            } else {
                setSizePreset(width: 640, height: 360)
            }
            isFillScreen = false
            preFullscreenFrame = nil
        } else {
            // Save current frame and expand to fill screen without space switch
            preFullscreenFrame = window.frame
            let visibleFrame = screen.visibleFrame
            window.setFrame(visibleFrame, display: true, animate: true)
            isFillScreen = true
        }
        self.currentSize = window.frame.size
    }
    
    public func exitFillScreenIfNeeded() {
        if isFillScreen {
            toggleFillScreen()
        }
    }
    
    public func centerWindow() {
        guard let window = activeWindow else { return }
        window.center()
    }
    
    public func closeWindow() {
        activeWindow?.close()
    }
    
    public func minimizeWindow() {
        activeWindow?.miniaturize(nil)
    }
    
    public func toggleZoom() {
        toggleFillScreen()
    }
    
    // NSWindowDelegate
    public func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            self.currentSize = window.frame.size
        }
    }
}

// SwiftUI helper to attach the NSWindow to WindowManager
public struct WindowAccessor: NSViewRepresentable {
    @ObservedObject var windowManager = WindowManager.shared
    
    public init() {}
    
    public func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                windowManager.register(window: window)
            }
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {
        if let window = nsView.window, windowManager.activeWindow == nil {
            windowManager.register(window: window)
        }
    }
}
