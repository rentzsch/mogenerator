//
//  NSManagedObjectModel+momc.m
//  momc
//
//  Created by Tom Harrington on 4/17/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSManagedObjectModel+momcom.h"
#import "NSEntityDescription+momcom.h"
#import "NSFetchRequest+momcom.h"

@implementation NSManagedObjectModel (momcom)

+ (NSManagedObjectModel *)compileFromDocument:(NSXMLDocument *)sourceModelDocument error:(NSError **)error;
{
    NSManagedObjectModel *model = nil;
    
    if (sourceModelDocument != nil) {
        NSXMLElement *rootElement = [sourceModelDocument rootElement];
        if ([[rootElement name] isEqualToString:@"model"]) {
            model = [[NSManagedObjectModel alloc] init];
            NSMutableDictionary *compiledEntities = [NSMutableDictionary dictionary];
            
            NSArray *entityElements = [rootElement nodesForXPath:@"entity" error:error];
            if (entityElements == nil) {
                return nil;
            }
            // First pass through entities: Create entities without inheritance, relationship destination entities, or inverse relationships
            for (NSXMLElement *currentEntityXMLElement in entityElements) {
                NSEntityDescription *entityDescription = [NSEntityDescription baseEntityForXML:currentEntityXMLElement];
                [compiledEntities setObject:entityDescription forKey:[entityDescription name]];
            }
            [model setEntities:[compiledEntities allValues]];
            
            // Second pass through entities: Stitch up inter-entity stuff now that the entities and relationships exist.
            for (NSXMLElement *currentEntityXMLElement in entityElements) {
                NSString *currentEntityName = [[currentEntityXMLElement attributeForName:@"name"] stringValue];
                NSEntityDescription *entityDescription = [[model entitiesByName] objectForKey:currentEntityName];
                [entityDescription postProcessEntityRelationshipsWithXML:currentEntityXMLElement];
            }
            
            // Configurations
            NSArray *configurationElements = [rootElement nodesForXPath:@"configuration" error:error];
            if (configurationElements == nil) {
                return nil;
            }
            for (NSXMLElement *configurationElement in configurationElements) {
                NSString *configurationName = [[configurationElement attributeForName:@"name"] stringValue];
                
                NSMutableArray *configurationEntities = [NSMutableArray array];
                NSArray *memberEntityElements = [configurationElement nodesForXPath:@"memberEntity" error:error];
                if (memberEntityElements == nil) {
                    return nil;
                }
                for (NSXMLElement *memberEntityElement in memberEntityElements) {
                    NSString *memberEntityName = [[memberEntityElement attributeForName:@"name"] stringValue];
                    NSEntityDescription *memberEntity = [[model entitiesByName] objectForKey:memberEntityName];
                    [configurationEntities addObject:memberEntity];
                }
                if ([configurationEntities count] > 0) {
                    [model setEntities:configurationEntities forConfiguration:configurationName];
                }
            }
            
            // Fetch request templates
            NSArray *fetchRequestTemplateElements = [rootElement nodesForXPath:@"fetchRequest" error:error];
            if (fetchRequestTemplateElements == nil) {
                return nil;
            }
            for (NSXMLElement *fetchRequestTemplateElement in fetchRequestTemplateElements) {
                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestForXML:fetchRequestTemplateElement inManagedObjectModel:model];
                
                NSString *fetchRequestName = [[fetchRequestTemplateElement attributeForName:@"name"] stringValue];
                [model setFetchRequestTemplate:fetchRequest forName:fetchRequestName];
            }
            
        }
    }

    return model;
}

// Compile a single .xcdatamodel (a directory containing "contents").
+ (NSString *)_compileSingleModelFile:(NSString *)xcdatamodelPath inDirectory:(NSString *)resultDirectoryPath error:(NSError **)error
{
    NSManagedObjectModel *model = nil;
    NSString *momPath = nil;
    
    NSString *modelContentsFilePath = [xcdatamodelPath stringByAppendingPathComponent:@"contents"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:modelContentsFilePath]) {
        NSXMLDocument *sourceModelDocument = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelContentsFilePath] options:0 error:error];
        if (sourceModelDocument == nil) {
            return nil;
        }
        model = [NSManagedObjectModel compileFromDocument:sourceModelDocument error:error];
        
        if (model != nil) {
            momPath = [resultDirectoryPath stringByAppendingPathComponent:[[[xcdatamodelPath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"mom"]];
            if (![[NSFileManager defaultManager] createDirectoryAtPath:resultDirectoryPath withIntermediateDirectories:YES attributes:0 error:error]) {
                return nil;
            }
            [NSKeyedArchiver archiveRootObject:model toFile:momPath];
        }
    } else {
        if (error != nil) {
            NSString *modelElementsFilePath = [xcdatamodelPath stringByAppendingPathComponent:@"elements"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:modelElementsFilePath]) {
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Could not read the model at %@, only Xcode 4.0+ file format models are supported", xcdatamodelPath]}];
            } else {
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Could not find a model contents file at %@", xcdatamodelPath]}];
            }
        }
    }
    return momPath;
}

