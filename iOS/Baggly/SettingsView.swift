import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @State private var remindersEnabled = true
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                Form {
                    Section("Preferences") {
                        Toggle("Reminders", isOn: $remindersEnabled)
                            .accessibilityIdentifier("toggle_reminders")
                    }
                    Section("Pro") {
                        if purchases.isPro {
                            Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(Theme.accent)
                        } else {
                            Button("Upgrade to Pro") {
                                showPaywall = true
                            }
                            .accessibilityIdentifier("button_upgrade")
                        }
                        Button("Restore Purchases") {
                            Task { await purchases.restore() }
                        }
                        .accessibilityIdentifier("button_restore")
                    }
                    Section("About") {
                        Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/baggly-app/privacy.html")!)
                        Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/baggly-app/terms.html")!)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("button_done_settings")
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .tint(Theme.accent)
        }
    }
}
