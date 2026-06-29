import SwiftUI

// MARK: - Validation context

private enum ValidationContext { case signIn, createAccount, resetPassword }

// MARK: - AuthViewModel

@Observable
final class AuthViewModel {
    var name            = ""
    var email           = ""
    var password        = ""
    var confirmPassword = ""
    var isLoading       = false
    var errorMessage: String?   = nil
    var successMessage: String? = nil

    private let authService: any AuthServiceProtocol

    init(authService: any AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
    }

    // MARK: - Actions

    @MainActor
    func signIn() async -> SpotlyUser? {
        guard validate(.signIn) else { return nil }
        isLoading = true
        errorMessage = nil
        do {
            let user = try await authService.signIn(email: trimmedEmail, password: password)
            isLoading = false
            return user
        } catch {
            isLoading = false
            errorMessage = "We couldn't sign you in. Check your details and try again."
            SpotlyHaptics.error()
            return nil
        }
    }

    @MainActor
    func createAccount() async -> SpotlyUser? {
        guard validate(.createAccount) else { return nil }
        isLoading = true
        errorMessage = nil
        do {
            let user = try await authService.createUser(name: trimmedName, email: trimmedEmail, password: password)
            isLoading = false
            return user
        } catch {
            isLoading = false
            errorMessage = "We couldn't create your account right now. Try again."
            SpotlyHaptics.error()
            return nil
        }
    }

    @MainActor
    func resetPassword() async {
        guard validate(.resetPassword) else { return }
        isLoading = true
        errorMessage = nil
        successMessage = nil
        do {
            try await authService.resetPassword(email: trimmedEmail)
            isLoading = false
            successMessage = "Reset link sent. Check your email."
            SpotlyHaptics.success()
        } catch {
            isLoading = false
            errorMessage = "Connection issue. Try again in a moment."
            SpotlyHaptics.error()
        }
    }

    func clearError() {
        withAnimation(SpotlyMotion.softSpring) { errorMessage = nil }
    }

    // MARK: - Validation

    private var trimmedEmail: String { email.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var trimmedName: String  { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    private func validate(_ context: ValidationContext) -> Bool {
        let email = trimmedEmail
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            errorMessage = "Enter a valid email address."
            return false
        }
        if context == .resetPassword { return true }

        guard !password.isEmpty else {
            errorMessage = "Enter your password to continue."
            return false
        }
        if context == .createAccount {
            guard password.count >= 6 else {
                errorMessage = "That password is too short. Use at least 6 characters."
                return false
            }
            guard password == confirmPassword else {
                errorMessage = "Passwords don't match. Check and try again."
                return false
            }
            guard !trimmedName.isEmpty else {
                errorMessage = "Add your name so we can personalise Spotly for you."
                return false
            }
        }
        return true
    }
}
