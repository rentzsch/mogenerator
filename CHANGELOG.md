# Change Log

## [Unreleased](https://github.com/rentzsch/mogenerator/tree/HEAD)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.28...HEAD)

**Closed issues:**

- How to roll-back to an older version? [\#282](https://github.com/rentzsch/mogenerator/issues/282)

- Commented out validateXXX funcs for swift are invalid [\#281](https://github.com/rentzsch/mogenerator/issues/281)

- Suggestion on class methods for Swift Gen. [\#271](https://github.com/rentzsch/mogenerator/issues/271)

- Swift Template: Default to NSDate? for date fields in the model. [\#263](https://github.com/rentzsch/mogenerator/issues/263)

- Override Keyword Specified On Class Functions When Using Base Class Switch [\#253](https://github.com/rentzsch/mogenerator/issues/253)

- New feature: generate constants for attributes keys [\#250](https://github.com/rentzsch/mogenerator/issues/250)

- After update to ios8 my app is crashed everytime... [\#249](https://github.com/rentzsch/mogenerator/issues/249)

- Add Prefix support for swift class names [\#233](https://github.com/rentzsch/mogenerator/issues/233)

- Skips -primitiveType and -setPrimitiveType: but still generates -primitiveTypeValue and -setPrimitiveTypeValue: [\#202](https://github.com/rentzsch/mogenerator/issues/202)

- Generate documentation using userInfo keys [\#192](https://github.com/rentzsch/mogenerator/issues/192)

- Release 1.28 [\#185](https://github.com/rentzsch/mogenerator/issues/185)

- Codesign pkg installer [\#179](https://github.com/rentzsch/mogenerator/issues/179)

**Merged pull requests:**

- Support for additionalHeaderFileName on Feature/swift12 [\#285](https://github.com/rentzsch/mogenerator/pull/285) ([leodasvacas](https://github.com/leodasvacas))

- Quote paths in test/Rakefile [\#283](https://github.com/rentzsch/mogenerator/pull/283) ([jonah-williams](https://github.com/jonah-williams))

- public entities, optional import of base class module, and various Swift 1.2 fixes [\#280](https://github.com/rentzsch/mogenerator/pull/280) ([dave256](https://github.com/dave256))

- Add documentation generation using the User Info keys [\#268](https://github.com/rentzsch/mogenerator/pull/268) ([danielctull](https://github.com/danielctull))

- Allow multiple devs on same machine to use mogenerator [\#255](https://github.com/rentzsch/mogenerator/pull/255) ([annard](https://github.com/annard))

- Use built-in model compiler instead of relying on Xcode [\#225](https://github.com/rentzsch/mogenerator/pull/225) ([atomicbird](https://github.com/atomicbird))

## [1.28](https://github.com/rentzsch/mogenerator/tree/1.28) (2014-09-11)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.27...1.28)

**Closed issues:**

- All of a sudden, can't find model file anymore [\#248](https://github.com/rentzsch/mogenerator/issues/248)

- Dots in variable name illegal [\#235](https://github.com/rentzsch/mogenerator/issues/235)

- Should numeric types be NSNumber for Swift? [\#224](https://github.com/rentzsch/mogenerator/issues/224)

- --base-class-import option not including \#import in generated files [\#220](https://github.com/rentzsch/mogenerator/issues/220)

- Devs surely want to use Swift templates now, but I can't figure out how. [\#217](https://github.com/rentzsch/mogenerator/issues/217)

- RHManagedObject [\#211](https://github.com/rentzsch/mogenerator/issues/211)

- String instead of NSString [\#205](https://github.com/rentzsch/mogenerator/issues/205)

- Mogenerator to generate Swift entity  [\#200](https://github.com/rentzsch/mogenerator/issues/200)

- No license terms publicly shown [\#186](https://github.com/rentzsch/mogenerator/issues/186)

- install error os x \(10.9\) [\#178](https://github.com/rentzsch/mogenerator/issues/178)

- mogenerator fails because of unrecognized selector send to String. [\#164](https://github.com/rentzsch/mogenerator/issues/164)

- Invalid UserInfo accessors generated. [\#158](https://github.com/rentzsch/mogenerator/issues/158)

- 1.28 release [\#157](https://github.com/rentzsch/mogenerator/issues/157)

- Brew formula SHA1 different to SHA1 of 1.27 tar ball [\#154](https://github.com/rentzsch/mogenerator/issues/154)

- Test fails if there is a space in the derived data path [\#151](https://github.com/rentzsch/mogenerator/issues/151)

- Template hooks, or option to insert "base class" before or after generated classes. [\#149](https://github.com/rentzsch/mogenerator/issues/149)

- Error reporting in generated classes/Mac OS command line app [\#143](https://github.com/rentzsch/mogenerator/issues/143)

- machine-generated class names should not start with underscores [\#142](https://github.com/rentzsch/mogenerator/issues/142)

- Versioned model doesn't work with only one version [\#137](https://github.com/rentzsch/mogenerator/issues/137)

- If there are no fetched properties then the generated code should not include a fetched properties struct [\#133](https://github.com/rentzsch/mogenerator/issues/133)

- Is it possible to create dynamic model at run time given xcdatamodel? [\#127](https://github.com/rentzsch/mogenerator/issues/127)

- Model classes are not generated [\#122](https://github.com/rentzsch/mogenerator/issues/122)

- Mock managed objects [\#117](https://github.com/rentzsch/mogenerator/issues/117)

- mogenerator updates modified date on files that do not change [\#116](https://github.com/rentzsch/mogenerator/issues/116)

- keyPathsForValuesAffectingValueForKey code should have 'else' statements [\#98](https://github.com/rentzsch/mogenerator/issues/98)

- Make new 1.24 Mike Ash-style constant structures optional [\#83](https://github.com/rentzsch/mogenerator/issues/83)

- Change \#import "\_XX.h" to \#import \<MyFramework/\_XX.h\> [\#82](https://github.com/rentzsch/mogenerator/issues/82)

- failed assertion 'relationship': fetch requests with substitution variables [\#15](https://github.com/rentzsch/mogenerator/issues/15)

- Rename +entityName ? [\#196](https://github.com/rentzsch/mogenerator/issues/196)

- Warnings for method collision [\#16](https://github.com/rentzsch/mogenerator/issues/16)

**Merged pull requests:**

- Update init\(entity:insert…\) override to match Beta 7 signature [\#247](https://github.com/rentzsch/mogenerator/pull/247) ([brentdax](https://github.com/brentdax))

- Added back to-many accessors \(swift template\). [\#242](https://github.com/rentzsch/mogenerator/pull/242) ([rokgregoric](https://github.com/rokgregoric))

- Make property optional only if to-one relationship marked as optional. [\#241](https://github.com/rentzsch/mogenerator/pull/241) ([rokgregoric](https://github.com/rokgregoric))

- Removed to-many accessors from swift template. \[\#227\] [\#239](https://github.com/rentzsch/mogenerator/pull/239) ([rokgregoric](https://github.com/rokgregoric))

- To-one relationships should be optional in swift. [\#238](https://github.com/rentzsch/mogenerator/pull/238) ([rokgregoric](https://github.com/rokgregoric))

- Explicitly comparing optionals with nil due to swift changes in beta 5 [\#237](https://github.com/rentzsch/mogenerator/pull/237) ([iv-mexx](https://github.com/iv-mexx))

- Added swift '?' mark for optional attributes [\#234](https://github.com/rentzsch/mogenerator/pull/234) ([webair](https://github.com/webair))

- Fix object type in replaceObjectInFooAtIndex:withObject: [\#231](https://github.com/rentzsch/mogenerator/pull/231) ([jdelStrother](https://github.com/jdelStrother))

- added override before the init in the machine.swift.motemplate [\#230](https://github.com/rentzsch/mogenerator/pull/230) ([rickw](https://github.com/rickw))

- v1.28 [\#216](https://github.com/rentzsch/mogenerator/pull/216) ([rentzsch](https://github.com/rentzsch))

- Fix swift template objc interoperability [\#215](https://github.com/rentzsch/mogenerator/pull/215) ([pietbrauer](https://github.com/pietbrauer))

- Added support for unsigned integers by setting an integer property's min... [\#214](https://github.com/rentzsch/mogenerator/pull/214) ([pourhadi](https://github.com/pourhadi))

- Add override to entityName function if this entity has a superentity [\#210](https://github.com/rentzsch/mogenerator/pull/210) ([afrederick1](https://github.com/afrederick1))

- Updated script to include swift templates and stop assertion in mogenerator.m:529 [\#209](https://github.com/rentzsch/mogenerator/pull/209) ([afrederick1](https://github.com/afrederick1))

- Fixed issue where a Swift style 'String' was being inserted instead of 'NSString' [\#206](https://github.com/rentzsch/mogenerator/pull/206) ([inquisitiveSoft](https://github.com/inquisitiveSoft))

- Some tweaks to the machine.swift.motemplate [\#204](https://github.com/rentzsch/mogenerator/pull/204) ([DaveWoodCom](https://github.com/DaveWoodCom))

- Add preliminary Swift support [\#203](https://github.com/rentzsch/mogenerator/pull/203) ([a2](https://github.com/a2))

- Fix for warnings in iOS 8 [\#201](https://github.com/rentzsch/mogenerator/pull/201) ([bismark](https://github.com/bismark))

- Use a template variable to support module @import syntax [\#194](https://github.com/rentzsch/mogenerator/pull/194) ([danielctull](https://github.com/danielctull))

- Remove unnecessary empty lines in the generated files. [\#184](https://github.com/rentzsch/mogenerator/pull/184) ([smic](https://github.com/smic))

- Use a template variable to support module @import syntax [\#183](https://github.com/rentzsch/mogenerator/pull/183) ([danielctull](https://github.com/danielctull))

- Added missing NSOrderedSet methods \(insert, remove, replace, etc\) [\#181](https://github.com/rentzsch/mogenerator/pull/181) ([JRG-Developer](https://github.com/JRG-Developer))

- Add a warning when skipping an attribute named 'type' [\#165](https://github.com/rentzsch/mogenerator/pull/165) ([simonwhitaker](https://github.com/simonwhitaker))

- Add support for setting command-line options via a JSON config file [\#163](https://github.com/rentzsch/mogenerator/pull/163) ([simonwhitaker](https://github.com/simonwhitaker))

- Update machine.m.motemplate to use objc literals \(with template-var\) [\#159](https://github.com/rentzsch/mogenerator/pull/159) ([batkuip](https://github.com/batkuip))

- Explicitly declare property atomic to resolve Xcode warning [\#153](https://github.com/rentzsch/mogenerator/pull/153) ([danielctull](https://github.com/danielctull))

- Escape spaces in the build mogen path, fixes \#151 [\#152](https://github.com/rentzsch/mogenerator/pull/152) ([danielctull](https://github.com/danielctull))

- A couple of fixes for compiler warnings [\#150](https://github.com/rentzsch/mogenerator/pull/150) ([danielctull](https://github.com/danielctull))

- Don't touch aggregate include file if the content doesn't change. [\#148](https://github.com/rentzsch/mogenerator/pull/148) ([smic](https://github.com/smic))

- Adding option to specify protocols to import when using transformable type [\#147](https://github.com/rentzsch/mogenerator/pull/147) ([rtircher](https://github.com/rtircher))

- Do not generate scalar setter for readonly properties [\#146](https://github.com/rentzsch/mogenerator/pull/146) ([gloubibou](https://github.com/gloubibou))

- Minor warning fix, 64-\>32 truncation, format strings [\#141](https://github.com/rentzsch/mogenerator/pull/141) ([seanm](https://github.com/seanm))

- Implement ordered set accessors [\#140](https://github.com/rentzsch/mogenerator/pull/140) ([danielctull](https://github.com/danielctull))

- Support newly-created models when --model=\*.xcdatamodeld [\#138](https://github.com/rentzsch/mogenerator/pull/138) ([sgrankin](https://github.com/sgrankin))

- Small defect fixed for when the base class is from an external library and a model has inheritance [\#136](https://github.com/rentzsch/mogenerator/pull/136) ([davidAtGVC](https://github.com/davidAtGVC))

- Generation of Entity User Info Key/Value pairs as const Structs [\#131](https://github.com/rentzsch/mogenerator/pull/131) ([echoz](https://github.com/echoz))

- IMPLEMENT support of custom scalar types \(/!\ swift not supported\) [\#207](https://github.com/rentzsch/mogenerator/pull/207) ([QuentinArnault](https://github.com/QuentinArnault))

## [1.27](https://github.com/rentzsch/mogenerator/tree/1.27) (2012-11-14)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.26...1.27)

**Closed issues:**

- mogend is looking for xcode in /Applications/Xcode but that's not where I installed it... [\#134](https://github.com/rentzsch/mogenerator/issues/134)

- homebrew install compiles but segfaults on run \(OSX 10.7.4\) [\#126](https://github.com/rentzsch/mogenerator/issues/126)

- Seg fault while processing model [\#121](https://github.com/rentzsch/mogenerator/issues/121)

- Error trying to generate model [\#115](https://github.com/rentzsch/mogenerator/issues/115)

- MOGenerator clashes with ARC [\#106](https://github.com/rentzsch/mogenerator/issues/106)

- Use xcrun  [\#118](https://github.com/rentzsch/mogenerator/issues/118)

- ARC support is broken [\#113](https://github.com/rentzsch/mogenerator/issues/113)

- mogenerator creates invalid files for an entity with no class [\#105](https://github.com/rentzsch/mogenerator/issues/105)

**Merged pull requests:**

- Command line option to specify the import for a custom base class rather than assuming it is local to the project [\#135](https://github.com/rentzsch/mogenerator/pull/135) ([davidAtGVC](https://github.com/davidAtGVC))

- Added the empty string as classname for entities that should be skipped [\#132](https://github.com/rentzsch/mogenerator/pull/132) ([mattbauch](https://github.com/mattbauch))

- Correct generation of fetch requests with repeated variables [\#125](https://github.com/rentzsch/mogenerator/pull/125) ([winitzki](https://github.com/winitzki))

- Allow an attribute property to be specified readonly [\#111](https://github.com/rentzsch/mogenerator/pull/111) ([crispinb](https://github.com/crispinb))

- A simple fix for "skipping entity…" message [\#110](https://github.com/rentzsch/mogenerator/pull/110) ([ghost](https://github.com/ghost))

- \[FIX\] Missing import with per entity custom base class [\#109](https://github.com/rentzsch/mogenerator/pull/109) ([tomguthrie](https://github.com/tomguthrie))

- fixed issue \#98 [\#108](https://github.com/rentzsch/mogenerator/pull/108) ([seanm](https://github.com/seanm))

- Option to limit processing to a specified configuration [\#104](https://github.com/rentzsch/mogenerator/pull/104) ([sixten](https://github.com/sixten))

- Aligning all pointer stars [\#103](https://github.com/rentzsch/mogenerator/pull/103) ([tonyarnold](https://github.com/tonyarnold))

- .xcdatamodeld bundle detection [\#102](https://github.com/rentzsch/mogenerator/pull/102) ([ghost](https://github.com/ghost))

## [1.26](https://github.com/rentzsch/mogenerator/tree/1.26) (2012-04-13)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.25...1.26)

**Closed issues:**

- cannot uninstall 1.25 [\#100](https://github.com/rentzsch/mogenerator/issues/100)

- Transformable relationships generates with missing space [\#97](https://github.com/rentzsch/mogenerator/issues/97)

- iOS 5.1 SDK Seems to Break Scalars [\#96](https://github.com/rentzsch/mogenerator/issues/96)

- Incorrect header generated [\#93](https://github.com/rentzsch/mogenerator/issues/93)

- Breaks with transformable properties [\#89](https://github.com/rentzsch/mogenerator/issues/89)

**Merged pull requests:**

- Proposed fix for issue \#97 [\#99](https://github.com/rentzsch/mogenerator/pull/99) ([RobotK](https://github.com/RobotK))

- private interface declaration [\#95](https://github.com/rentzsch/mogenerator/pull/95) ([jonasschnelli](https://github.com/jonasschnelli))

- Allow per-entity definition of custom base class [\#94](https://github.com/rentzsch/mogenerator/pull/94) ([protocool](https://github.com/protocool))

## [1.25](https://github.com/rentzsch/mogenerator/tree/1.25) (2012-02-17)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.24...1.25)

**Closed issues:**

- Default templates? [\#91](https://github.com/rentzsch/mogenerator/issues/91)

- Assertion failed: \(model\), function -\[MOGeneratorApp setModel:\], file /Users/wolf/code/github/mogenerator/mogenerator.m, line 493 [\#87](https://github.com/rentzsch/mogenerator/issues/87)

- Deprecate “attributeClassName” in favour of “attributeTypeName” [\#85](https://github.com/rentzsch/mogenerator/issues/85)

- mogenerator crashes on my model [\#80](https://github.com/rentzsch/mogenerator/issues/80)

- xmod creates folder but not the files [\#56](https://github.com/rentzsch/mogenerator/issues/56)

- change return types \(for scalars\) to exact size types \(ex: int32\_t\) [\#2](https://github.com/rentzsch/mogenerator/issues/2)

**Merged pull requests:**

- Generate fetched results controllers for to-many relationships [\#88](https://github.com/rentzsch/mogenerator/pull/88) ([danielctull](https://github.com/danielctull))

- Adds a nondestructive -attributeTypeName property to attributes [\#86](https://github.com/rentzsch/mogenerator/pull/86) ([robrix](https://github.com/robrix))

- Add momc path for Xcode 4.3 command line tools. [\#90](https://github.com/rentzsch/mogenerator/pull/90) ([mcglincy](https://github.com/mcglincy))

## [1.24](https://github.com/rentzsch/mogenerator/tree/1.24) (2011-12-08)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.23...1.24)

**Closed issues:**

- constant structs for the property names are incompatible with ARC [\#78](https://github.com/rentzsch/mogenerator/issues/78)

- An entity property called 'type' causes App Store rejection [\#74](https://github.com/rentzsch/mogenerator/issues/74)

- Assertion failed:\(model\),function ... line 486 Abort trap 6 [\#70](https://github.com/rentzsch/mogenerator/issues/70)

- --base-class arg does not apply to entities with parent entity [\#69](https://github.com/rentzsch/mogenerator/issues/69)

- 1.22 uses GCC 4 which is unavailable under Xcode 4 [\#65](https://github.com/rentzsch/mogenerator/issues/65)

- The installer asks me to enter my system password. [\#57](https://github.com/rentzsch/mogenerator/issues/57)

- for "transformable" attribute type mogenator classes give "NSObject may not respond to ..." warnings [\#55](https://github.com/rentzsch/mogenerator/issues/55)

- xmod doesn't generate class files in Xcode 3.2.6 [\#52](https://github.com/rentzsch/mogenerator/issues/52)

**Merged pull requests:**

- minor changes to remove a few warnings [\#76](https://github.com/rentzsch/mogenerator/pull/76) ([kognate](https://github.com/kognate))

- Add constant structs for the property names [\#72](https://github.com/rentzsch/mogenerator/pull/72) ([danielctull](https://github.com/danielctull))

- Fix to issue 69 [\#71](https://github.com/rentzsch/mogenerator/pull/71) ([jcarroll3](https://github.com/jcarroll3))

- PONSO: NSSet-based templates, improved inverse relationship logic [\#68](https://github.com/rentzsch/mogenerator/pull/68) ([tyrone-sudeium](https://github.com/tyrone-sudeium))

- Added import for super entity in PONSO machine headers [\#67](https://github.com/rentzsch/mogenerator/pull/67) ([tyrone-sudeium](https://github.com/tyrone-sudeium))

- Fix ordered relationships [\#66](https://github.com/rentzsch/mogenerator/pull/66) ([MSch](https://github.com/MSch))

## [1.23](https://github.com/rentzsch/mogenerator/tree/1.23) (2011-07-10)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.22...1.23)

**Closed issues:**

- No support for ARC-style @property qualifiers [\#63](https://github.com/rentzsch/mogenerator/issues/63)

- Fetched Properties aren't marked @dynamic in .m [\#54](https://github.com/rentzsch/mogenerator/issues/54)

- Assertion failed: \(model\), function -\[MOGeneratorApp setModel: [\#53](https://github.com/rentzsch/mogenerator/issues/53)

- Just a heads up. Mogenerator fails on Lion [\#50](https://github.com/rentzsch/mogenerator/issues/50)

- 1.21 making useless files; parser failure? \(Xcode 3.2.5\) [\#40](https://github.com/rentzsch/mogenerator/issues/40)

- Can't find generated model files after running mogenerator alone. [\#24](https://github.com/rentzsch/mogenerator/issues/24)

**Merged pull requests:**

- Custom Template Vars / ARC @property qualifiers [\#64](https://github.com/rentzsch/mogenerator/pull/64) ([extremeboredom](https://github.com/extremeboredom))

- --includeh option [\#62](https://github.com/rentzsch/mogenerator/pull/62) ([nzhuk](https://github.com/nzhuk))

- Diff template [\#61](https://github.com/rentzsch/mogenerator/pull/61) ([bewebste](https://github.com/bewebste))

- PONSO - Type-safe, in-memory Plain Old NSObjects with relationships [\#60](https://github.com/rentzsch/mogenerator/pull/60) ([nzhuk](https://github.com/nzhuk))

- change \#include to \#import in generated include header [\#59](https://github.com/rentzsch/mogenerator/pull/59) ([zbowling](https://github.com/zbowling))

## [1.22](https://github.com/rentzsch/mogenerator/tree/1.22) (2011-03-03)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.21...1.22)

## [1.21](https://github.com/rentzsch/mogenerator/tree/1.21) (2010-11-01)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.16...1.21)

## [1.16](https://github.com/rentzsch/mogenerator/tree/1.16) (2010-01-04)

[Full Changelog](https://github.com/rentzsch/mogenerator/compare/1.15...1.16)

## [1.15](https://github.com/rentzsch/mogenerator/tree/1.15) (2009-11-02)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*