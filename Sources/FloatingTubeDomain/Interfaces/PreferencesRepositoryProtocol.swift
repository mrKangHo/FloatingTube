import Foundation

public protocol PreferencesRepositoryProtocol: AnyObject, Sendable {
    func loadPreferences() -> WindowPreferences
    func savePreferences(_ preferences: WindowPreferences)
}
