import SwiftUI

struct ModernBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AppTheme.windowBackground
                .ignoresSafeArea()

            content
        }
    }
}

extension View {
    func modernBackground() -> some View {
        modifier(ModernBackground())
    }
}

