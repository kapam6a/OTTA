//
//  main.m
//  OneTwoTripApp
//
//  Created by Kapam6a on 16.05.16.
//  Copyright © 2016 Kapam6a. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const OTTACompareString = @"onetwotrip";
static NSString *const OTTANameOfOutputFile = @"output.txt";
const NSInteger OTTANumberOfInputArgumetns = 2;
const NSInteger OTTANumberOfLettersInCompareString = 10;
const NSInteger OTTANumberOfConditionsInInputFile = 2;

NSMutableArray * getEmptyArray()
{
    NSMutableArray *array = [NSMutableArray new];
    for(int i = 0; i < OTTANumberOfLettersInCompareString; i++){
        [array addObject: [NSNull null]];
    }
    return array;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc != OTTANumberOfInputArgumetns){
            NSLog(@"Try again!");
            return 0;
        }
        NSString *path = [NSString stringWithFormat:@"%s", argv[0]];
        path = [path stringByDeletingLastPathComponent];
        NSString *pathToInputFile = [NSString stringWithFormat:@"%@/%s", path, argv[1]];
        NSString *content = [NSString stringWithContentsOfFile:pathToInputFile
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        NSArray *symbolsFromInputFile = [content componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSInteger rowsNumber = [symbolsFromInputFile[0] integerValue];
        NSInteger columnsNumber = [symbolsFromInputFile[1] integerValue];
        NSMutableString *currentCompareString = [NSMutableString stringWithString:OTTACompareString];
        NSArray *lettersFromInputFile = [symbolsFromInputFile subarrayWithRange:NSMakeRange(OTTANumberOfConditionsInInputFile, symbolsFromInputFile.count-OTTANumberOfConditionsInInputFile)];
        NSMutableArray *arrayWithLetters = getEmptyArray();
        for (int i = 0; i < rowsNumber ; i++ ){
            [lettersFromInputFile[i] enumerateSubstringsInRange:NSMakeRange(0, columnsNumber)
                                           options:NSStringEnumerationByComposedCharacterSequences
                                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                            NSString *substringLowercase = [substring lowercaseString];
                                            if([currentCompareString rangeOfString:substringLowercase].location != NSNotFound){
                                                NSRange range = [currentCompareString rangeOfString:substringLowercase];
                                                if ([[arrayWithLetters objectAtIndex:range.location] isEqual:[NSNull null]]){
                                                    NSString *letterWithCoordinates = [NSString stringWithFormat:@"%@ - (%i,%lu);", substring, i, substringRange.location];
                                                    [arrayWithLetters replaceObjectAtIndex:range.location withObject:letterWithCoordinates];
                                                }
                                                [currentCompareString replaceCharactersInRange:range withString:@" "];
                                            }
                                        }];
        }
        if ([arrayWithLetters containsObject:[NSNull null]]) {
            NSLog(@"Impossible");
            return 0;
        }
        NSString *finalString = [arrayWithLetters componentsJoinedByString:@"\n"];
        NSString *pathToOutputFile = [NSString stringWithFormat:@"%@/%@", path, OTTANameOfOutputFile];
        if ([[NSFileManager defaultManager] createFileAtPath:pathToOutputFile
                                                    contents:[finalString dataUsingEncoding:NSUTF8StringEncoding]
                                                  attributes:nil]) {
            NSLog(@"Wrote data to file!");
        };
    return 0;
    }
}

