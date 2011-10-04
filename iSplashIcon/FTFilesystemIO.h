//
//  FTFilesystemIO.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTFilesystemIO : NSObject {

}

+ (BOOL)isFolder:(NSString *)path;

+ (BOOL)isFile:(NSString *)path;

+ (NSString *)getContentsOfFile:(NSString *)filePath;

+ (NSDictionary *)getFileAttributes:(NSString *)path;

+ (NSArray *)getListAll:(NSString *)path;

+ (NSArray *)getListFiles:(NSString *)path;

+ (NSArray *)getListFolders:(NSString *)path;

+ (int)getFileSize:(NSString *)path;

+ (NSString *)getFileExtension:(NSString *)path;

+ (NSString *)getFormatedFileSize:(NSString *)path;

+ (NSDate *)getFileCreated:(NSString *)path;

+ (NSDate *)getFileModified:(NSString *)path;

+ (void)makeFolderPath:(NSString *)path;

+ (BOOL)deleteFile:(NSString *)path;

+ (void)deleteFilesOlderThan:(NSDate *)date inDirectory:(NSString *)dir;


@end
