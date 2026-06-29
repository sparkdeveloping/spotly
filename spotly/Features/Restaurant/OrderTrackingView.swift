import SwiftUI

struct OrderTrackingView: View {
    let business: SpotlyBusiness
    let total: Double
    var onDone: () -> Void
    @State private var currentStep = 1
    @State private var estimatedMinutes = 35
    @State private var showContactPlaceholder = false

    let steps: [(icon: String, title: String, subtitle: String)] = [
        ("checkmark.circle.fill",   "Order confirmed",       "Your order has been received"),
        ("flame.fill",              "Preparing your order",  "The kitchen is working on it"),
        ("bicycle",                 "Out for delivery",      "Your rider is on the way"),
        ("house.fill",              "Delivered",             "Enjoy your meal!"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xl) {
                    estimatedTimeCard
                    statusTimeline
                    mapPlaceholder
                    riderCard
                    SpotlyBottomSafeSpacer(extra: 80)
                }
                .padding(.top, SpotlySpacing.xl)
            }
            .background(SpotlyColors.background)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            doneButton
        }
        .onAppear { startProgressSimulation() }
        .sheet(isPresented: $showContactPlaceholder) {
            SpotlyFeedbackSheet(icon: "phone.fill", title: "Contact rider preview", message: "Rider calling and chat will be enabled when delivery partners are connected. For this demo, tracking shows the complete customer flow without real dispatch.")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: SpotlySpacing.xs) {
            Text("Order tracking")
                .font(SpotlyFont.headline(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Text(business.name)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(SpotlySpacing.md)
        .background(SpotlyColors.surface)
        .overlay(alignment: .bottom) { Divider() }
    }

    // MARK: - Estimated time card

    private var estimatedTimeCard: some View {
        VStack(spacing: SpotlySpacing.xs) {
            Text("Estimated arrival")
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
            Text("\(estimatedMinutes) min")
                .font(.system(size: 48, weight: .bold, design: .default))
                .foregroundStyle(SpotlyColors.accent)
            Text("Order total: US$\(String(format: "%.2f", total))")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(SpotlySpacing.xl)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    // MARK: - Status timeline

    private var statusTimeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Order status")
                .font(SpotlyFont.headline(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.md)

            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                    let stepNum = idx + 1
                    let isDone = stepNum < currentStep
                    let isCurrent = stepNum == currentStep
                    HStack(alignment: .top, spacing: SpotlySpacing.md) {
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(isDone || isCurrent ? SpotlyColors.accent : SpotlyColors.border)
                                    .frame(width: 32, height: 32)
                                Image(systemName: isDone ? "checkmark" : step.icon)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(isDone || isCurrent ? .white : SpotlyColors.textTertiary)
                            }
                            if idx < steps.count - 1 {
                                Rectangle()
                                    .fill(isDone ? SpotlyColors.accent : SpotlyColors.border)
                                    .frame(width: 2, height: 44)
                            }
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .font(SpotlyFont.callout(isCurrent ? .semibold : .regular))
                                .foregroundStyle(isCurrent ? SpotlyColors.textPrimary : (isDone ? SpotlyColors.textSecondary : SpotlyColors.textTertiary))
                            if isCurrent {
                                Text(step.subtitle)
                                    .font(SpotlyFont.caption())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                        }
                        .padding(.top, SpotlySpacing.xxs)
                        Spacer()
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                }
            }
        }
        .padding(.vertical, SpotlySpacing.md)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    // MARK: - Map placeholder

    private var mapPlaceholder: some View {
        ZStack {
            SpotlyColors.backgroundElevated
            VStack(spacing: SpotlySpacing.xs) {
                Image(systemName: "map")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(SpotlyColors.accent.opacity(0.6))
                Text("Live map tracking")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                Text("Available after launch")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    // MARK: - Rider card

    private var riderCard: some View {
        HStack(spacing: SpotlySpacing.md) {
            ZStack {
                Circle().fill(SpotlyColors.accentBg).frame(width: 48, height: 48)
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(SpotlyColors.accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Chidi M.")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("Your delivery rider")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
            Button {
                SpotlyHaptics.lightTap()
                showContactPlaceholder = true
            } label: {
                Label("Call", systemImage: "phone.fill")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
                    .padding(.horizontal, SpotlySpacing.sm)
                    .padding(.vertical, SpotlySpacing.xs)
                    .background(SpotlyColors.accentBg)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(SpotlySpacing.md)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    // MARK: - Done button

    private var doneButton: some View {
        Button {
            SpotlyHaptics.success()
            onDone()
        } label: {
            Text("Done")
                .font(SpotlyFont.headline())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(SpotlyColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
        }
        .buttonStyle(.plain)
        .pressableScale()
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
        .overlay(alignment: .top) { Divider() }
    }

    // MARK: - Progress simulation

    private func startProgressSimulation() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run { withAnimation { currentStep = 2 } }
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run { withAnimation { currentStep = 3; estimatedMinutes = 20 } }
        }
    }
}
