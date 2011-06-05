PONSO - Plain Old NSObjects
===========================

What is PONSO?
--------------
The idea is to use mogenerator to generate lightweight, memory-only, type-safe ObjC data model classes from Xcode data models. 

Features
--------
- Type-safe attributes
- Supports one-to-one and one-to-many relationships
- Relationships are always ordered - implemented with NSArrays
- Supports inverse relationships, which should be always marked as 'transient'
- Supports serialization of any model object to NSDictionary and initialization from NSDictionary
- Supports writing and reading to binary property list files
- Requires that data model is a tree, where nodes are entities and edges are strong, non-transient relationships. Does not work with graph data models.
- Supports weak relationships which are not archived in serialized form. These relationships are not considered as part of the object graph tree, e.g. you can have strong relationships A -> B, A -> C and a weak relationship B -> C and this won't invalidate the "tree model" requirement.
- To create a weak relationship, add "destinationEntityIDKeyPath" user info key to that relationship in Xcode data modeller, and specify the name of attribute which can be used as unique ID to find the destination object. See sample projects entities DepartmentAssistant and DepartmentEmployee for examples.
- Cycles between weak relationships are found automatically and are warned about during code generation.


How to use
----------
- The only additional source code you need to compile into your application for PONSO is ModelObject class found in "contributed templates/Nikita Zhuk/ponso/code"
- See "contributed templates/Nikita Zhuk/ponso/sample project/PonsoTest" project for sample setup


TODO
-----
PONSO is a work in progress and can be enchanced in a various ways. 

Some missing features include:
- Automatic setting of inverse one-to-one relationships in setters
- Support for many-to-many relationships
- Implementations of to-many relationships as ordered sets instead of arrays
- Detection of retain cycles caused by both relationship directions being non-transient

Feel free to fork & contribute.


Contact info
-------------
Nikita Zhuk, 2011
Twitter: @nzhuk

