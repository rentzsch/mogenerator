### v1.31: Mon Oct 3 2016 [download](https://github.com/rentzsch/mogenerator/releases/download/1.31/mogenerator-1.31.dmg)

* [NEW] Swift 3 support. ([Goncharov Vladimir](https://github.com/rentzsch/mogenerator/pull/347), [Hardik](https://github.com/rentzsch/mogenerator/pull/349), [rentzsch](https://github.com/rentzsch/mogenerator/commit/a65f6421baf39dc1458f22836907cfc55fc8ceb1))

* [CHANGE] Add nullability to the primitive value. ([Tom Carey](https://github.com/rentzsch/mogenerator/pull/343))

* [CHANGE] Allow for nullable collection properties. ([Ibrahim Sha'ath](https://github.com/rentzsch/mogenerator/pull/338))

* [CHANGE] Mark `+entityInManagedObjectContext:` nullable. ([Ibrahim Sha'ath](https://github.com/rentzsch/mogenerator/pull/337))

* [DOC] Update link to Apple's Core Data Programming Guide. ([Brian Schrader](https://github.com/rentzsch/mogenerator/pull/341))

* [FIX] Syntax error in Objective-C templates. ([Dave Wood](https://github.com/rentzsch/mogenerator/pull/345))

* [TEST] Add Parent.orderedChildren ordered relationship. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/b5c68ff538ed8a77e43524d846a5ac89793662ca))



### v1.30.1: Thu Apr 7 2016 [download](https://github.com/rentzsch/mogenerator/releases/download/1.30.1/mogenerator-1.30.1.dmg)

* [FIX] Use `will`/`didChange` & `will`/`didAccess` in generated code when using `scalarsWhenNonOptional`. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/1646a154c8d9bb2e12b3f23eaca3bbfe9f9bc7c8))

* [FIX] Only use `@import` if supported (which Objective-C++ does not). [issue 325](https://github.com/rentzsch/mogenerator/issues/325) ([Samuel Bichsel](https://github.com/melbic))

* [FIX] Add space between property type and name. [issue 323](https://github.com/rentzsch/mogenerator/pull/323) ([Daniel Rodríguez Troitiño](https://github.com/drodriguez))



### v1.30: Mon Mar 21 2016 [download](https://github.com/rentzsch/mogenerator/releases/download/1.30/mogenerator-1.30.dmg)

Thanks to lieutenant [Justin Williams](https://github.com/justin) for helping with this release.

* [NEW] Official bundled Swift 2 templates. (Justin Williams [1](https://github.com/rentzsch/mogenerator/commit/8489f4d5e5b8b7bf570ef0d7934f2f9e7a8ecd92) [2](https://github.com/rentzsch/mogenerator/commit/a7f8e53f6357ad1ef9af7d9f7e7f3ec450df334b))

* [NEW] "Modern" Objective-C and Swift is default. Apple has made it exceptionally difficult to target older versions of OS X and iOS, so we've given up. The grand `--v2` experiment, which I loved, has been killed (the option will still be accepted to not break existing scripts but is now a no-op). From now on if you need to target an older OS, use an older mogenerator. Sorry. ([Justin Williams](https://github.com/rentzsch/mogenerator/pull/305))

* [NEW] Generate Objective-C Lightweight Generics. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/c141670d7f0ee11061ebb67de56c38a260315128))

* [NEW] Generate `instancetype`. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/83f031de783f876d843f4987377aac27452171e2))

* [NEW] Generate nullability attributes for Objective-C machine templates (`NS_ASSUME_NONNULL_BEGIN`/`nullable`). ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/b12d7a45cec823775ddefaafc0cfcc3c7a99ef32))

* [NEW] mogenerator project is now using [Travis CI](https://travis-ci.org/rentzsch/mogenerator). Travis automatically builds and runs mogenerator's test suite on each commit, reporting the results, making it easier+faster to process Pull Requests. (rentzsch)

* [NEW] Change of branch philosophy: master used to be the "stable" branch. Now it's the branch we're going to land incoming Pull Requests. Pull Requests will be accepted onto master pretty freely, Travis will help catch breaking changes. I want to reduce latency and friction for folks to help out with mogenerator. Related reading: [Drew Crawford's Conduct unbecoming of a hacker](http://sealedabstract.com/rants/conduct-unbecoming-of-a-hacker/). (rentzsch)

* [NEW] Specifying `--template-var scalarsWhenNonOptional=true` will have mogenerator generate only scalar properties for non-optional entity scalar attributes. For example, consider an `age` attribute. Without this option, mogenerator will generate two properties: `@property (…) NSNumber *age` and `@property (…) uint16_t ageValue`. With this option, only `@property (…) uint16_t age` would be generated, simplifying things since the age attribute can never be `nil`. ([Mr Anonymous](https://github.com/rentzsch/mogenerator/commit/51e8124101121ce8a863e68d597bab9ccd3628cc))

* [CHANGE] Replace [Mike Ash-style constant structures](http://www.mikeash.com/pyblog/friday-qa-2011-08-19-namespaced-constants-and-functions.html) in favor of more ARC-friendly NSObject subclasses. Should be source-compatible with with Mike Ash-style. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/69eb701ac7e5b84c8fc0297bf25d9f9f47844705))

* [FIX] You can specify an entity's module in Xcode's Core Data Model editor. However, when specifying the current module, the entity class name is prefixed with a period, resulting in an invalid class name. This period is now suppressed. ([Saul Mora](https://github.com/rentzsch/mogenerator/pull/311))

* [FIX] momcom: `NSPropertyDescription`'s `optional` wasn't being set correctly. [issue 286](https://github.com/rentzsch/mogenerator/issues/286) ([Matthias Bauch](https://github.com/rentzsch/mogenerator/commit/a04b88de5f872f4a3899de7716db2c9738b55a61))

* [FIX] override and explicitly include `xcshareddata` in `.gitignore` and add the default shared schemes. This fixes the problem where `xcodebuild` would fail with an `The project 'mogenerator' does not contain a scheme named 'mogenerator'` error until you first opened it in Xcode. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/8846237ca957437d664b48365c27dd2eb8b87773))

* [FIX] Generated indentation. ([Markus Chmelar](https://github.com/iv-mexx) [1](https://github.com/rentzsch/mogenerator/commit/7942420b3156d9cf3e38c17b7a956bd804187bf9) [2](https://github.com/rentzsch/mogenerator/commit/3030a8b1ab6c49ddadbc1033cd0e9a5c5d2d5a71))

* [FIX] Use `DERIVED_FILE_DIR` instead of `TMPDIR`. ([Jonathan MacMillan](https://github.com/rentzsch/mogenerator/issues/298))

* [CHANGE] Move the constant structures to the end of the machine header file. It's just uninteresting support code. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/f48402f4948790d08ceaeba30666a5998c057350))

* [MODERNIZE] MiscMerge: switch to Objective-C Modules. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/030e72a3a6e4edc73a61327ce161659762dc5bed))

* [MODERNIZE] Use instancetype internally. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/ddf66cd44e81d2fc196030914c1de4bad15f7e16))

* [MODERNIZE] 64-bit only. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/1fc894fe6bb493e202e4798665b17e3076384da6))

* [MODERNIZE] Replace `nsenumerate` macro with `for...in`. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/2afdfc84ad1da947e8530f0cb6d5eedf12007e57))

* [MODERNIZE] MiscMerge: encode all source files as UTF8. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/8a1a9f625773b7a5e867efdafc6e1a78bea37355))

* [MODERNIZE] Set minimum deployment target to 10.8. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/9f652bdc7d508d78ff9248b39bf02c814061b4ca))

* [MODERNIZE] Replace RegexKitLite with NSRegularExpression. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/ada5b2ae637001d6c1ce2b08539982b58b77f1f0))

* [MODERNIZE] Replace `arrayWithObjects` and `dictionaryWithObjectsAndKeys` with literals. ([Markus Chmelar](https://github.com/iv-mexx) [1](https://github.com/rentzsch/mogenerator/commit/c1139ef2eff8ba26397fbc9be9bab3aece02f40c) [2](https://github.com/rentzsch/mogenerator/commit/7b4d9faffeeb3615d33667a1f8625073876b43ee))

* [MODERNIZE] Replace `objectAtIndex:0` with `firstObject`. ([Markus Chmelar](https://github.com/rentzsch/mogenerator/commit/b317ac21b756b01c4eadacc677115583fab7a887))

* [REMOVED] //validate machine comments. They were just guides on writing your own validation methods and aren't worth the code clutter. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/92cf5905b8410d26ffb9531bd2f507b07c925754))

* [REMOVED] Xmo'd. It hasn't worked for a very long time and I have no immediate plans on putting in the time to get working again. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/47db28b8c07331b9c218603b99ca16fbd3076376))



### v1.29: Thu Aug 20 2015 [download](https://github.com/rentzsch/mogenerator/releases/download/1.29/mogenerator-1.29.dmg)

Much thanks to lieutenants [Tom Harrington](https://github.com/atomicbird) and [Justin Williams](https://github.com/justin) for handling this release.

* [NEW] Use built-in model compiler ([momcom](https://github.com/atomicbird/momcom)) instead of relying on Xcode's `momc`. ([Tom Harrington](https://github.com/rentzsch/mogenerator/pull/225))

* [NEW] Documentation generation using User Info keys. ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/268))

* [NEW] Multiuser support (use per-user `$TMPDIR` instead of `/tmp`). ([Annard Brouwer](https://github.com/rentzsch/mogenerator/pull/255))

* [NEW] Swift: support for additionalHeaderFileName. ([Leonardo Yvens](https://github.com/rentzsch/mogenerator/pull/285))

* [CHANGE] Swift: make generated machine classes and their attributes public. ([Fritz Anderson](https://github.com/rentzsch/mogenerator/commit/2c8b11cae06113d64361b5b049b7948294e72977))

* [CHANGE] Swift: make initializers public. ([Dave Reed](https://github.com/rentzsch/mogenerator/commit/015f98758eaf9136b95973a0fc2833b1030c0da8))

* [CHANGE] Swift: make enums public. ([Dave Reed](https://github.com/rentzsch/mogenerator/commit/6db379e890c0733cdf8f0e92789aa796ed0cf2de))

* [CHANGE] Swift: make mogenerator:readonly work for Swift by rendering the attribute as a read-only computed property. ([Tom Harrington](https://github.com/rentzsch/mogenerator/commit/fc99ca406560ad0fb43b12b995a2ccda6ea23a28))

* [CHANGE] Swift: method signatures for validate methods. [issue 281](https://github.com/rentzsch/mogenerator/issues/281). ([Tom Harrington](https://github.com/rentzsch/mogenerator/commit/5d5af8ec63c664ba1fe7cad07f057d5ccc0701cb))

* [FIX] Don't generate `-primativeType` and `-setPrimativeType:`. [issue 202](https://github.com/rentzsch/mogenerator/issues/202). ([rentzsch](https://github.com/rentzsch/mogenerator/commit/4ef709cef373138ac8d9368bf8dc034db6c88420))

* [FIX] Swift: ordered relationships. [issue 290](https://github.com/rentzsch/mogenerator/issues/290). ([Oleksii Taran](https://github.com/rentzsch/mogenerator/commit/ce927af0f0ebd79903b685091bf20bb31f3fda9c), [Tom Burns](https://github.com/rentzsch/mogenerator/pull/293))

* [FIX] Swift: model specified fetch requests. ([Dave Reed](https://github.com/rentzsch/mogenerator/commit/1542d9224dad8ef3c4c58724af604d6fff86f6f5), [Tom Harrington](https://github.com/rentzsch/mogenerator/commit/43f61d066d9daa65d6f941e01b9c0be8e56afb28))

* [FIX] Swift: MogenSwiftTest. ([Justin Williams](https://github.com/rentzsch/mogenerator/commit/517e527aa35e7da6ef89e1c11fa45393071085dd), [Dave Reed](https://github.com/rentzsch/mogenerator/commit/3f843651182fc75f9607ba6ed24039b91b9c0bd4))

* [FIX] Swift: generation of `override` method declarations. (Tom Harrington [1](https://github.com/rentzsch/mogenerator/commit/6f57408e7a1db0ebd07fb8a8190f819082293014), [2](https://github.com/rentzsch/mogenerator/commit/78e62b1247cfee13bc19131d5bf00fa59794c448))

* [FIX] Quote paths in test/Rakefile. ([Jonah Williams](https://github.com/rentzsch/mogenerator/commit/2f2f034d35cc0600ad2e12dd343dc5ccff888b35))



### v1.28: Wed Sep 10 2014 [download](https://github.com/rentzsch/mogenerator/releases/download/1.28/mogenerator-1.28.dmg)

* [NEW] `--v2` argument. I wanted to enable ARC by default, but decided to take it a step further (while not breaking existing scripts). The new `--v2` argument is basically [semantic versioning](http://semver.org) for tool arguments.

	So now instead of this:

		mogenerator --model MyDataModel.xcdatamodeld \
			--template-var arc=true \
			--template-var literals=true \
			--template-var modules=true

	You can write this:

		mogenerator --v2 --model MyDataModel.xcdatamodeld

	Internally these invocations are equivalent, but new scripts and manual invocations should use the `--v2` variant.

	I recommend putting the `--v2` in front of the rest of the arguments to call attention to the versioned context of the following arguments.

	This mechanism should allow mogenerator to continue to supply sensible defaults into the future as well. Perhaps `--v3` will generate Swift by default. Speaking of which…

* [NEW] Experimental Swift code generation. Unfortunately basic Core Data functionality ([to-one relationships](http://stackoverflow.com/q/24688969/5260)) is broken on 10.9, but we can still try writing theoretically-correct Swift code. Perhaps a future version of mogenerator will supply the needed work-around code for you.  ([Alexsander Akers](https://github.com/rentzsch/mogenerator/pull/203), [afrederick1](https://github.com/rentzsch/mogenerator/pull/209), [Piet Brauer](https://github.com/rentzsch/mogenerator/pull/215), [rentzsch](https://github.com/rentzsch/mogenerator/commit/b7c029c43384c6aa0455605e7d253a4ff60e1c10), [Chris Weber](https://github.com/rentzsch/mogenerator/pull/234), [Markus Chmelar](https://github.com/rentzsch/mogenerator/pull/237), [Brent Royal-Gordon](https://github.com/rentzsch/mogenerator/pull/247))

* [NEW] Ordered relationships actually work. [OMG](https://twitter.com/rentzsch/status/281816512489218048). I have them working in a new separate OS X test app, even though [mogenerator's test dir](https://github.com/rentzsch/mogenerator/tree/master/test) fails. I still haven't figured out why, but I'm not holding this back. ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/140), [Joshua Greene](https://github.com/rentzsch/mogenerator/commit/a971c391b7f720f30934de439519bd3ecda4d453), [Dave Wood](https://github.com/rentzsch/mogenerator/commit/6a5f27b68c70b3b7688cb02c6a4c957c49baba17), [Jonathan del Strother](https://github.com/rentzsch/mogenerator/pull/231))

* [NEW] Custom scalar types. Specify `attributeValueScalarType` for the name of the property's custom type and `additionalHeaderFileName` if you need to bring in an additional header file for compilation. With this, mogenerator supports C-style and [JREnum](https://github.com/rentzsch/JREnum)-style enums. ([Quentin ARNAULT](https://github.com/rentzsch/mogenerator/commit/43eff6a69098747d95417ed4f5f7b5e686504473))

* [NEW] Remove unnecessary empty lines in the generated files. ([Stephan Michels](https://github.com/rentzsch/mogenerator/pull/184))

* [NEW] Ability to forward-declare `@protocol`s for i.e. transformable types. Specify them via a comma delimited string in the entity's user info under the `attributeTransformableProtocols` key. ([Renaud Tircher](https://github.com/rentzsch/mogenerator/pull/147))

* [NEW] Generate `*UserInfo` key/value pairs as const structs. ([Jeremy Foo](https://github.com/rentzsch/mogenerator/pull/131), [rentzsch](https://github.com/rentzsch/mogenerator/issues/158))

* [NEW] `--template-var literals` which, when enabled, generates Obj-C literals. ([Brandon Williams](https://github.com/rentzsch/mogenerator/commit/fc6537d97f187121a38ddfe85c52796c8a3be2d0), [Thomas van der Heijden](https://github.com/rentzsch/mogenerator/commit/8b203a03fc4456b28087c7f3e0dc4d7637a89cdc), [rentzsch](https://github.com/rentzsch/mogenerator/commit/63d2ac2ee30cd59db126302eb5f46fb99fe6d460))

* [NEW] Specify `--template-var modules=true` option to avoid `treating #import as an import of module 'CoreData' [-Wauto-import]" warning`. ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/194))

* [NEW] Unsigned integers are generated when a property's minimum is set to `0` in the Xcode modeler. ([Dan Pourhadi](https://github.com/rentzsch/mogenerator/commit/e70cab5bf1a721831e43cb756778ee8825f1e011))

* [NEW] Add support for setting command-line options via a JSON config file. ([Simon Whitaker](https://github.com/rentzsch/mogenerator/pull/163))

* [NEW] Add CONTRIBUTING.md file. It's now even easier to contribute to mogenerator :) ([rentzsch](https://github.com/rentzsch/mogenerator/commit/e8a05a3161be2a25cb072041936196c28dbdda07))

* [NEW] Add MIT LICENSE file to make it clear templates are under the same license. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/b8b57d1d88d59680c932096eb27d327b7324f56d))

* [CHANGE] Suppress generation of `-setPrimativeType:` method. [issue 16](https://github.com/rentzsch/mogenerator/issues/16). ([rentzsch](https://github.com/rentzsch/mogenerator/commit/cd9809de0ec266995069c4350feb0bf78ebc6795))

* [CHANGE] Add a warning when skipping an attribute named 'type'. ([Simon Whitaker](https://github.com/rentzsch/mogenerator/pull/165))

* [CHANGE] Add explicit `atomic` to sooth `-Weverything`. ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/153))

* [CHANGE] iOS 8 changes objectID from a getter into a property, resulting in a warning. Templates updated to match. ([Ryan Johnson](https://github.com/rentzsch/mogenerator/pull/201))

* [FIX] Support newly-created models when `--model=*.xcdatamodeld`. [issue 137](https://github.com/rentzsch/mogenerator/issues/137). ([Sergey](https://github.com/rentzsch/mogenerator/pull/138))

* [FIX] Minor warning fix, 64->32 truncation, format strings. ([Sean M](https://github.com/rentzsch/mogenerator/pull/141))

* [FIX] Machine headers always `#import`s their superentity if present. ([David Aspinall](https://github.com/rentzsch/mogenerator/pull/136))

* [FIX] Fetch requests whose predicate LHS specifies a relationship. [issue 15](https://github.com/rentzsch/mogenerator/issues/15). ([rentzsch](https://github.com/rentzsch/mogenerator/commit/54ddfa5b39c89a99d4457cb0edd0f817096fcf36))

* [FIX] Don't emit empty `*UserInfo` structs. (Jeremy Foo [1](https://github.com/rentzsch/mogenerator/commit/8281ff332cd222ccbb84f94c02908c3cd8df0234) [2](https://github.com/rentzsch/mogenerator/commit/4ca4405a28cbb17055dc8d0bfc6bc2fe60c426ed#diff-d41d8cd98f00b204e9800998ecf8427e))

* [FIX] Don't emit empty `*Attributes`, `*Relationships`, and `*FetchedProperties` structs. ([Daniel Tull](https://github.com/rentzsch/mogenerator/commit/54e8c1015d353977ecd4a9d2bb78b06185c61ee9))

* [FIX] MOIDs subclass their superentity (instead of just always inheriting from `NSManagedObject`). ([Daniel Tull](https://github.com/rentzsch/mogenerator/commit/5f03745bca72588a0880d0333fa86ac623d8a1f9))

* [FIX] Don't touch aggregate include files if the content didn't change. ([Stephan Michels](https://github.com/rentzsch/mogenerator/pull/148))

* [FIX] Don't attempt to `#import "NSManagedObject.h"` even in the face of weird (corrupted?) model files. [issue 42](https://github.com/rentzsch/mogenerator/issues/42). ([rentzsch](https://github.com/rentzsch/mogenerator/commit/3e6074814c4e6655c26469c01adeb3d0aafa9ddb))

* [TEST] Escape spaces in mogenerator build path. ([Daniel Tull](https://github.com/rentzsch/mogenerator/issues/151))



### v1.27: Mon Nov 12 2012 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.27.dmg)

* [NEW] You can now pass .xcdatamodeld paths to mogenerator. mogenerator will look inside the directory, read its hidden `.xccurrentversion` file and use the "current" .xcdatamodel file. ([Alexander Zats](https://github.com/rentzsch/mogenerator/pull/102))

* [NEW] Replaced mogenerator's previous testing system (the test mule) with a new Rakefile-based system that eases building & testing from the current source tree and tests both MRC and ARC. ([rentzsch](https://github.com/rentzsch/mogenerator/blob/master/test/Test%20README.markdown))

* [NEW] Property declarations generated from attributes can now be qualified as readonly by adding a `mogenerator.readonly` to an attribute's userinfo. ([crispinb](https://github.com/rentzsch/mogenerator/pull/111))

* [NEW] `--configuration` option that limits generation to the specified configuration. ([Sixten Otto](https://github.com/rentzsch/mogenerator/pull/104))

* [NEW] `--base-class-import` option for fine-grained control of base class import statements. ([David Aspinall](https://github.com/rentzsch/mogenerator/pull/135))

* [CHANGE] Optimized `keyPathsForValuesAffectingValueForKey:` generated code (returns after first match). ([Sean M](https://github.com/rentzsch/mogenerator/issues/98))

* [CHANGE] Add default private class extension to human source template. ([Jonas Schnelli](https://github.com/rentzsch/mogenerator/pull/95))

* [FIX] Align generated code's pointer asterisks more consistently. ([Tony Arnold](https://github.com/rentzsch/mogenerator/pull/103))

* [FIX] Missing import when using mogenerator.customBaseClass entity userinfo key. ([Thomas Guthrie](https://github.com/rentzsch/mogenerator/pull/109))

* [FIX] Handle case in generated fetch request wrapper machine code when predicate variables are repeated. ([Sergei Winitzki](https://github.com/rentzsch/mogenerator/pull/125))

* [FIX] Explicitly set mogenerator project's deployment target to 10.6 to avoid segfaulting on 10.8 for some reason. [issue 121](https://github.com/rentzsch/mogenerator/issues/121) (reported by Sixten Otto, diagnosed by Florian Bürger)

* [FIX] Cast to unsigned in machine source to avoid clang format string warning. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/82dca52d3fa8082163931141b4e8257f8be8191c))

* [FIX] Don't attempt to report errors through -[NSApp reportError:] in generated machine source unless targeting AppKit. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/0f4d8295e98832f5acdab8d24d3193a1141839a8))

* [WORKAROUND] Recent versions of Xcode use an empty string to mark entities that do not have a custom subclass. ([Matthias Bauch](https://github.com/rentzsch/mogenerator/pull/132))

* [CHANGE] make_installer.command: assume PackageMaker now lives in /Applications/Utilities. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/aa4d3d5ba274985bd0a9f636efb0c5c82ce33381))



### v1.26: Thu Apr 12 2012 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.26.dmg)

* [FIX] Missing space in transformable attribute codegen. [issue 89](https://github.com/rentzsch/mogenerator/issues/89) ([Daniel Tull](https://github.com/rentzsch/mogenerator/issues/89), [Kris Markel](https://github.com/rentzsch/mogenerator/pull/99), [Whitney Young](https://github.com/rentzsch/mogenerator/pull/101))

* [NEW] mogenerator's standard templates are now bundled into the mogenerator binary itself. This should solve the problem of templates growing out of sync with the intended version of mogenerator ([exacerbated](https://github.com/rentzsch/mogenerator/issues/93#issuecomment-4059248) by the now-popular homebrew installer). You can still use your own templates with the `--template-path` and `--template-group` parameters. [issue 79](https://github.com/rentzsch/mogenerator/pull/79) (Ingvar Nedrebo, rentzsch).

* [NEW] Support for per-entity custom base classes, set via `mogenerator.customBaseClass` key in the entity's user info. ([Trevor Squires](https://github.com/rentzsch/mogenerator/pull/94))

* [CHANGE] mogenerator installer no longer installs separate template files (but it won't touch those already installed).

* [CHANGE] mogenerator's .pkg installer no longer includes Xmo'd since 1) Xmo'd doesn't work with Xcode 4 yet and 2) Xcode.app now lives in /Applications, so the installer needs to get smarter to cope.



### v1.25: Thu Feb 16 2012 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.25.dmg)

* [NEW] Support for Xcode 4.3 and it's relocation of `momc` into its bundle. Only supports /Applications/Xcode.app for now. ([Matt McGlincy](https://github.com/rentzsch/mogenerator/pull/90))

* [CHANGE] Now generates size-specific scalar types (`int16_t`, `int32_t`, `int64_t`) instead of size-variable types (`short`, `int`, `long long`). [bug 2](https://github.com/rentzsch/mogenerator/issues/2) ([Rob Rix](https://github.com/rentzsch/mogenerator/pull/86))

* [NEW] Can now generate `NSFetchedResultsController` creation code for to-many relationships (use `--template-var frc=true`). ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/88))

* [DOC] Link to John Blanco's [Getting Started with Mogenerator](http://raptureinvenice.com/getting-started-with-mogenerator/).



### v1.24: Wed Dec 6 2011 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.24.dmg)

* [FIX] Was incorrectly using `-mutableSetValueForKey:` for ordered relationships instead of `-mutableOrderedSetValueForKey:`. [bug 75](https://github.com/rentzsch/mogenerator/issues/75) ([Martin Schürrer](https://github.com/rentzsch/mogenerator/pull/66))

* [NEW] Now generates [Mike Ash-style constant structures](http://www.mikeash.com/pyblog/friday-qa-2011-08-19-namespaced-constants-and-functions.html) for attributes, relationships and fetched properties. This allows you to write code like `[obj valueForKey:PersonMOAttributes.age]`. Tip: you'll need to enable ARC generation  (`--template-var arc=true`) if you're using ARC. ([Daniel Tull](https://github.com/rentzsch/mogenerator/pull/72))

* [NEW] `--base-class-force` option, for specifying a base class even if the model file's entities don't specify one. ([Joe Carroll](https://github.com/rentzsch/mogenerator/pull/71))

* [NEW] PONSO: NSSet-based templates, improved inverse relationship logic and plug memory leak. ([Tyrone Trevorrow](https://github.com/rentzsch/mogenerator/pull/68))

* [FIX] PONSO: Added import for super entity in machine headers. ([Tyrone Trevorrow](https://github.com/rentzsch/mogenerator/pull/67))

* [FIX] Migrate from deprecated `-[NSString initWithContentsOfFile:]` and fix a MiscMerge warning where an immutable object was assigned to a mutable ivar. ([Joshua Smith](https://github.com/rentzsch/mogenerator/pull/76))

### v1.23: Sun Jul 10 2011 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.23.dmg)

* [NEW] Support for Mac OS X 10.7 Lion's ordered relationships (generated relationship code uses `NSOrderedSet` and `NSMutableOrderedSet`). (rentzsch [1](https://github.com/rentzsch/mogenerator/commit/4e9a045dcbf5af2eefed2ca9cb5fbac8394f9df2) [2](https://github.com/rentzsch/mogenerator/commit/a716c87b88b4614520175694d6e910bd38114602) [3](https://github.com/rentzsch/mogenerator/commit/932c4b382ab086faf76e167d3051bafa087321ae))

* [NEW] Optional support for ARC: pass `--template-var arc=true` to mogenerator. [bug 63](https://github.com/rentzsch/mogenerator/issues/63) ([Adam Cox](https://github.com/rentzsch/mogenerator/pull/64))

* [NEW] New template that dumps a binary .xcdatamodel into a pseudo-ASCII-plist format perfect for diffing. A great way to compare two versions of a data model. ([Brian Webster](https://github.com/rentzsch/mogenerator/pull/61))

* [NEW] Attributes and relationships are now sorted for generation. This should eliminate spurious changes to source files when unrelated model entities are changed. After upgrading to 1.23 you probably want to regenerate all your source files without a model change, just to let things settle in before your next real model change. ([Nikita Zhuk](https://github.com/nzhuk/mogenerator/commit/61450726028585633b93274269eb5c77c7b5c83e))

* [NEW] Support for generation of PONSOs: Plain Old NSObjects. These are in-memory, typesafe non-CoreData classes generated from your Xcode data models. Generate reams of ObjC classes from a single data model. Supports relationships and basic serialization. See `contributed templates/Nikita Zhuk/ponso/README.txt` for details. ([Nikita Zhuk](https://github.com/rentzsch/mogenerator/pull/60))

* [NEW] Support for `momc` error-reporting options: `MOMC_NO_WARNINGS`, `MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS` and  `MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR`. ([Nikita Zhuk](https://github.com/nzhuk/mogenerator/commit/96786d4caf78ea6988ac430191e555350ca468c5))

* [NEW] Now generates output directories if they don't already exist or presents an error message if they cannot be created. ([Scott Little](https://github.com/rentzsch/mogenerator/pull/51))

* [CHANGE] Change `#include` to `#import` in `include.m`. ([Zac Bowling](https://github.com/rentzsch/mogenerator/pull/59))

* [NEW] You can now use `--template-var` to pass arbitrary command-line options through to templates. ([Adam Cox](https://github.com/rentzsch/mogenerator/pull/64))

* [NEW] Update MiscMerge to NS(U)Integer for 64-bit compatibility. ([Nikita Zhuk](https://github.com/nzhuk/mogenerator/commit/a4aa3b943285fd5aaece9a417c5d36d3d1723127))

* [FIX] Memory leaks in MiscMerge. ([Nikita Zhuk](https://github.com/nzhuk/mogenerator/commit/4716a9c43e656ea2fc38e3d9096b8e2f273de109))

* [CHANGE] mogeneratorTestMule's `mogenerate.command` upgraded to use double-dash option names. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/b78d7611dc8819782541fe65e50050173a040d92))

* [FIX] Set mogeneratorTestMule's `mogenerate.command` executable bit. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/83182682d39c3b1f96ac28df5a3ae326418dbfe8))



### v1.22: Wed Mar 2 2011 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.22.dmg)

* [FIX] Xmo'd 1.21 introduced a bug where it would no longer create a source folder for your data model (it would work fine it one already existed). [bug 43](https://github.com/rentzsch/mogenerator/issues/43) ([rentzsch](https://github.com/rentzsch/mogenerator/commit/462a485f0686b44fbaabad875ee8a21e3e0f61bc))

* [NEW] `-keyPathsForValuesAffectingValueForKey:` is now generated in machine.m files, populated by your entity's scalar attributes. The idea is code like `myObject.myIntAttributeValue++` tells Core Data that `myIntAttribute` has changed (handy when you're KVO-observing `myIntAttribute`). ([Tony Arnold](https://github.com/rentzsch/mogenerator/commit/fdc4a02c2180493d24a68fddc98ddd35b1fc1277))

* [NEW] When a model file has multiple versions (`.xcdatamodeld` files) Xmo'd now uses the "current" version of the model (set the "xmod" command on the xcdatamodeld group). ([Vincent Guerci](https://github.com/rentzsch/mogenerator/commit/09b0d8ea40688fef7780f8bb99ba797bc0e81aaf))

* [NEW] Support [undefined attribute types](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreData/Articles/cdNSAttributes.html%23//apple_ref/doc/uid/TP40001919-SW12). ([Brian Doig](https://github.com/rentzsch/mogenerator/commit/12298a8d622321c211839d6016bce72f7fcf8d59))

* [NEW] mogenerator and Xmo'd now supports model-relative paths for the `--template-path` argument. ([tonklon](https://github.com/rentzsch/mogenerator/commit/fff9f12a15186877e780cb01cc8a925cc59768cf))



### v1.21: Mon Nov 1 2010 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.21.dmg)

* [NEW] Machine templates now include fetched properties by default. ([Jonathan del Strother](http://github.com/rentzsch/mogenerator/commit/d0f28ab3354af852d3470adccaf392fbd7c6129c))

* [NEW] Xmo'd: better support for `--(machine|human|output)-dir` model option path: now they can be full or relative to the model file. Xcode group and file references are no longer deleted/re-added with every save. ([John Turnipseed](http://github.com/rentzsch/mogenerator/commit/0894c56ed471b4c5d0d30cb312f1d8970a0dd216))

* [NEW] Xmo'd: `--log-command` model option. When enabled, Xmo'd will log (to Console.app) the generated+executed `mogenerator` invocation. Good for automation debugging and also can provide training wheels for using mogenerator directly. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/9d7101c774d71f82da68f2ef91982e9a8f956ebb))

* [FIX] Avoid `nil` substitution dictionary in generated fetch request wrapper code, which resulted in an `NSInvalidArgumentException` reason "Cannot substitute a nil substitution dictionary." ([Anthony Mittaz](http://github.com/rentzsch/mogenerator/commit/03d005036bb6bfa6a7c88d3d3ac7e877d48eea61))



### v1.20: Thu Aug 12 2010 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.20.dmg)

* [NEW] Xmo'd: model comments that start with `--` are passed as args to mogenerator. This allows accessing command-line options such as `--base-class`. ([David LeBer](http://github.com/rentzsch/mogenerator/commit/5c0c3790d0b872962391abffc7ea82d9b643d0f1))

* [NEW] Forward-declare transformable attribute class types. [bug 11](http://github.com/rentzsch/mogenerator/issues/issue/11) ([seanm](http://github.com/rentzsch/mogenerator/commit/f711fc5705e8891b41ce0364b24ff495db1a4856))

* [CHANGE] Generated accessors that return `BOOL`s now return `NO` instead of `0`, avoiding LLVM Static Analyzer warnings. [bug 8](http://github.com/rentzsch/mogenerator/issues/issue/8) ([seanm](http://github.com/rentzsch/mogenerator/commit/f711fc5705e8891b41ce0364b24ff495db1a4856))

* [CHANGE] Generated value accessors that return `int`s no longer needlessly check for nil. [bug 10](http://github.com/rentzsch/mogenerator/issues/issue/10) ([seanm](http://github.com/rentzsch/mogenerator/commit/f711fc5705e8891b41ce0364b24ff495db1a4856))

* [CHANGE] LLVM 2/Xcode 4 doesn't like `[NSDictionary dictionaryWithObjectsAndKeys:nil]`, issuing a "missing sentinel in method dispatch" warning. Add `hasBindings` to `prettyFetchRequests` so we can just generate `NSDictionary *substitutionVariables = nil` in that case. ([Anthony Mittaz](http://github.com/rentzsch/mogenerator/commit/8369f7108e3eb3d73e10583fe3f4248c914583c7))

* [FIX] Variable shadowing bug which would cause v1.19's `xcode-select` functionality to always fail. ([Nikita Zhuk](http://github.com/rentzsch/mogenerator/commit/93b4c6bfcde93701875174040e76ed192643bc87#commitcomment-108156))



### v1.19: Sun 4 Jul 2010 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.19.dmg)

* [NEW] Use `xcode-select` to dynamically discover our way to `momc` instead of only hard-coding `/Developer`. ([Josh Abernathy](http://github.com/rentzsch/mogenerator/commit/93b4c6bfcde93701875174040e76ed192643bc87))



### v1.18: Thu 1 Jul 2010 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.18.dmg)

* [NEW] Xmo'd works with versioned data models. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/5195153e8ffce08eb82a63c8fde6aea20b0e6d34))

* [NEW] Support for fetched properties ([Nikita Zhuk](http://github.com/rentzsch/mogenerator/commit/7481add810ef798c0f678d782d7d8fb9e6ff4d46))

* [NEW] `NSParameterAssert(moc)` in fetch request wrappers. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/015aa0bec7dae21058c057bfa6b4f6748e444e00))



### v1.17: Sat 27 Mar 2010 [download](http://github.com/downloads/rentzsch/mogenerator/mogenerator-1.17.dmg)

* [NEW] `+[Machine entityName]` (for [@drance](http://twitter.com/drance/status/11157708725)) and `+[Machine entityInManagedObjectContext:]` ([Michael Dales](http://github.com/rentzsch/mogenerator/commit/8902305650c68d7ba7550acb7f3c21ce42c02d93)).

* [NEW] `--list-source-files` option, which lists model-related source files. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/19fe5be5d9c0e13721cda4cdb18f8209222657f6))

* [NEW] Add `--orphaned` option. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/b64370f7532bcaf709fc8e0da8561306fa09a412))

Couple `--orphaned` with `--model` to get a listing of source files that no longer have corresponding entities in the model. The intent is to be able to pipe its output to xargs + git to remove deleted and renamed entities in one command, something like:

	$ mogenerator --model ../MyModel.xcdatamodel --orphaned | xargs git rm



### v1.16: Mon 4 Jan 2010 [download](http://cloud.github.com/downloads/rentzsch/mogenerator/mogenerator-1.16.dmg)

* [NEW] machine.h template now produces type-safe scalar attribute property declarations. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/b56ec4aebe0146b7c4258111274fb4a4fbb3e01e))

* [CHANGE] Remove machine.m implementations of to-many relationship setters. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/665a8d65a54f3fc95b8ffff8ec6ef708634b7baa))

* [CHANGE] Xmo'd: change file ordering to human.m, human.h, machine.m, machine.h (from human.h, human.m, machine.h, machine.m). ([rentzsch](http://github.com/rentzsch/mogenerator/commit/fb7eb172817b1bee7e4a5448b4250aa2b5cdeb8a))

* [FIX] Missing space for fetch requests with multiple bindings. ([Frederik Seiffert](http://github.com/rentzsch/mogenerator/commit/f54e32b9cee29ef8b908704874f2112c320e4f1f))



### v1.15: Mon 2 Nov 2009 [download](http://cloud.github.com/downloads/rentzsch/mogenerator/mogenerator-1.15.dmg)

* [CHANGE] Xmo'd: now adds `.h` human+machine header files to project (in addition
to current `.m` + `.mm` files). ([rentzsch](http://github.com/rentzsch/mogenerator/commit/5c88445e366b15d4a4700b7f9a10a6915ff6b20b))

* [NEW] Now supports key paths in fetch request predicates so long as they're relationships. ([Jon Olson](http://github.com/rentzsch/mogenerator/commit/6bd8051a70d32fe73c1965cb449d2f40d403260a))

* [FIX] Log fetch-request-wrapper errors to `NSLog()` on iPhone since it lacks `-[NSApp presentError:]`. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/4a834281da07af799206db5099a077fa28721742))

* [NEW] `+insertInManagedObjectContext:` `NSParameterAssert()`'s its `moc` arg. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/5ff20395ccdcde12955483046ee30ed215d3b920))



### v1.14: Fri 9 Oct 2009 [download](http://cloud.github.com/downloads/rentzsch/mogenerator/mogenerator-1.14.dmg)

* **IMPORTANT:** 1.14 generates code that may be incompatible with clients of 1.13-or-earlier generated code. `+newInManagedObjectContext:` has been replaced with `+insertInManagedObjectContext:` and method implementations have been replaced with `@dynamic`, which don't work so well with overriding (most of these uses can be replaced with Cocoa Bindings). Upgrade only if you have spare cycles to fix-up existing projects.

* [CHANGE] changed `+newInManagedObjectContext:` to `+insertInManagedObjectContext:` to satisfy the LLVM/clang static analyser. ([Ruotger Skupin](http://github.com/rentzsch/mogenerator/commit/25ad62d15a21e4ef855f5eb80bee32182a3ad6f4))

* [CHANGE] Default machine templates now use @dynamic. The old templates still available in ` contributed templates/rentzsch non-dynamic`. ([Pierre Bernard](http://github.com/rentzsch/mogenerator/commit/68e73da2be59f0ae3e60e32a45986aa7b9651a3c))

* [CHANGE] Xmo'd included again in default mogenerator installation -- the first time since 1.6. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/c092a17734157a9976505bc94744bf0a90432dd7))

* [CHANGE] Migrated project to github from self-hosted svn+trac installation.

* [NEW] Xmo'd version checking whitelists Xcode versions 3.1(.x) and 3.2(.x).

* [NEW] Dropped ppc support for Xmo'd. May reconsider if folks yelp. ([rentzsch](http://github.com/rentzsch/mogenerator/commit/c6d0ef3fa308c7b1095daaa5364e1c944a772d2e))
