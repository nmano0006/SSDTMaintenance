import SwiftUI

struct ModernCard<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.padding)
            .background(
                RoundedRectangle(
                    cornerRadius: AppTheme.cornerRadius,
                    style: .continuous
                )
                .fill(AppTheme.panelBackground)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: AppTheme.cornerRadius,
                    style: .continuous
                )
                .stroke(Color.black.opacity(0.05))
            )
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}


