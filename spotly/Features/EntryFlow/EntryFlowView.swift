import SwiftUI

enum EntryFlowStep: Hashable {
    case signIn
    case createAccount
    case forgotPassword
}

/// Fast production entry: browse as a guest immediately, or authenticate when desired.
/// Optional profile, location, interests and notification choices are collected contextually
/// after the customer has reached the product instead of blocking first use.
struct EntryFlowView: View {
    @Environment(AppState.self) private var appState
    @State private var path: [EntryFlowStep] = []
    @State private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            AuthWelcomeView(
                onCreateAccount: { path.append(.createAccount) },
                onSignIn: { path.append(.signIn) },
                onGuest: enterGuest
            )
            .navigationDestination(for: EntryFlowStep.self) { step in
                switch step {
                case .signIn:
                    SignInView(
                        viewModel: authViewModel,
                        onSuccess: finishAuthenticated,
                        onForgotPassword: { path.append(.forgotPassword) },
                        onGuest: enterGuest
                    )
                case .createAccount:
                    CreateAccountView(
                        viewModel: authViewModel,
                        onSuccess: finishAuthenticated,
                        onGuest: enterGuest
                    )
                case .forgotPassword:
                    ForgotPasswordView(viewModel: authViewModel)
                }
            }
        }
    }

    private func finishAuthenticated(_ user: SpotlyUser) {
        appState.currentUser = user
        appState.isGuestMode = false
        appState.authState = .authenticated
        if let city = user.location.nilIfBlank { appState.selectedCity = city }
        withAnimation(SpotlyMotion.pageTransition) { appState.hasCompletedEntryFlow = true }
        Task {
            async let saved: Void = appState.saved.load(user: user)
            async let activity: Void = appState.activity.load(user: user, force: true)
            async let push: Void = PushCoordinator.shared.registerCurrentTokenForSignedInUser()
            _ = await (saved, activity, push)
        }
    }

    private func enterGuest() {
        appState.currentUser = nil
        appState.isGuestMode = true
        appState.authState = .guest
        withAnimation(SpotlyMotion.pageTransition) { appState.hasCompletedEntryFlow = true }
    }
}
