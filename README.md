# Localization

This small library allows you to work with localization in your application.

## How to use it

To use its functionality, three simple steps are required:

### **1. Add Localizable.string file and required languages.**

### **2. Create a key structure for localization using a new property on the localized string.**

*Example:*
  
```swift
import Localization

struct Localization {
  struct MainViewController {
    static var title: String { "title".localized }
    static var button: String { "button".localized }
  }
}
```

### **3. Subscribe the required classes:**

*Example:*

```swift
import Localization

class MainViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var button: UIButton!

  override func viewDidLoad() {
      super.viewDidLoad()
      
      LocalizationManager.addObserver(self) 
  }
}

extension MainViewController: LocalizationObserver {
    func didChangeLanguage() {
        titleLabel.text = Localization.MainViewController.title
        button.setTitle(Localization.MainViewController.button, for: .normal)
    }
}
```

Now you have subscribed the controller to the language change event and connected the localization.

____
## Using this library also provides the following features:
- Call method `LocalizationManager.setCurrentLanguage(index: Int)` to select required language by the index of element in available languages array.
- To get an array of available languages, refer to the property `LocalizationManager.availableLanguages`. 

    *Return example:* ["en", "uk"].
- To get the language that is currently set, refer to the property `LocalizationManager.currentLanguage`. 

    *Return example:* "en".
- `LocalizationManager.defaultLanguage` returns the default language.
- To getfull language names in the language currently installed use `LocalizationManager.displayNames`. 

    *Return example (English language selected):* ["English", "Ukrainian"].
- To find out if a specific language is installed, use the method `LocalizationManager.isSelected(index: Int)`.
- `LocalizationManager.getLanguageTitle(index: Int)` - by index, returns the name of the language in the currently installed language.

    *Return example (English language selected):* "English".
