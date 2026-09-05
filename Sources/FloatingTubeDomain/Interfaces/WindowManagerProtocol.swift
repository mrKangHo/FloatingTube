import Foundation
import CoreGraphics

@MainActor
public protocol WindowManagerProtocol: AnyObject {
    var currentSize: CGSize { get }
    var isFillScreen: Bool { get }
    
    func setAlwaysOnTop(_ enabled: Bool)
    func setAspectRatioLocked(_ locked: Bool)
    func setOpacity(_ opacity: Double)
    func setClickThrough(_ enabled: Bool)
    func setSizePreset(width: CGFloat, height: CGFloat)
    func toggleFillScreen()
    func exitFillScreenIfNeeded()
    func centerWindow()
    func closeWindow()
    func minimizeWindow()
    func toggleZoom()
}
