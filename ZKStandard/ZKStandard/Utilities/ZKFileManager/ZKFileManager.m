//
//  ZKFileManager.m
//  ZKStandard
//
//  Created by Jack on 12/31/15.
//  Copyright © 2015 mushank. All rights reserved.
//

#import "ZKFileManager.h"

static ZKFileManager *fileManager = nil;

@implementation ZKFileManager

+ (ZKFileManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[ZKFileManager alloc]init];
    });
    return fileManager;
}

- (id)readValueForKey:(NSString *)key fromBundleFile:(NSString *)fileName withType:(NSString *)fileType
{
    NSMutableDictionary *fileData = [self readDataFromBundleFile:fileName withType:fileType];
    id object = [fileData objectForKey:key];
    
    return object;
}

- (NSMutableDictionary *)readDataFromBundleFile:(NSString *)fileName withType:(NSString *)fileType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSMutableDictionary *returnData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    return returnData;
}

- (void)writeData:(NSMutableDictionary *)writtenData toBundleFile:(NSString *)fileName withType:(NSString *)fileType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSMutableDictionary *fileData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [fileData setDictionary:writtenData];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory;
    if (pathArray && pathArray.count > 0) {
        documentsDirectory = [pathArray objectAtIndex:0];
    }
    
    NSString *fullFileName = [NSString stringWithFormat:@"%@.%@", fileName, fileType];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:fullFileName];
    [fileData writeToFile:file atomically:YES];
}


@end
