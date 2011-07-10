#mogenerator + Xmo'd

Visit the [project's pretty homepage](http://rentzsch.github.com/mogenerator).

Here's mogenerator's elevator pitch:

> `mogenerator` is a command-line tool that, given an `.xcdatamodel` file, will generate *two classes per entity*. The first class, `_MyEntity`, is intended solely for machine consumption and will be continuously overwritten to stay in sync with your data model. The second class, `MyEntity`, subclasses `_MyEntity`, won't ever be overwritten and is a great place to put your custom logic.

## Using mogenerator

Senseful wrote up a [nice summary of mogenerator's command-line options](http://stackoverflow.com/questions/3589247/how-do-the-mogenerator-parameters-work-which-can-i-send-via-xcode).

## Using Xmo'd

Xmo'd (pronounced *ex-mowed*) is an Xcode plugin that integrates mogenerator into Xcode. It saves you the hassle of having to write a *Run Script Build Phase* and/or manually adding+removing source files from your project as you add+remove entities.

Xmo'd works by noticing when your `*.xcdatamodel` is saved. If the model file's Xcode project item comment contains `xmod`, an AppleScript is fired that creates a folder based on your model's file name and populates it with derived source code files from your model. It then adds the new folder to your project as a Group Reference and adds all the source files to your project.

## Version History

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