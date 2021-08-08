//
//  NSFileManager+Paths.m
//  Vienna
//
//  Copyright 2021 Eitot
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "NSFileManager+Paths.h"

@import os.log;

@implementation NSFileManager (Paths)

// The NSApplicationScriptsDirectory search path returns a subdirectory in the
// Library/Application Scripts directory. Vienna currently uses a subdirectory
// in Library/Scripts/Applications instead. The sandboxing migration performs
// an automatic migration to Library/Application Scripts/<bundle identifier>
// and places a symlink at the old location. This code needs to be updated
// accordingly.
- (NSURL *)applicationScriptsDirectory {
    static NSURL *url = nil;
    if (url) {
        return [url copy];
    }

    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSError *error = nil;
    // Replace NSLibraryDirectory with NSApplicationScriptsDirectory for
    // sandboxing.
    url = [fileManager URLForDirectory:NSLibraryDirectory
                              inDomain:NSUserDomainMask
                     appropriateForURL:nil
                                create:NO
                                 error:&error];
    if (!url && error) {
        if (@available(macOS 10.12, *)) {
            os_log_error(OS_LOG_DEFAULT, "%@", error.localizedDescription);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }

    // Remove the following lines for sandboxing.
    url = [url URLByAppendingPathComponent:@"Scripts/Applications/Vienna"
                               isDirectory:YES];

    return [url copy];
}

// According to Apple's file-system programming guide, the bundle identifier
// should be used as the subdirectory name. However, Vienna presently uses the
// app name instead. This should be changed when Vienna migrates to sandboxing.
- (NSURL *)applicationSupportDirectory {
    static NSURL *url = nil;
    if (url) {
        return [url copy];
    }

    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSError *error = nil;
    url = [fileManager URLForDirectory:NSApplicationSupportDirectory
                              inDomain:NSUserDomainMask
                     appropriateForURL:nil
                                create:NO
                                 error:&error];
    if (!url && error) {
        if (@available(macOS 10.12, *)) {
            os_log_error(OS_LOG_DEFAULT, "%@", error.localizedDescription);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }

    // For sandboxing, use NSBundle.mainBundle.bundleIdentifier instead of the
    // application name (recommendation by Apple, but not required).
    url = [url URLByAppendingPathComponent:@"Vienna"
                               isDirectory:YES];

    return [url copy];
}

- (NSURL *)cachesDirectory {
    static NSURL *url = nil;
    if (url) {
        return [url copy];
    }

    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSError *error = nil;
    url = [fileManager URLForDirectory:NSCachesDirectory
                              inDomain:NSUserDomainMask
                     appropriateForURL:nil
                                create:NO
                                 error:&error];
    if (!url && error) {
        if (@available(macOS 10.12, *)) {
            os_log_error(OS_LOG_DEFAULT, "%@", error.localizedDescription);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }

    url = [url URLByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier
                               isDirectory:YES];

    return [url copy];
}

@end
