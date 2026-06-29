import SwiftUI

struct SpotlyTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .sentences
    var hasError: Bool = false

    @State private var isRevealed = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(SpotlyFont.caption(.semibold))
                .foregroundStyle(SpotlyColors.textSecondary)

            HStack(spacing: SpotlySpacing.xs) {
                Group {
                    if isSecure && !isRevealed {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .textInputAutocapitalization(autocapitalization)
                    }
                }
                .font(SpotlyFont.body())
                .foregroundStyle(SpotlyColors.textPrimary)
                .tint(SpotlyColors.accent)
                .textContentType(textContentType)
                .focused($isFocused)

                if isSecure {
                    Button {
                        isRevealed.toggle()
                        SpotlyHaptics.lightTap()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, SpotlySpacing.md)
            .padding(.vertical, SpotlySpacing.sm + 2)
            .background(SpotlyColors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                    .stroke(
                        hasError         ? SpotlyColors.error        :
                        isFocused        ? SpotlyColors.borderAccent :
                                           SpotlyColors.inputBorder,
                        lineWidth: (isFocused || hasError) ? 1.5 : 0.5
                    )
            }
            .animation(SpotlyMotion.quickTap, value: isFocused)
            .animation(SpotlyMotion.softSpring, value: hasError)
        }
    }
}
