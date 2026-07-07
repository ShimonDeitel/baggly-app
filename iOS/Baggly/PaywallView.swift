import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Baggly Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.text)
                Text("Unlimited lists, templates & photos")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.text.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                Button {
                    Task { await purchases.purchasePro() }
                } label: {
                    Text("Subscribe - $\(1.99)/month")
                        .font(Theme.headlineFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(Theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("button_subscribe")
                .padding(.horizontal)

                Button("Not Now") { dismiss() }
                    .foregroundStyle(Theme.text.opacity(0.6))
                    .accessibilityIdentifier("button_not_now")
            }
            .padding()
        }
        .onChange(of: purchases.isPro) { _, newValue in
            if newValue { dismiss() }
        }
    }
}
