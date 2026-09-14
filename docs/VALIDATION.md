# Validation — 2026-09-14

Scope: source in this modernization PR; obtain the exact reviewed commit with `git rev-parse HEAD`. Release artifacts record their target commit separately.

Host: macOS 26.6.2 (25G83), Apple Silicon. Xcode 26.6 (17F113), Swift 6.3.3, Swift 6 language mode.

- `swift test`: two platform-independent editing tests passed.
- Xcode TokenEntryDemo scheme, iPhone 17 Pro / iOS 26.5, parallel testing disabled: four unit tests and one UI test passed. Tests cover distinct IDs with duplicate labels, two-step deletion, empty deletion, marked-text binding preservation, UIKit containment/detachment, typing/submission and keyboard deletion.
- Demo application builds as a separate SPM consumer and imports TokenEntry.
- iPhone screenshot captured from the running app and visually reviewed.
- In-place GitHub rename verified: the old repository API redirects to JimmyJammed/token-entry-swift.

An overlapping simulator invocation failed; the isolated rerun passed. Xcode 27, iOS 18/27, physical keyboards, full Japanese/Chinese IME interaction, VoiceOver, all accessibility sizes, rotation checks have not been verified. No claim of hardware or unavailable OS validation is made. Run the checklist in TESTING before declaring those combinations supported in a release matrix.

Independent temporary SPM executable consumer: built and ran successfully with this package as a dependency. iPhone preview images were captured from the simulator and visually reviewed.

The same four unit tests and one UI test also passed on an iPad Pro 13-inch simulator running iPadOS 26.5.
