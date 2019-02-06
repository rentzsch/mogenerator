# mogenerator <a href="https://travis-ci.org/rentzsch/mogenerator"><img src="https://travis-ci.org/rentzsch/mogenerator.svg?branch=master"></a>

Visit the [project's pretty homepage](http://rentzsch.github.com/mogenerator).

Here's mogenerator's elevator pitch:

> `mogenerator` is a command-line tool that, given an `.xcdatamodel` file, will generate *two classes per entity*. The first class, `_MyEntity`, is intended solely for machine consumption and will be continuously overwritten to stay in sync with your data model. The second class, `MyEntity`, subclasses `_MyEntity`, won't ever be overwritten and is a great place to put your custom logic.

Want more detail? John Blanco has authored a [detailed writeup about mogenerator](http://raptureinvenice.com/getting-started-with-mogenerator/).

## Using mogenerator

Senseful wrote up a [nice summary of mogenerator's command-line options](http://stackoverflow.com/questions/3589247/how-do-the-mogenerator-parameters-work-which-can-i-send-via-xcode).

## Version History

### v1.32: Wed Jan 30 2019 [download](https://github.com/rentzsch/mogenerator/releases/tag/1.32)

* [NEW] Support for URL and UUID property types ([Trevor Squires](https://github.com/tomekc/mogenerator/pull/1), [original PR](https://github.com/rentzsch/mogenerator/pull/370))

* [NEW] Add support for "Uses Scalar Type" ([Rok Gregorič](https://github.com/rokgregoric), [original PR](https://github.com/rentzsch/mogenerator/pull/352))

* [NEW] Add Swift generic `fetchRequest()` to generated code ([0xpablo](https://github.com/0xpablo), [original PR](https://github.com/rentzsch/mogenerator/pull/358))

* [NEW] Add nullability annotations for generated primitive accessors of optional, to-one relationships. ([Michael Babin](https://github.com/mbabin), [original PR](https://github.com/rentzsch/mogenerator/pull/363))

* [NEW] Expose allAttributes and allRelationships ([Trevor Squires](https://github.com/protocool), [original PR](https://github.com/rentzsch/mogenerator/pull/360))

* [NEW] Add template booleans to identify custom attribute type use. ([Aleksandar Vacić](https://github.com/radianttap), [original PR](https://github.com/rentzsch/mogenerator/pull/369))

* [NEW] Support "Custom Class" for Transformable attributes ([Tomek Cejner](https://github.com/tomekc), [commit](https://github.com/rentzsch/mogenerator/commit/3fd2a5aa8492db2c0036750d897e51d1df2a1e69))

* [NEW] Add parameter to ignore entities ([Martin Kim Dung-Pham](https://github.com/q231950), [original PR](https://github.com/rentzsch/mogenerator/pull/378))

* [CHANGE] Use `Data` instead of `NSData` with Swift ([Christopher Rogers](https://github.com/ChristopherRogers), [original PR](https://github.com/rentzsch/mogenerator/commit/64dbbbb1db72adadaf70b5de0228896c8fbcb5b7))

* [CHANGE] Dropped `.pkg` binary releases. mac OS 10.14 Mojave won't install unsigned pkgs by default any more, and I'm not paying Apple $100/year so I can distribute open source binaries. Use [Homebrew](https://brew.sh) to install and update mogenerator binaries. (rentzsch)

* [CHANGE] Travis updates ([Trevor Squires](https://github.com/protocool), [commit](https://github.com/rentzsch/mogenerator/commit/e347643f72fa045333145d4b5af16716ae7df463), [commit](https://github.com/rentzsch/mogenerator/commit/b100abed5f5fb6083b2c486a18bdce125995c261))

* [FIX] Correct Swift machine template for singleton (fetchOne…) fetch request results. ([Warren Burton](https://github.com/warrenburton), [original PR](https://github.com/rentzsch/mogenerator/pull/359))



Further history is listed in the [Version History](Version-History.md) file.
