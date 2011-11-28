    /*
 Copyright 2011 Marko Karppinen & Co. LLC.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 main.m
 mogenerator / PONSO
 Created by Nikita Zhuk on 22.1.2011.
 */

#import <Foundation/Foundation.h>
#import "Model.h"

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    ModelCompany *company1 = [[[ModelCompany alloc] init] autorelease];
    company1.name = @"Our company";
    company1.yearFoundedValue = 2003;
    
    ModelEmployee *emp1 = [[[ModelEmployee alloc] init] autorelease];
    ModelEmployee *emp2 = [[[ModelEmployee alloc] init] autorelease];
    
    emp1.name = @"John The Engineer";
    emp1.birthDate = [NSDate dateWithTimeIntervalSince1970:60*60];
    emp1.isOnVacationValue = YES;
    
    emp2.name = @"Mike The Tester";

    ModelAssistant *as1 = [[[ModelAssistant alloc] init] autorelease];
    ModelAssistant *as2 = [[[ModelAssistant alloc] init] autorelease];
    
    as1.name = @"First assistant";
    as1.birthDate = [NSDate date];
    
    as2.name = @"Second assistant";
    as2.birthDate = [NSDate date];

    [company1 addEmployeesObject:emp1];
    [company1 addEmployeesObject:emp2];
    [company1 addAssistantsObject:as1];
    [company1 addAssistantsObject:as2];
    
    emp1.assistant = as2;
    as2.boss = emp1; // Currently one-to-one relationships' inverse must be set manually

    emp2.assistant = as1;
    as1.boss = emp2; // Currently one-to-one relationships' inverse must be set manually

    ModelDepartment *dep1 = [[[ModelDepartment alloc] init] autorelease];
    ModelDepartment *dep2 = [[[ModelDepartment alloc] init] autorelease];
    dep1.name = @"R&D Department";
    dep2.name = @"QA Department";

    // Setup workers of dep1
    ModelDepartmentEmployee *depEmp1 = [[[ModelDepartmentEmployee alloc] init] autorelease];
    depEmp1.employee = emp1;
    depEmp1.startedWorking = [NSDate dateWithTimeIntervalSince1970:10000];
    [dep1 addEmployeesObject:depEmp1];

    ModelDepartmentEmployee *depEmp2 = [[[ModelDepartmentEmployee alloc] init] autorelease];
    depEmp2.employee = emp2;
    depEmp2.startedWorking = [NSDate dateWithTimeIntervalSince1970:20000];
    [dep1 addEmployeesObject:depEmp2];

    ModelDepartmentAssistant *depAs1 = [[[ModelDepartmentAssistant alloc] init] autorelease];
    depAs1.assistant = as1;
    depAs1.startedWorking = [NSDate dateWithTimeIntervalSince1970:30000];
    [dep1 addAssistantsObject:depAs1];

    // Setup workers of dep2
    depEmp2 = [[[ModelDepartmentEmployee alloc] init] autorelease];
    depEmp2.employee = emp2;
    depEmp2.startedWorking = [NSDate dateWithTimeIntervalSince1970:40000];
    [dep2 addEmployeesObject:depEmp2];
    
    depAs1 = [[[ModelDepartmentAssistant alloc] init] autorelease];
    depAs1.assistant = as1;
    depAs1.startedWorking = [NSDate dateWithTimeIntervalSince1970:50000];
    [dep2 addAssistantsObject:depAs1];

    ModelDepartmentAssistant *depAs2 = [[[ModelDepartmentAssistant alloc] init] autorelease];
    depAs2.assistant = as2;
    depAs2.startedWorking = [NSDate dateWithTimeIntervalSince1970:60000];
    [dep2 addAssistantsObject:depAs2];

    [company1 addDepartmentsObject:dep1];
    [company1 addDepartmentsObject:dep2];
    
    // Test NSDictionary serialization
    ModelCompany *recreatedCompany = [[[ModelCompany alloc] initWithDictionaryRepresentation:[company1 dictionaryRepresentation]] autorelease];
    [recreatedCompany awakeFromDictionaryRepresentationInit];
    
    NSDictionary *recreatedCompanyDict = [recreatedCompany dictionaryRepresentation];
    
    NSLog(@"%@", [company1 dictionaryRepresentation]);
    NSLog(@"%@", recreatedCompanyDict);
    
    NSCAssert([recreatedCompanyDict isEqualToDictionary:[company1 dictionaryRepresentation]], @"ModelCompany serialization roundtrip failed.");
    NSCAssert([recreatedCompany.employees count] == 2, @"");
    NSCAssert([recreatedCompany.assistants count] == 2, @"");
    NSCAssert([recreatedCompany.departments count] == 2, @"");

    // Test file serialization (uses NSDictionary)
    NSString *tempFile = [[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] stringByAppendingPathExtension:@"ponso-temp-plist"];
    BOOL result = [company1 writeToFile:tempFile];
    NSCAssert(result, @"");
    
    ModelCompany *recreatedCompany2 = [ModelCompany createModelObjectFromFile:tempFile];
    NSDictionary *recreatedCompany2Dict = [recreatedCompany2 dictionaryRepresentation];
    [[NSFileManager defaultManager] removeItemAtPath:tempFile error:nil];

    NSCAssert([recreatedCompany2Dict isEqualToDictionary:[company1 dictionaryRepresentation]], @"ModelCompany serialization roundtrip failed.");
    
    [pool drain];
    return 0;
}

