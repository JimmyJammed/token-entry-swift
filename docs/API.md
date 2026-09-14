# API

`TokenEntryField<Token: Identifiable, TokenContent: View>` receives bindings to tokens, input text, and optional selected Token.ID. IDs must be stable and unique even when labels match. Supply accessibilityLabel, onSubmit, and a tokenContent builder receiving the token and selection state. Placeholder defaults to “Add a token”; spacing defaults to 8 points.

Tap toggles selection. Backspace with empty text selects the last token, then removes the selected token. Typing while a token is selected removes that token. Return submits trimmed nonempty input, then clears input/selection. The consumer decides how submitted text becomes a token and whether to accept duplicates.

Marked text is not copied back to the SwiftUI binding until composition commits. Native editing supports paste and hardware keyboard input. Disabling the control disables token actions and input.

`TokenEntryHostingView(rootView:parent:)` embeds the same SwiftUI field in UIKit using correct child-controller containment. Constrain its width and allow its hosted intrinsic height. Call detach before discarding it from the parent. Bindings remain owned by your application.

`TokenEditing.backspace(tokens:selection:)` and delete provide stable-identity editing primitives.
