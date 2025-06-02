import AppResources
import Core
import SwiftUI

struct GuestModeBenefitModalView: View {
    // MARK: - Properties

    var onContinueAsGuest: () -> Void
    var onCreateAccount: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacingSize: .lg) {
            Text("Continue as Guest?")
                .font(.plusJakartaSans(.title2, weight: .bold))
                .padding(.top, .md)
                .padding(.bottom, .xl)

            Text("Creating an account unlocks features like:")
                .font(.plusJakartaSans(.body, weight: .regular))
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacingSize: .sm) {
                BenefitRow(text: "Weekly free content unlocks")
                BenefitRow(text: "Bookmarks")
                BenefitRow(text: "Cross-device sync")
                BenefitRow(text: "Higher usage limits")
            }
            .padding(.horizontal, .md)

            VStack(spacingSize: .md) {
                Button("Continue as Guest", action: onContinueAsGuest)
                    .buttonStyle(
                        OutlineButtonStyle(fullWidth: true)
                    )

                Button("Create Account", action: onCreateAccount)
                    .buttonStyle(
                        ProminentButtonStyle(fullWidth: true)
                    )
            }
            .padding(.vertical, .md)
        }
        .padding(.all, .lg)
        .presentationDetents(
            UIDevice.current.userInterfaceIdiom == .phone
                ? [.medium]
                : [.large]
        )
    }
}

// MARK: - Subcomponents

private struct BenefitRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .center, spacingSize: .sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.themeSecondary)
                .font(.plusJakartaSans(.title3))

            Text(text)
                .font(.plusJakartaSans(.body, weight: .regular))

            Spacer()
        }
    }
}

// MARK: - Previews

#if DEBUG
    struct GuestModeBenefitModalView_Previews: PreviewProvider {
        static var previews: some View {
            GuestModeBenefitModalView(
                onContinueAsGuest: {},
                onCreateAccount: {}
            )
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
#endif
