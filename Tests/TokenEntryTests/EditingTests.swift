import Testing
@testable import TokenEntry
private struct Tag: Identifiable { let id: Int; let label: String }
@Test func twoBackspacesSelectThenDelete() {
    var tags = [Tag(id: 1, label: "Same"), Tag(id: 2, label: "Same")]
    var selection: Int?
    TokenEditing.backspace(tokens: &tags, selection: &selection)
    #expect(selection == 2 && tags.count == 2)
    TokenEditing.backspace(tokens: &tags, selection: &selection)
    #expect(selection == nil && tags.map(\.id) == [1])
}
@Test func emptyAndExplicitDeletion() {
    var tags: [Tag] = []; var selection: Int?
    TokenEditing.backspace(tokens: &tags, selection: &selection)
    #expect(selection == nil)
    tags = [Tag(id: 1, label: "A"), Tag(id: 2, label: "B")]; selection = 1
    TokenEditing.delete(1, from: &tags, selection: &selection)
    #expect(selection == nil && tags.map(\.id) == [2])
}

#if canImport(UIKit)
import UIKit
import SwiftUI
@Test @MainActor func compositionDoesNotOverwriteBinding() {
    var text = ""
    let input = TokenTextInput(text: Binding(get: { text }, set: { text = $0 }), placeholder: "", enabled: true, backspace: {}, changed: {}, submitted: {})
    let coordinator = input.makeCoordinator()
    let field = EditingTextField()
    field.setMarkedText("に", selectedRange: NSRange(location: 1, length: 0))
    coordinator.changed(field)
    #expect(text.isEmpty)
    field.unmarkText()
    coordinator.changed(field)
    #expect(text == "に")
}
@Test @MainActor func hostingAdapterContainsAndDetaches() {
    struct Item: Identifiable { let id: Int }
    let root = TokenEntryField(tokens: .constant([Item(id: 1)]), text: .constant(""), selection: .constant(nil), accessibilityLabel: { _ in "One" }, onSubmit: { _ in }) { _, _ in Text("One") }
    let parent = UIViewController()
    let host = TokenEntryHostingView(rootView: root, parent: parent)
    #expect(parent.children.count == 1)
    host.detach()
    #expect(parent.children.isEmpty)
}
#endif
