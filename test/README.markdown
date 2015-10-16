Welcome to mogenerator's Test Dir
=================================

This directory exists to test mogenerator's operation and catch regressions. It's especially handy for ensuring correct operation of obscure features.

How to Use
----------

If you're contributing to mogenerator, please ensure tests pass prior to issuing a Pull Request. It's easy:

	$ cd mogenerator/test
	$ rake
	*** Clean-building mogenerator
	*** Testing MRC
	success
	*** Testing ARC
	success

`test/Rakefile` does the hard work of building mogenerator from source (via `xcodebuild`) and exercising it against the test.xcmodeld data model. It ensures:

1. mogenerator can be built from source.
2. You're using the latest source tree templates (so template errors fail immediately).
3. mogenerator can read the test.xcmodeld file.
4. mogenerator can generate source files from the model.
5. Generated source files are compilable.
6. A small but real program can use the generated classes to create managed objects, modify their attributes, hook up relationships and save them to an in-memory store.

It does this for both MRC and ARC modes.

*Note:* if you encounter an error like this:

	$ rake
	*** Clean-building mogenerator
	xcodebuild: error: The project 'mogenerator' does not contain a scheme named 'mogenerator'.
	rake aborted!
	ERROR: xcodebuild -project ../mogenerator.xcodeproj -scheme mogenerator clean failed
	/Users/wolf/Downloads/mogenerator/test/Rakefile:4:in `run_or_die'
	/Users/wolf/Downloads/mogenerator/test/Rakefile:11:in `<top (required)>'
	(See full trace by running task with --trace)

Try opening mogenerator.xcodeproj in Xcode, closing the project and try again. That should "fix" it. *sigh*

Points of Highlight
-------------------

* Unlike the old Test Mule, the Rakefile should cleanup after itself unless something goes horribly wrong (no more checking-in differently-generated source files). It probably could be made to clean after itself even when things go wrong, but my Rakefile-fu is too weak to figure out how and it's handy to have files laying about when things do go wrong for debugging.

* ParentMO has an attribute for each attribute type Core Data supports, exercising Core Data type => Objective-C type translation (and NSNumber-boxing code generation).

* ParentMO and ChildMO are both subclasses of HumanMO, exercising inheritance.

* A number of model-defined fetch requests, exercising codegen for a number of scenarios:

	* HumanMO.allHumans, whose empty predicates results in code that should fetch all HumanMOs.

	* HumanMO.byHumanName, whose predicate includes a substitution variable `$humanName` which gets translated into a parameter in the fetch request wrapper's method name.

	* HumanMO.oneByHumanName, which is like HumanMO.byHumanName but whose wrapper ensures only zero or one objects result from a fetch. If more are returned, and detailed error is logged and nil is returned.

	* ChildMO.byParent, whose predicate includes a substitution variable `$parent` representing a relationship (with its own destination class) instead of an attribute.

* The Rakefile and test.m exercise mogenerator's `--baseClass` option, passing MyBaseClass. MyBaseClass defines an ivar (uncreatively named `ivar`) and accessors, which should be accessible to all model-defined classes.

* The Rakefile overwrites the default (empty) generated MOs/HumanMO.hm files with the one in the base test directory to simulate persistence of Human code (since the MOs directory is recursively deleted after each task).

* Say you want to store an object not directly supported by Core Data (NSColor is a popular example). HumanMO.hairColor/hairColorStorage illustrates the old way to do it requiring Human code support. ParentMO.myTransformableWithClassName illustrates the 10.5+ way to do it with Core Data's NSValueTransformer support.

  mogenerator supports both ways, but the newer NSValueTransformer way is better since it's directly supported and centralizes data <=> marshalling to one class. mogenerator sweetens the pot by allowing you to define the name of the class after it's been transformed (via the `attributeValueClassName` attribute user info key-value).