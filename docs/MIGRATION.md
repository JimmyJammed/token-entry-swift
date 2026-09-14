# NWSTokenView → TokenEntry 3.0

The NWS prefix belonged to the former NitWit Studios name. The existing repository is renamed in place to JimmyJammed/token-entry-swift; history, issues, stars, and historical releases stay attached.

1. Remove the old CocoaPods/package dependency and imports.
2. Add https://github.com/JimmyJammed/token-entry-swift.git and select product TokenEntry. Do not add both old and new package URLs.
3. Change `import NWSTokenView` to `import TokenEntry`.
4. Replace data-source token counts/views with a token-array binding and tokenContent builder.
5. Replace selection/deletion delegates with selection and token bindings; text callbacks become the text binding and onSubmit.
6. Replace XIB subclasses with SwiftUI token content. UIKit apps can use TokenEntryHostingView with a parent view controller and call detach during teardown.

There is no misleading typealias claiming compatibility with the old UIView subclass. Existing CocoaPods releases remain historical; new releases use SPM. Update Git remotes, documentation links, schemes, and package resolution. Preserve old license notices. HISTORY links the pre-modernization revision.
