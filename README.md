# mogenerator <a href="https://travis-ci.org/rentzsch/mogenerator"><img src="https://travis-ci.org/rentzsch/mogenerator.svg?branch=master"></a>

Visit the [project's pretty homepage](http://rentzsch.github.com/mogenerator).

Here's mogenerator's elevator pitch:

> `mogenerator` is a command-line tool that, given an `.xcdatamodel` file, will generate *two classes per entity*. The first class, `_MyEntity`, is intended solely for machine consumption and will be continuously overwritten to stay in sync with your data model. The second class, `MyEntity`, subclasses `_MyEntity`, won't ever be overwritten and is a great place to put your custom logic.

Want more detail? John Blanco has authored a [detailed writeup about mogenerator](http://raptureinvenice.com/getting-started-with-mogenerator/).

## Using mogenerator

Senseful wrote up a [nice summary of mogenerator's command-line options](http://stackoverflow.com/questions/3589247/how-do-the-mogenerator-parameters-work-which-can-i-send-via-xcode).

## Version History

### v1.32: Wed Jun 20 2018
* [NEW] Support for URL and UUID property types ([protocool](https://github.com/tomekc/mogenerator/pull/1), [original PR](https://github.com/rentzsch/mogenerator/pull/370))

### v1.31: Mon Oct 3 2016 [download](https://github.com/rentzsch/mogenerator/releases/download/1.31/mogenerator-1.31.dmg)

* [NEW] Swift 3 support. ([Goncharov Vladimir](https://github.com/rentzsch/mogenerator/pull/347), [Hardik](https://github.com/rentzsch/mogenerator/pull/349), [rentzsch](https://github.com/rentzsch/mogenerator/commit/a65f6421baf39dc1458f22836907cfc55fc8ceb1))

* [CHANGE] Add nullability to the primitive value. ([Tom Carey](https://github.com/rentzsch/mogenerator/pull/343))

* [CHANGE] Allow for nullable collection properties. ([Ibrahim Sha'ath](https://github.com/rentzsch/mogenerator/pull/338))

* [CHANGE] Mark `+entityInManagedObjectContext:` nullable. ([Ibrahim Sha'ath](https://github.com/rentzsch/mogenerator/pull/337))

* [DOC] Update link to Apple's Core Data Programming Guide. ([Brian Schrader](https://github.com/rentzsch/mogenerator/pull/341))

* [FIX] Syntax error in Objective-C templates. ([Dave Wood](https://github.com/rentzsch/mogenerator/pull/345))

* [TEST] Add Parent.orderedChildren ordered relationship. ([rentzsch](https://github.com/rentzsch/mogenerator/commit/b5c68ff538ed8a77e43524d846a5ac89793662ca))


Further history is listed in the [Version History](Version-History.md) file.