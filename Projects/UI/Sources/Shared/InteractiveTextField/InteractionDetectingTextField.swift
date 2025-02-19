import UIKit

/// A UITextField subclass that notifies via callbacks when the user presses delete or paste.
class InteractionDetectingTextField: UITextField {
    var onDeleteBackward: (() -> Void)?
    var onPaste: ((String) -> Void)?

    override func deleteBackward() {
        super.deleteBackward()
        onDeleteBackward?()
    }

    override func paste(_ sender: Any?) {
        super.paste(sender)
        if let pastedText = UIPasteboard.general.string {
            onPaste?(pastedText)
        }
    }
}
