import SwiftUI

enum EntryFlowStep: Hashable {
    case welcome
    case signIn
    case createAccount
    case forgotPassword
    case profileSetup
    case interestSelection
    case locationPermission
    case notificationPreference
}

struct EntryFlowView: View {
    @Environment(AppState.self) private var appState
    @State private var path: [EntryFlowStep] = []
    @State private var authViewModel = AuthViewModel()
    @State private var profileName: String = ""
    @State private var phone: String = ""
    @State private var selectedCity: String = "Harare"

    var body: some View {
        NavigationStack(path: $path) {
            AuthWelcomeView(
                onCreateAccount: { path.append(.createAccount) },
                onSignIn: { path.append(.signIn) },
                onGuest: { enterGuestPersonalization() }
            )
            .navigationDestination(for: EntryFlowStep.self) { step in
                switch step {
                case .welcome:
                    AuthWelcomeView(
                        onCreateAccount: { path.append(.createAccount) },
                        onSignIn: { path.append(.signIn) },
                        onGuest: { enterGuestPersonalization() }
                    )

                case .signIn:
                    SignInView(
                        viewModel: authViewModel,
                        onSuccess: { user in handleAuthSuccess(user) },
                        onForgotPassword: { path.append(.forgotPassword) },
                        onGuest: { enterGuestPersonalization() }
                    )

                case .createAccount:
                    CreateAccountView(
                        viewModel: authViewModel,
                        onSuccess: { user in handleAuthSuccess(user) },
                        onGuest: { enterGuestPersonalization() }
                    )

                case .forgotPassword:
                    ForgotPasswordView(viewModel: authViewModel)

                case .profileSetup:
                    ProfileSetupView(
                        name: $profileName,
                        phone: $phone,
                        selectedCity: $selectedCity,
                        onNext: { path.append(.interestSelection) }
                    )

                case .interestSelection:
                    InterestSelectionView(
                        onNext: { path.append(.locationPermission) },
                        onSkip: { path.append(.locationPermission) }
                    )

                case .locationPermission:
                    LocationPermissionView(
                        onNext: { path.append(.notificationPreference) },
                        onSkip: { path.append(.notificationPreference) }
                    )

                case .notificationPreference:
                    NotificationPreferenceView(
                        onFinish: { preferences in completeEntryFlow(notificationPreferences: preferences) }
                    )
                }
            }
        }
    }

    private func handleAuthSuccess(_ user: SpotlyUser) {
        appState.currentUser = user
        appState.authState = .authenticated
        profileName = user.name
        path.append(.profileSetup)
    }

    private func enterGuestPersonalization() {
        appState.isGuestMode = true
        appState.authState = .guest
        profileName = appState.guestProfileName == "Guest" ? "" : appState.guestProfileName
        selectedCity = appState.selectedCity
        path.append(.profileSetup)
    }

    private func completeEntryFlow(notificationPreferences: Set<String>) {
        appState.completeProfile(name: profileName, phone: phone, city: selectedCity)
        appState.notificationPreference = notificationPreferences
        withAnimation(SpotlyMotion.pageTransition) {
            appState.hasCompletedEntryFlow = true
        }
    }
}
