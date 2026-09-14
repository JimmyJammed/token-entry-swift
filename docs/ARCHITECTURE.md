# Architecture

SwiftUI owns token identity, content, selection, and wrapping layout. A narrow UITextField bridge preserves marked-text and backspace behavior. The UIKit adapter hosts the SwiftUI control rather than duplicating its editing logic. There are no third-party package dependencies.

Flow layout measures token content against available width and wraps in source order. Dynamic content and input remain in the accessibility tree. Global UIView animations are never disabled.
