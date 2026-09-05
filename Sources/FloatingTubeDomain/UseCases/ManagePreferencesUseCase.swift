import Foundation

public struct ManagePreferencesUseCase: Sendable {
    private let preferencesRepository: any PreferencesRepositoryProtocol
    
    public init(preferencesRepository: any PreferencesRepositoryProtocol) {
        self.preferencesRepository = preferencesRepository
    }
    
    public func loadPreferences() -> WindowPreferences {
        return preferencesRepository.loadPreferences()
    }
    
    public func savePreferences(_ preferences: WindowPreferences) {
        preferencesRepository.savePreferences(preferences)
    }
}
