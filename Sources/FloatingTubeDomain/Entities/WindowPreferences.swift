import Foundation

public struct WindowPreferences: Equatable, Codable, Sendable {
    public var isAlwaysOnTop: Bool
    public var isAspectRatioLocked: Bool
    public var opacity: Double
    public var isCleanMode: Bool
    
    public init(
        isAlwaysOnTop: Bool = true,
        isAspectRatioLocked: Bool = true,
        opacity: Double = 1.0,
        isCleanMode: Bool = true
    ) {
        self.isAlwaysOnTop = isAlwaysOnTop
        self.isAspectRatioLocked = isAspectRatioLocked
        self.opacity = opacity
        self.isCleanMode = isCleanMode
    }
}
