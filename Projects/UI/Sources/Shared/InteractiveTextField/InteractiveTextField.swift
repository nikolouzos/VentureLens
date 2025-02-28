import Core
import SwiftUI

struct InteractiveTextField: UIViewRepresentable {
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var font: UIFont.TextStyle = .body
    var fontWeight: UIFont.Weight = .regular
    var textAlignment: NSTextAlignment = .left
    var onDelete: (() -> Void)?
    var onPaste: ((String) -> Void)?
    var isEnabled: Bool = true

    func makeUIView(context: Context) -> InteractionDetectingTextField {
        let textField = InteractionDetectingTextField()
        textField.delegate = context.coordinator
        textField.keyboardType = keyboardType
        textField.textContentType = textContentType
        textField.font = .preferredFont(for: font, weight: fontWeight)
        textField.textAlignment = textAlignment
        textField.isEnabled = isEnabled

        // When deleteBackward is called, if the text is empty then notify.
        textField.onDeleteBackward = {
            if (textField.text ?? "").isEmpty {
                onDelete?()
            }
        }
        textField.onPaste = { pasted in
            onPaste?(pasted)
        }
        return textField
    }

    func updateUIView(_ uiView: InteractionDetectingTextField, context _: Context) {
        uiView.text = text
        uiView.isEnabled = isEnabled
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: InteractiveTextField

        init(_ parent: InteractiveTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

// MARK: - ViewModifiers

extension InteractiveTextField {
    func font(
        _ font: UIFont.TextStyle,
        weight: UIFont.Weight = .regular
    ) -> InteractiveTextField {
        InteractiveTextField(
            text: $text,
            keyboardType: keyboardType,
            textContentType: textContentType,
            font: font,
            fontWeight: weight,
            textAlignment: textAlignment,
            onDelete: onDelete,
            onPaste: onPaste,
            isEnabled: isEnabled
        )
    }

    func textAlignment(_ alignment: NSTextAlignment) -> InteractiveTextField {
        InteractiveTextField(
            text: $text,
            keyboardType: keyboardType,
            textContentType: textContentType,
            font: font,
            fontWeight: fontWeight,
            textAlignment: alignment,
            onDelete: onDelete,
            onPaste: onPaste,
            isEnabled: isEnabled
        )
    }

    func onDelete(perform action: @escaping () -> Void) -> InteractiveTextField {
        InteractiveTextField(
            text: $text,
            keyboardType: keyboardType,
            textContentType: textContentType,
            font: font,
            fontWeight: fontWeight,
            textAlignment: textAlignment,
            onDelete: action,
            onPaste: onPaste,
            isEnabled: isEnabled
        )
    }

    func onPaste(perform action: @escaping (String) -> Void) -> InteractiveTextField {
        InteractiveTextField(
            text: $text,
            keyboardType: keyboardType,
            textContentType: textContentType,
            font: font,
            fontWeight: fontWeight,
            textAlignment: textAlignment,
            onDelete: onDelete,
            onPaste: action,
            isEnabled: isEnabled
        )
    }
}
