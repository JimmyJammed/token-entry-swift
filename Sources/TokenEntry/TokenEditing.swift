/// Stable-identity editing shared by SwiftUI and UIKit hosts.
public enum TokenEditing {
    /// Empty-input backspace first selects the last token, then deletes it.
    public static func backspace<Token: Identifiable>(tokens: inout [Token], selection: inout Token.ID?) {
        if let selected = selection {
            tokens.removeAll { $0.id == selected }
            selection = nil
        } else {
            selection = tokens.last?.id
        }
    }
    public static func delete<Token: Identifiable>(_ id: Token.ID, from tokens: inout [Token], selection: inout Token.ID?) {
        tokens.removeAll { $0.id == id }
        if selection == id { selection = nil }
    }
}
