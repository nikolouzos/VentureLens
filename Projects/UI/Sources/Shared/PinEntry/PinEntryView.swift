import Core
import SwiftUI

public struct PinEntryView: View {
    @FocusState private var focusedField: Int?
    @State private var pin: [Int?]
    @Binding private var isDisabled: Bool

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
                    maxDigits: maxDigits
                )
            }
        }
        .onReceive(pin[maxDigits - 1].publisher) { _ in
            Task { @MainActor in
                let stringPin = pin.compactMap { $0 }.map(String.init).joined()
                guard stringPin.count == maxDigits else { return }
                onPinFilled(stringPin)
            }
        }
        .onChange(of: isDisabled) { oldValue, newValue in
            if !newValue && oldValue != newValue {
                pin = .init(repeating: nil, count: maxDigits)
            }
        }
    }
}

private struct PinDigitField: View {
    @Binding var pin: [Int?]
    var focusedField: FocusState<Int?>.Binding

    let index: Int
    let isDisabled: Bool
    let maxDigits: Int

    private var digitBinding: Binding<String> {
        Binding(
            get: {
                guard let digit = pin[index] else { return "" }
                return String(digit)
            },
            set: updatePin
        )
    }

    var body: some View {
        InteractiveTextField(
            text: digitBinding,
            keyboardType: .numberPad,
            textContentType: .oneTimeCode
        )
        .font(.title2, weight: .bold)
        .textAlignment(.center)
        .onPaste { handlePaste($0) }
        .onDelete { handleDelete() }
        .frame(width: 48, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
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

    private func firstAvailableField() -> Int {
        guard let emptyIndex = pin.firstIndex(where: { $0 == nil }) else {
            return maxDigits - 1
        }
        return emptyIndex
    }

    @MainActor
    @discardableResult
    private func handleDelete() -> KeyPress.Result {
        guard pin.first != nil else { return .handled }

        if digitBinding.wrappedValue.isEmpty && index != 0 {
            pin[index - 1] = nil
            focusedField.wrappedValue = index - 1
        } else {
            pin[index] = nil
        }
        return .handled
    }

    @MainActor
    private func handlePaste(_ newPin: String) {
        guard newPin.count == maxDigits, newPin.allSatisfy({ $0.isNumber }) else {
            return
        }

        pin = newPin.map { Int(String($0)) }
        focusedField.wrappedValue = maxDigits - 1
    }

    @MainActor
    private func updatePin(_ newDigit: String) {
        let cleanDigit = newDigit.filter(\.isNumber)

        guard cleanDigit.count == 1, cleanDigit != digitBinding.wrappedValue else {
            handlePaste(newDigit)
            return
        }

        pin[index] = Int(cleanDigit)
        focusedField.wrappedValue = firstAvailableField()
    }
}

#Preview {
    @Previewable @State var isDisabled = false

    PinEntryView(isDisabled: $isDisabled) { pin in
        print("Got pin: \(pin)")
    }
}
