//
//  FMPHostApplication.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 04.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
#import "FMPHostApplication.h"

@interface FMPHostApplication ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, strong) NSImage *icon;
@end

@implementation FMPHostApplication

+ (instancetype)sharedInstance
{
    static FMPHostApplication *hostApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hostApplication = [super new];
        [hostApplication setup];
    });
    return hostApplication;
}

- (void)setup
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self.path = appBundle.bundlePath;
    self.bundleID = appBundle.bundleIdentifier;
    
    NSString *name = [appBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleNameKey];
    if (!name)
    {
        name = [self.path.lastPathComponent stringByDeletingPathExtension];
    }
    self.name = name;
    
    NSString *iconPath = [appBundle pathForResource:[appBundle objectForInfoDictionaryKey:@"CFBundleIconFile"] ofType:@"icns"];
    if (!iconPath)
    {
        iconPath = [appBundle pathForResource:[appBundle objectForInfoDictionaryKey:@"CFBundleIconFile"] ofType:nil];
    }
    self.icon = [[NSImage alloc] initWithContentsOfFile:iconPath];
}

@end
