# Troubleshooting

Missing TokenEntryField on macOS: the visual component supports iOS/iPadOS; only shared editing logic builds on macOS. Package not found: remove the old package identity and add the new URL/product. Old XIB subclasses do not compile against the new API; follow MIGRATION.

Unexpected deletion: IDs must be unique and stable. Incorrect height: let the field determine height and constrain width. A UIKit host must maintain containment and call detach before removal. Do not overwrite bindings during marked-text composition.
