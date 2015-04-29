//
//  AppDelegate.swift
//  MogenSwiftTest
//
//  Created by Wolf Rentzsch on 7/10/14.
//  Copyright (c) 2014 Jonathan 'Wolf' Rentzsch. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: NSWindow?

    @IBAction func saveAction(sender: AnyObject) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        var error: NSError? = nil
        
        if let moc = self.managedObjectContext {
            if !moc.commitEditing() {
                println("\(NSStringFromClass(self.dynamicType)) unable to commit editing before saving")
            }
            if !moc.save(&error) {
                NSApplication.sharedApplication().presentError(error!)
            }
        }
    }

    var applicationFilesDirectory: NSURL {
        // Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.rentzsch.MogenSwiftTest" in the user's Application Support directory.
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        let appSupportURL: AnyObject = urls[urls.count - 1]
        return appSupportURL.URLByAppendingPathComponent("com.rentzsch.MogenSwiftTest")
    }

    var managedObjectModel: NSManagedObjectModel {
        // Creates if necessary and returns the managed object model for the application.
        if let mom = _managedObjectModel {
            return mom
        }
    	
        let modelURL = NSBundle.mainBundle().URLForResource("MogenSwiftTest", withExtension: "momd")
        _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil

    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        // Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
        if let psc = _persistentStoreCoordinator {
            return psc
        }
        
        let mom = self.managedObjectModel
        
        let fileManager = NSFileManager.defaultManager()
        let applicationFilesDirectory = self.applicationFilesDirectory
        var error: NSError? = nil
        
        let optProperties: NSDictionary? = applicationFilesDirectory.resourceValuesForKeys([NSURLIsDirectoryKey], error: &error)
        
        if let properties = optProperties {
            if !properties[NSURLIsDirectoryKey]!.boolValue {
                // Customize and localize this error.
                let failureDescription = "Expected a folder to store application data, found a file \(applicationFilesDirectory.path)."
                var errorDict = [NSObject : AnyObject ]()
                errorDict[NSLocalizedDescriptionKey] = failureDescription
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 101, userInfo: errorDict)
                
                NSApplication.sharedApplication().presentError(error!)
                return nil
            }
        } else {
            var ok = false
            if error!.code == NSFileReadNoSuchFileError {
                ok = fileManager.createDirectoryAtPath(applicationFilesDirectory.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
            }
            if !ok {
                NSApplication.sharedApplication().presentError(error!)
                return nil
            }
        }
        
        let url = applicationFilesDirectory.URLByAppendingPathComponent("MogenSwiftTest.storedata")
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        if coordinator.addPersistentStoreWithType(NSXMLStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            NSApplication.sharedApplication().presentError(error!)
            return nil
        }
        _persistentStoreCoordinator = coordinator
        
        return _persistentStoreCoordinator
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil

    var managedObjectContext: NSManagedObjectContext? {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
        if let moc = _managedObjectContext {
            return moc
        }
        
        let coordinator = self.persistentStoreCoordinator
        if !(coordinator != nil) {
            var errorDict = [NSObject : AnyObject ]()
            errorDict[NSLocalizedDescriptionKey] = "Failed to initialize the store"
            errorDict[NSLocalizedFailureReasonErrorKey] = "There was an error building up the data file."
            let error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: errorDict)
            NSApplication.sharedApplication().presentError(error)
            return nil
        }
        _managedObjectContext = NSManagedObjectContext()
        _managedObjectContext!.persistentStoreCoordinator = coordinator!
            
        return _managedObjectContext
    }
    var _managedObjectContext: NSManagedObjectContext? = nil

    func windowWillReturnUndoManager(window: NSWindow?) -> NSUndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        if let moc = self.managedObjectContext {
            return moc.undoManager
        } else {
            return nil
        }
    }

    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        
        if !(_managedObjectContext != nil) {
            // Accesses the underlying stored property because we don't want to cause the lazy initialization
            return .TerminateNow
        }
        let moc = self.managedObjectContext!
        if !moc.commitEditing() {
            println("\(NSStringFromClass(self.dynamicType)) unable to commit editing to terminate")
            return .TerminateCancel
        }
        
        if !moc.hasChanges {
            return .TerminateNow
        }
        
        var error: NSError? = nil
        if !moc.save(&error) {
            // Customize this code block to include application-specific recovery steps.              
            let result = sender.presentError(error!)
            if (result) {
                return .TerminateCancel
            }

            let question = "Could not save changes while quitting. Quit anyway?" // NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message")
            let info = "Quitting now will lose any changes you have made since the last successful save" // NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
            let quitButton = "Quit anyway" // NSLocalizedString(@"Quit anyway", @"Quit anyway button title")
            let cancelButton = "Cancel" // NSLocalizedString(@"Cancel", @"Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButtonWithTitle(quitButton)
            alert.addButtonWithTitle(cancelButton)

            let answer = alert.runModal()
            if answer == NSAlertFirstButtonReturn {
                return .TerminateCancel
            }
        }

        return .TerminateNow
    }

}