// Compile a collection of models in a .xcdatamodeld into multiple .moms
+ (NSString *)_compileModelBundleAtPath:(NSString *)xcdatamodeldPath inDirectory:(NSString *)resultDirectoryPath error:(NSError **)error
{
    BOOL isDirectory;
    NSString *momdPath = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:xcdatamodeldPath isDirectory:&isDirectory] && isDirectory) {
        // Create a new .momd container
        momdPath = [resultDirectoryPath stringByAppendingPathComponent:[[[xcdatamodeldPath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"momd"]];
        if (![[NSFileManager defaultManager] createDirectoryAtPath:momdPath withIntermediateDirectories:YES attributes:0 error:error]) {
            return nil;
        }
        
        NSString *currentVersionName = nil;
        NSMutableDictionary *modelPathsByName = [NSMutableDictionary dictionary];
        
        NSArray *xcdatamodeldContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:xcdatamodeldPath error:error];
        if ([xcdatamodeldContents count] == 0) {
            return nil;
        }
        for (NSString *filename in xcdatamodeldContents) {
            NSString *fullPath = [xcdatamodeldPath stringByAppendingPathComponent:filename];
            if ([filename hasSuffix:@".xcdatamodel"]) {
                NSString *compiledModelPath = [NSManagedObjectModel _compileSingleModelFile:fullPath inDirectory:momdPath error:error];
                if (compiledModelPath == nil) {
                    return nil;
                }
                NSString *modelName = [filename stringByDeletingPathExtension];
                [modelPathsByName setObject:compiledModelPath forKey:modelName];
            } else if ([filename isEqualToString:@".xccurrentversion"]) {
                NSDictionary *versionInfo = [NSDictionary dictionaryWithContentsOfFile:fullPath];
                currentVersionName = [[versionInfo objectForKey:@"_XCCurrentVersionName"] stringByDeletingPathExtension];
            }
        }
        
        if (currentVersionName != nil) {
            // Run through each model to generate VersionInfo.plist
            NSMutableDictionary *versionInfo = [NSMutableDictionary dictionary];
            [versionInfo setObject:currentVersionName forKey:@"NSManagedObjectModel_CurrentVersionName"];
            NSMutableDictionary *versionHashes = [NSMutableDictionary dictionary];
            [versionInfo setObject:versionHashes forKey:@"NSManagedObjectModel_VersionHashes"];
            
            for (NSString *modelName in [modelPathsByName allKeys]) {
                NSMutableDictionary *currentVersionHashes = [NSMutableDictionary dictionary];
                [versionHashes setObject:currentVersionHashes forKey:modelName];
                
                NSString *compiledModelPath = [modelPathsByName objectForKey:modelName];
                NSManagedObjectModel *compiledModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:compiledModelPath]];
                for (NSEntityDescription *entityDescription in compiledModel) {
                    NSData *versionHash = [entityDescription versionHash];
                    [currentVersionHashes setObject:versionHash forKey:[entityDescription name]];
                }
            }
            NSString *versionInfoPath = [momdPath stringByAppendingPathComponent:@"VersionInfo.plist"];
            [versionInfo writeToFile:versionInfoPath atomically:YES];
        }
    }
    return momdPath;
}


+ (NSString *)compileModelAtPath:(NSString *)modelPath inDirectory:(NSString *)resultDirectoryPath error:(NSError **)error
{
    if ([modelPath hasSuffix:@"xcdatamodel"]) {
        return [NSManagedObjectModel _compileSingleModelFile:modelPath inDirectory:resultDirectoryPath error:error];
    } else if ([modelPath hasSuffix:@"xcdatamodeld"]) {
        return [NSManagedObjectModel _compileModelBundleAtPath:modelPath inDirectory:resultDirectoryPath error:error];
    } else {
        if (error != nil) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unrecognized file: %@", modelPath]}];
        }
        return nil;
    }
}

@end
