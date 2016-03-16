This template allows to create entities filled with an NSDictionary (perfect for JSON mapping to Core Data) using:

+ (instancetype)insertWithDictionary:context:


How to Use:
Add for every property in our xcdatamodel that We want to be mapped you have to add a new row in its User Info dictionary (in Data Model Inspector).
Key name: jsonKey
Key Value: NSDictionary Key that contains the object to be read.

If the property is a relationship (and you want to be added as relationship in your object) you have to be sure that its destination class also has created its subclass using mogenerator.

And that's it!