import Foundation
import FloatingTubeDomain

public final class UserDefaultsPreferencesRepository: PreferencesRepositoryProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let alwaysOnTopKey = "FloatingTube_AlwaysOnTop"
    private let aspectRatioLockedKey = "FloatingTube_AspectRatioLocked"
    private let opacityKey = "FloatingTube_Opacity"
    private let cleanModeKey = "FloatingTube_CleanMode"
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func loadPreferences() -> WindowPreferences {
        let isAlwaysOnTop = userDefaults.object(forKey: alwaysOnTopKey) as? Bool ?? true
        let isAspectRatioLocked = userDefaults.object(forKey: aspectRatioLockedKey) as? Bool ?? true
        let opacity = userDefaults.object(forKey: opacityKey) as? Double ?? 1.0
        let isCleanMode = userDefaults.object(forKey: cleanModeKey) as? Bool ?? true
        
        return WindowPreferences(
            isAlwaysOnTop: isAlwaysOnTop,
            isAspectRatioLocked: isAspectRatioLocked,
            opacity: opacity,
            isCleanMode: isCleanMode
        )
    }
    
    public func savePreferences(_ preferences: WindowPreferences) {
        userDefaults.set(preferences.isAlwaysOnTop, forKey: alwaysOnTopKey)
        userDefaults.set(preferences.isAspectRatioLocked, forKey: aspectRatioLockedKey)
        userDefaults.set(preferences.opacity, forKey: opacityKey)
        userDefaults.set(preferences.isCleanMode, forKey: cleanModeKey)
    }
}
