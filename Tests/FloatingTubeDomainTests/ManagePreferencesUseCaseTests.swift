import Testing
import Foundation
import FloatingTubeDomain

final class MockPreferencesRepository: PreferencesRepositoryProtocol, @unchecked Sendable {
    var storedPreferences: WindowPreferences
    
    init(initial: WindowPreferences = WindowPreferences()) {
        self.storedPreferences = initial
    }
    
    func loadPreferences() -> WindowPreferences {
        return storedPreferences
    }
    
    func savePreferences(_ preferences: WindowPreferences) {
        self.storedPreferences = preferences
    }
}

@Suite("ManagePreferencesUseCase Tests")
struct ManagePreferencesUseCaseTests {
    @Test("Loads default preferences when repository has defaults")
    func testLoadPreferences() {
        let repo = MockPreferencesRepository()
        let useCase = ManagePreferencesUseCase(preferencesRepository: repo)
        
        let loaded = useCase.loadPreferences()
        #expect(loaded.isAlwaysOnTop == true)
        #expect(loaded.isAspectRatioLocked == true)
        #expect(loaded.opacity == 1.0)
        #expect(loaded.isCleanMode == true)
    }
    
    @Test("Saves and reloads updated preferences")
    func testSavePreferences() {
        let repo = MockPreferencesRepository()
        let useCase = ManagePreferencesUseCase(preferencesRepository: repo)
        
        let custom = WindowPreferences(
            isAlwaysOnTop: false,
            isAspectRatioLocked: false,
            opacity: 0.65,
            isCleanMode: false
        )
        useCase.savePreferences(custom)
        
        let reloaded = useCase.loadPreferences()
        #expect(reloaded.isAlwaysOnTop == false)
        #expect(reloaded.isAspectRatioLocked == false)
        #expect(reloaded.opacity == 0.65)
        #expect(reloaded.isCleanMode == false)
        #expect(repo.storedPreferences == custom)
    }
}
