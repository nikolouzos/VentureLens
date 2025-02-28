import AppResources
import Core
import SwiftUI

public struct PinEntryView: View {
    @FocusState private var focusedField: Int?
    @State private var pin: [Int?]
    @Binding private var isDisabled: Bool
    @State private var hasEmittedPin = false

    private let maxDigits: Int
    private let shouldShowPaste: Bool
    private let onPinFilled: (_ pin: String) -> Void

    public init(
        maxDigits: Int = 6,
        shouldShowPaste: Bool = false,
        isDisabled: Binding<Bool> = .constant(false),
        onPinFilled: @escaping (_ pin: String) -> Void = { _ in }
    ) {
        _isDisabled = isDisabled
        _pin = State(initialValue: .init(
            repeating: nil,
            count: maxDigits
        ))
        self.maxDigits = maxDigits
        self.shouldShowPaste = shouldShowPaste
        self.onPinFilled = onPinFilled
    }

    public var body: some View {
        HStack(spacingSize: .md) {
            ForEach(0 ..< maxDigits, id: \.self) { index in
                PinDigitField(
                    pin: $pin,
                    focusedField: $focusedField,
                    index: index,
                    isDisabled: isDisabled,
                    maxDigits: maxDigits,
                    onPaste: handlePaste
                )
            }
        }
        .onChange(of: pin) { _, newPin in
            Task { @MainActor in
                let stringPin = newPin.compactMap { $0 }.map(String.init).joined()
                guard stringPin.count == maxDigits, !hasEmittedPin else { return }
                hasEmittedPin = true
                onPinFilled(stringPin)
            }
        }
        .onChange(of: isDisabled) { oldValue, newValue in
            if !newValue && oldValue != newValue {
                pin = .init(repeating: nil, count: maxDigits)
                hasEmittedPin = false
            }
        }
    }

    @MainActor
    private func handlePaste(_ text: String, fromIndex: Int) {
        let digits = text.filter(\.isNumber)
        guard !digits.isEmpty else { return }

        // Create a new array with existing pins
        var newPin = pin

        // Clear pins from paste index onwards
        for i in fromIndex ..< maxDigits {
            newPin[i] = nil
        }

        // Fill in the pasted digits starting from the paste index
        for (offset, char) in digits.prefix(maxDigits - fromIndex).enumerated() {
            if let digit = Int(String(char)) {
                newPin[fromIndex + offset] = digit
            }
        }

        // Update the pin array atomically
        pin = newPin

        // Focus the next empty field or the last field
        if let nextEmpty = pin.firstIndex(where: { $0 == nil }) {
            focusedField = nextEmpty
        } else {
            focusedField = maxDigits - 1
        }
    }
}

private struct PinDigitField: View {
    @Binding var pin: [Int?]
    var focusedField: FocusState<Int?>.Binding

    let index: Int
    let isDisabled: Bool
    let maxDigits: Int
    let onPaste: (String, Int) -> Void

    private var digitBinding: Binding<String> {
        Binding(
            get: {
                guard let digit = pin[index] else { return "" }
                return String(digit)
            },
            set: { newValue in
                let cleanDigit = newValue.filter(\.isNumber)

                // Handle empty input
                if cleanDigit.isEmpty {
                    if pin[index] != nil {
                        handleDelete()
                    }
                    return
                }

                // Always delegate paste operations to parent to ensure atomic updates
                if cleanDigit.count > 1 {
                    onPaste(cleanDigit, index)
                    return
                }

                // Single digit input - only update if empty
                Task { @MainActor in
                    guard pin[index] == nil else { return }
                    if let digit = Int(cleanDigit.prefix(1)) {
                        pin[index] = digit
                        if index < maxDigits - 1 {
                            focusedField.wrappedValue = index + 1
                        }
                    }
                }
            }
        )
    }

    var body: some View {
        InteractiveTextField(
            text: digitBinding,
            keyboardType: .numberPad,
            textContentType: .oneTimeCode,
            isEnabled: !isDisabled
        )
        .font(.title2, weight: .bold)
        .textAlignment(.center)
        // Remove onPaste modifier since we handle it in digitBinding
        .onDelete { handleDelete() }
        .frame(width: 48, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    focusedField.wrappedValue == index ? Color.tint : Color.gray,
                    lineWidth: 1
                )
                .fill(
                    isDisabled
                        ? Color.gray.opacity(0.1)
                        : Color.clear
                )
                .contentShape(Rectangle())
        )
        .focused(focusedField, equals: index)
        .disabled(isDisabled)
    }

    @MainActor
    @discardableResult
    private func handleDelete() -> KeyPress.Result {
        guard pin.contains(where: { $0 != nil }) else { return .handled }

        if pin[index] == nil && index > 0 {
            pin[index - 1] = nil
            focusedField.wrappedValue = index - 1
        } else {
            pin[index] = nil
        }
        return .handled
    }
}

#Preview {
    @Previewable @State var isDisabled = false

    PinEntryView(isDisabled: $isDisabled) { pin in
        print("Got pin: \(pin)")
    }
}
