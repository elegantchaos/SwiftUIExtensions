[![Test results][tests shield]][actions] [![Latest release][release shield]][releases] [![Swift 5.0][swift shield]][swift] ![Platforms: iOS, macOS, tvOS, watchOS, Linux][platforms shield]

[swift]: https://swift.org
[releases]: https://github.com/elegantchaos/SwiftUIExtensions/releases
[actions]: https://github.com/elegantchaos/SwiftUIExtensions/actions

[release shield]: https://img.shields.io/github/v/release/elegantchaos/SwiftUIExtensions
[swift shield]: https://img.shields.io/badge/swift-5.1-F05138.svg "Swift 5.1"
[platforms shield]: https://img.shields.io/badge/platforms-iOS_macOS_tvOS_watchOS_Linux-lightgrey.svg?style=flat "iOS, macOS, tvOS, watchOS, Linux"
[tests shield]: https://github.com/elegantchaos/SwiftUIExtensions/workflows/Tests/badge.svg

# SwiftUIExtensions

A small grab bag of my extensions and utilities for SwiftUI.

Right now, the things in here are mostly focussed at allowing the same code to build for macOS/iOS/tvOS targets.

This involves adding some abstractions and shims to gloss over platform differences.


### Scope and Stability

In general I prefer to have more focussed packages, so as things in here become more substantial I'll probably move them out into their own packages.  As such, it's probably not a good idea to rely on this API being particularly stable.

It's always helpful to have somewhere to dump "the other stuff" however - this is that place for my miscellaneous SwiftUI code.
