#if canImport(UIKit)
import SwiftUI
import UIKit

@MainActor
public struct TokenEntryField<Token: Identifiable, TokenContent: View>: View {
    @Binding private var tokens: [Token]
    @Binding private var text: String
    @Binding private var selection: Token.ID?
    private let placeholder: String
    private let label: (Token) -> String
    private let content: (Token, Bool) -> TokenContent
    private let submit: (String) -> Void
    @Environment(\.isEnabled) private var enabled
    @Environment(\.layoutDirection) private var direction
    private var spacing: CGFloat

    public init(tokens: Binding<[Token]>, text: Binding<String>, selection: Binding<Token.ID?>,
                placeholder: String = "Add a token", spacing: CGFloat = 8,
                accessibilityLabel: @escaping (Token) -> String,
                onSubmit: @escaping (String) -> Void,
                @ViewBuilder tokenContent: @escaping (Token, Bool) -> TokenContent) {
        _tokens = tokens; _text = text; _selection = selection
        self.placeholder = placeholder; self.spacing = max(0, spacing)
        label = accessibilityLabel; submit = onSubmit; content = tokenContent
    }
    public var body: some View {
        TokenFlowLayout(spacing: spacing, rightToLeft: direction == .rightToLeft) {
            ForEach(tokens) { token in
                Button {
                    selection = selection == token.id ? nil : token.id
                } label: {
                    content(token, selection == token.id)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(label(token))
                .accessibilityAddTraits(selection == token.id ? .isSelected : [])
                .accessibilityAction(named: Text("Delete")) {
                    guard enabled else { return }
                    TokenEditing.delete(token.id, from: &tokens, selection: &selection)
                }
            }
            TokenTextInput(text: $text, placeholder: placeholder, enabled: enabled,
                backspace: { TokenEditing.backspace(tokens: &tokens, selection: &selection) },
                changed: {
                    if !text.isEmpty, let id = selection {
                        TokenEditing.delete(id, from: &tokens, selection: &selection)
                    }
                }, submitted: {
                    let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !value.isEmpty else { return }
                    submit(value)
                    text = ""
                    selection = nil
                })
                .frame(minWidth: 80, minHeight: 44)
        }
        .onChange(of: tokens.map(\.id)) {
            if let id = selection, !tokens.contains(where: { $0.id == id }) { selection = nil }
        }
    }
}

struct TokenFlowLayout: Layout {
    var spacing: CGFloat
    var rightToLeft: Bool
    private func positions(_ proposal: ProposedViewSize, _ views: Subviews) -> (CGSize, [CGRect]) {
        let width = max(1, proposal.width ?? 320)
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        var frames: [CGRect] = []
        for view in views {
            let measured = view.sizeThatFits(ProposedViewSize(width: width, height: nil))
            let size = CGSize(width: min(width, measured.width), height: measured.height)
            if x > 0 && x + size.width > width { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            frames.append(CGRect(x: rightToLeft ? width - x - size.width : x, y: y, width: size.width, height: size.height))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return (CGSize(width: width, height: y + rowHeight), frames)
    }
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        positions(proposal, subviews).0
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = positions(ProposedViewSize(width: bounds.width, height: nil), subviews).1
        for (view, frame) in zip(subviews, frames) {
            view.place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), anchor: .topLeading,
                       proposal: ProposedViewSize(frame.size))
        }
    }
}

@MainActor
struct TokenTextInput: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var enabled: Bool
    var backspace: () -> Void
    var changed: () -> Void
    var submitted: () -> Void
    func makeUIView(context: Context) -> EditingTextField {
        let field = EditingTextField()
        field.delegate = context.coordinator
        field.addTarget(context.coordinator, action: #selector(Coordinator.changed), for: .editingChanged)
        field.returnKeyType = .done
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.accessibilityIdentifier = "token-input"
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return field
    }
    func updateUIView(_ field: EditingTextField, context: Context) {
        context.coordinator.parent = self
        field.emptyBackspace = backspace
        field.placeholder = placeholder
        field.accessibilityLabel = placeholder
        field.isEnabled = enabled
        if field.markedTextRange == nil && field.text != text { field.text = text }
    }
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: EditingTextField, context: Context) -> CGSize? {
        let font = uiView.font ?? .preferredFont(forTextStyle: .body)
        let width = ((text.isEmpty ? placeholder : text) as NSString).size(withAttributes: [.font: font]).width + 20
        return CGSize(width: min(proposal.width ?? width, max(80, width)), height: max(44, font.lineHeight + 12))
    }
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    @MainActor final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TokenTextInput
        init(_ parent: TokenTextInput) { self.parent = parent }
        @objc func changed(_ field: UITextField) {
            guard field.markedTextRange == nil else { return }
            parent.text = field.text ?? ""
            parent.changed()
        }
        func textFieldShouldReturn(_ field: UITextField) -> Bool {
            guard field.markedTextRange == nil else { return true }
            parent.submitted()
            return false
        }
    }
}

@MainActor
final class EditingTextField: UITextField {
    var emptyBackspace: (() -> Void)?
    override func deleteBackward() {
        if (text ?? "").isEmpty && markedTextRange == nil { emptyBackspace?() }
        else { super.deleteBackward() }
    }
}

@MainActor
public final class TokenEntryHostingView<Token: Identifiable, Content: View>: UIView {
    private let host: UIHostingController<TokenEntryField<Token, Content>>
    public init(rootView: TokenEntryField<Token, Content>, parent: UIViewController) {
        host = UIHostingController(rootView: rootView)
        super.init(frame: .zero)
        host.sizingOptions = [.intrinsicContentSize]
        host.view.backgroundColor = .clear
        parent.addChild(host)
        addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor), host.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.view.topAnchor.constraint(equalTo: topAnchor), host.view.bottomAnchor.constraint(equalTo: bottomAnchor)])
        host.didMove(toParent: parent)
    }
    @available(*, unavailable) required init?(coder: NSCoder) { fatalError() }
    /// Call before removing the adapter from its parent controller.
    public func detach() {
        host.willMove(toParent: nil)
        host.view.removeFromSuperview()
        host.removeFromParent()
        removeFromSuperview()
    }
}
#endif
