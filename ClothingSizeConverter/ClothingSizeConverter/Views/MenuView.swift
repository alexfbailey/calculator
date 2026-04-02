import SwiftUI

struct MenuView: View {
    var onClearAll: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showClearConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }

                    NavigationLink {
                        PrivacyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }

                    NavigationLink {
                        TermsView()
                    } label: {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash")
                    }
                    .confirmationDialog(
                        "Reset all preferences to defaults?",
                        isPresented: $showClearConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Clear All Data", role: .destructive) {
                            onClearAll()
                            dismiss()
                        }
                    }
                } footer: {
                    Text("Removes all locally stored preferences. No personal data is ever collected.")
                        .font(.caption)
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - About

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "ruler")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)
                    .padding(.top, 40)

                Text("Clothing Size Converter")
                    .font(.title2.weight(.bold))

                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Instantly convert clothing sizes between 10 international sizing systems. Supports Women's & Men's categories.\n\nBuilt with privacy-first principles. No data leaves your device.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Privacy Policy

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                privacyItem(
                    title: "No Data Collection",
                    body: "This app does not collect, store, or transmit any personal data. No accounts are required."
                )
                privacyItem(
                    title: "No Tracking",
                    body: "Zero analytics, advertising, fingerprinting, or third-party SDKs. No network requests are made."
                )
                privacyItem(
                    title: "Local Only",
                    body: "All conversions run entirely on your device. Your preferences (default regions) are stored in local app storage and never leave your device."
                )
                privacyItem(
                    title: "No Permissions",
                    body: "This app requires no special permissions \u{2014} no location, camera, contacts, or notifications."
                )
                privacyItem(
                    title: "Your Rights (GDPR)",
                    body: "Since no personal data is collected, there is nothing to access, export, or delete. You can use \"Clear All Data\" in the menu to reset preferences."
                )
                privacyItem(
                    title: "Open & Transparent",
                    body: "The app uses no external dependencies or libraries. You can verify this in the project source."
                )

                Text("Last updated: April 2026")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 8)
            }
            .padding(20)
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func privacyItem(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(body)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Terms

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Clothing Size Converter is provided as-is for informational purposes. Size conversions are approximate and may vary by brand and manufacturer.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text("Always check the specific brand's size chart for the most accurate fit. We are not responsible for sizing discrepancies.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text("Last updated: April 2026")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 8)
            }
            .padding(20)
        }
        .navigationTitle("Terms")
        .navigationBarTitleDisplayMode(.inline)
    }
}
