import SwiftUI
import TokenEntry
struct Tag: Identifiable { let id = UUID(); let name: String }
@main struct TokenEntryDemoApp: App {
    var body: some Scene { WindowGroup { Playground() } }
}
struct Playground: View {
    @State private var tags = [Tag(name: "Alex Morgan"), Tag(name: "Sam Rivera"), Tag(name: "Design")]
    @State private var text = ""
    @State private var selection: UUID?
    @State private var disabled = false
    @State private var avatars = true
    @State private var rtl = false
    @State private var spacing = 8.0
    @State private var validation = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Make room for everyone.").font(.largeTitle.bold())
                    Text("Recipients, tags, and ideas — one flexible field.").foregroundStyle(.secondary)
                    TokenEntryField(tokens: $tags, text: $text, selection: $selection,
                        placeholder: "Add a name or tag", spacing: spacing,
                        accessibilityLabel: { $0.name }, onSubmit: { value in
                            if value.count > 80 { validation = "Use 80 characters or fewer for a token." }
                            else { tags.append(Tag(name: value)); validation = "" }
                        }) { tag, selected in
                        HStack(spacing: 6) {
                            if avatars { Image(systemName: "person.crop.circle.fill") }
                            Text(tag.name).lineLimit(2)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .background(selected ? Color.indigo : Color.indigo.opacity(0.12), in: Capsule())
                        .foregroundStyle(selected ? .white : .primary)
                    }
                    .disabled(disabled)
                    .padding(16)
                    .background(.background, in: RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.quaternary))
                    .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
                    if !validation.isEmpty { Text(validation).foregroundStyle(.red).accessibilityIdentifier("validation") }
                    Text("\(tags.count) tokens").font(.caption).accessibilityIdentifier("token-count")
                    Toggle("Show avatars", isOn: $avatars)
                    Toggle("Disabled", isOn: $disabled)
                    Toggle("Right-to-left layout", isOn: $rtl)
                    Text("Spacing")
                    Slider(value: $spacing, in: 0...20)
                    Button("Reset") { tags = [Tag(name: "Alex Morgan"), Tag(name: "Sam Rivera"), Tag(name: "Design")]; text = ""; selection = nil }
                    Text("Tap a token to select it. Backspace in an empty input selects the last token; press again to remove it. Return adds your text.").font(.footnote).foregroundStyle(.secondary)
                }.padding(24)
            }.background(Color(.systemGroupedBackground)).navigationTitle("TokenEntry")
        }
    }
}
