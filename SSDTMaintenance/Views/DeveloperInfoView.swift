//
//  DeveloperInfoView.swift
//  SSDTMaintenance
//
//  Developer Information & Donation
//

import SwiftUI

struct DeveloperInfoView: View {

    // MARK: - Links

    private let email = "nmano0006@gmail.com"
    private let githubURL = URL(string: "https://github.com/nmano0006")!
    private let donateURL = URL(
        string: "https://www.paypal.com/donate/?business=H3PV9HX92AVMJ&no_recurring=0&item_name=Support+development+of+all+my+apps+and+tools.+Donations+fund+testing+hardware%2C+servers%2C+and+continued+open-source+development.&currency_code=CAD"
    )!

    var body: some View {
        ZStack {
            // Modern window background
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                // MARK: - Title
                VStack(spacing: 6) {
                    Text("SSDT Maintenance Utility")
                        .font(.largeTitle.bold())

                    Text("Developer Information")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()

                // MARK: - Developer Details
                VStack(alignment: .leading, spacing: 14) {

                    infoRow(
                        icon: "person.fill",
                        title: "Developer",
                        value: "Navaratnam Manoranjan"
                    )

                    infoRow(
                        icon: "envelope.fill",
                        title: "Email",
                        value: email,
                        action: {
                            NSWorkspace.shared.open(
                                URL(string: "mailto:\(email)")!
                            )
                        }
                    )

                    infoRow(
                        icon: "chevron.left.slash.chevron.right",
                        title: "GitHub",
                        value: "github.com/nmano0006",
                        action: {
                            NSWorkspace.shared.open(githubURL)
                        }
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                // MARK: - Description
                Text("""
This open-source utility helps generate clean, OpenCore-ready SSDTs \
for modern Hackintosh systems.

If this project saves you time or helps your build, \
consider supporting continued development.
""")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

                // MARK: - Donate Button (Dark Green)
                Button {
                    NSWorkspace.shared.open(donateURL)
                } label: {
                    Label("Support Development", systemImage: "heart.fill")
                        .frame(minWidth: 200)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.0, green: 0.45, blue: 0.25)) // 🌲 dark green
                .controlSize(.large)

                Spacer()
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(NSColor.textBackgroundColor))
            )
            .padding()
        }
    }

    // MARK: - Info Row Helper

    private func infoRow(
        icon: String,
        title: String,
        value: String,
        action: (() -> Void)? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 20)

            Text(title)
                .fontWeight(.semibold)

            Spacer()

            if let action = action {
                Button(value) {
                    action()
                }
                .buttonStyle(.link)
            } else {
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    DeveloperInfoView()
}
