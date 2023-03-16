import Foundation

/// Name for language change notification
public let languageChangeNotification = "languageChangeNotification"

public protocol LocalizationObserver {
    /// The method that is called during the language change.
    func didChangeLanguage()
}

public class LocalizationManager {
    /// Internal current language key.
    private class var LCLCurrentLanguageKey: String { "LCLCurrentLanguageKey" }

    /// Default language. English. If English is unavailable defaults to base localization.
    private class var LCLDefaultLanguage: String { "en" }
    
    /// Stores a list of subscribers who will be notified when the language changes.
    private static var localizationObservers = [LocalizationObserver]()
    
    /// A method that adds an observer and immediately calls its method for setting the language: in case the language was changed before the moment of subscription.
    public class func addObserver(_ observer: LocalizationObserver) {
        observer.didChangeLanguage()
        localizationObservers.append(observer)
    }
    
    /// Returns the default language.
    public class var defaultLanguage: String {
        var defaultLanguage = ""
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /// Returns the set language. If no language has been set, returns the default language.
    public class var currentLanguage: String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage
    }
    
    /// Returns an array of languages available for use.
    /// Example: ["en", "uk"].
    public class var availableLanguages: [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /// Returns full language names in the language currently installed.
    /// Example (English language selected): ["English", "Ukrainian"].
    public class var displayNames: [String] {
        return availableLanguages.map { displayName(forLanguage: $0) }
    }
    
    /// Returns true if the language is currently selected.
    public class func isSelected(index: Int) -> Bool {
        let language = availableLanguages[index]
        return currentLanguage == language
    }
    
    /// By index, returns the name of the language in the currently installed language.
    /// Example (English language selected): "English".
    public class func getLanguageTitle(index: Int) -> String {
        return displayNames[index]
    }
    
    /// The method sets the language by index and notifies observers about the language change.
    public class func setCurrentLanguage(index: Int) {
        let language = availableLanguages[index]
        let selectedLanguage = availableLanguages.contains(language) ? language : defaultLanguage
        if (selectedLanguage != currentLanguage){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            notifyObservers()
        }
    }
}

// MARK: - Private methods
private extension LocalizationManager {
    class func displayName(forLanguage language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    
    class func notifyObservers() {
        localizationObservers.forEach { $0.didChangeLanguage() }
    }
}
