//
//  FMPDefaultSystemProfileProvider.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPDefaultSystemProfileProvider.h"
#import "FMPHostApplication.h"
#import "FMPSystemInfo.h"

#import <asl.h>

@interface FMPDefaultSystemProfileProvider ()

@property (atomic, copy) NSString *systemInfo;
@property (atomic, copy) NSString *logInfo;
@property (atomic, copy) NSString *appPreferencesInfo;
@property (atomic, strong) NSURL *fileURL;

@property (nonatomic, strong) dispatch_queue_t internalQueue;
@property (nonatomic, strong) NSLock *lock;
@property (atomic, strong) NSDate *previousDataGatheringTime;
@property (atomic, assign) BOOL isGatheringData;
@property (atomic, assign) BOOL isWritingFile;
@property (nonatomic, strong) NSMutableArray<FMPGatherSystemProfileCompletion> *gatherDataCompletions;
@property (nonatomic, strong) NSMutableArray<FMPWriteSystemProfileCompletion> *writeFileCompletions;

@end

@implementation FMPDefaultSystemProfileProvider

@synthesize logURLs;
@synthesize userDefaultsDomain;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
    self.internalQueue = dispatch_queue_create("com.macpaw.fmpFeedbackForm.systemProfileProviderQueue", attr);
    
    self.lock = [NSLock new];
    self.lock.name = @"com.macpaw.fmpFeedbackForm.systemProfileProviderLock";
    
    self.gatherDataCompletions = [NSMutableArray new];
    self.writeFileCompletions = [NSMutableArray new];
    self.previousDataGatheringTime = [NSDate dateWithTimeIntervalSince1970:0];
    self.logURLs = @[];
}

// MARK: - FMPSystemProfileProvider

- (void)gatherSystemProfileDataWithCompletion:(FMPGatherSystemProfileCompletion)completion
{
    // Update data no more than once per minute
    if ([[NSDate date] timeIntervalSinceDate:self.previousDataGatheringTime] < 60)
    {
        if (completion)
        {
            completion(self.systemInfo, self.logInfo, self.appPreferencesInfo);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (completion)
    {
        [self safelyExecuteBlock:^{
            [weakSelf.gatherDataCompletions addObject:completion];
        }];
    }
    
    if (self.isGatheringData)
    {
        return;
    }
    
    self.isGatheringData = YES;
    dispatch_async(self.internalQueue, ^{
        __strong typeof(weakSelf) _self = weakSelf;
        
        _self.systemInfo = [FMPSystemInfo systemInfoString];
        _self.logInfo = [_self consoleLogsForHostApplication];
        _self.appPreferencesInfo = [_self appPreferencesForHostApplication];
        
        _self.previousDataGatheringTime = [NSDate date];
        _self.isGatheringData = NO;
        
        [_self safelyExecuteBlock:^{
            for (FMPGatherSystemProfileCompletion completion in _self.gatherDataCompletions)
            {
                completion(_self.systemInfo, _self.logInfo, _self.appPreferencesInfo);
            }
            [_self.gatherDataCompletions removeAllObjects];
        }];
    });
}

- (void)writeSystemProfileToFileWithCompletion:(FMPWriteSystemProfileCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    if (completion)
    {
        [weakSelf safelyExecuteBlock:^{
            [weakSelf.writeFileCompletions addObject:[completion copy]];
        }];
    }
    
    if (self.isWritingFile)
    {
        return;
    }
    
    void (^writeFileBlock)(NSString *, NSString *, NSString *) = ^(NSString *systemInfo,
                                                                   NSString *log,
                                                                   NSString *appPreferences)
    {
        NSMutableString *profileString = [NSMutableString stringWithString:@"---------- SYSTEM INFO ----------\n\n"];
        [profileString appendString:systemInfo];
        [profileString appendString:@"\n\n---------- CONSOLE LOG ----------\n\n"];
        [profileString appendString:log];
        [profileString appendString:@"\n\n---------- APPLICATION PREFERENCES ----------\n\n"];
        [profileString appendString:appPreferences];
        
        NSError *error;
        NSString *fileName = [NSString stringWithFormat:@"%@_system_profile.txt", FMPHostApplication.sharedInstance.name];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject]
                              stringByAppendingPathComponent:fileName];
        [profileString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        weakSelf.isWritingFile = NO;
        
        if (error)
        {
            NSLog(@"Error: did fail to write system profile data to file (attempted path: %@). Error: %@.", filePath, error);
        }
        else
        {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            
            __strong typeof(self) _self = weakSelf;
            [self safelyExecuteBlock:^{
                for (FMPWriteSystemProfileCompletion completion in _self.writeFileCompletions)
                {
                    completion(fileURL);
                }
                [_self.writeFileCompletions removeAllObjects];
            }];
        }
    };
    
    [self gatherSystemProfileDataWithCompletion:^(NSString * _Nullable systemInfo,
                                                  NSString * _Nullable log,
                                                  NSString * _Nullable appPreferences) {
        weakSelf.isWritingFile = YES;
        dispatch_async(self.internalQueue, ^{
            writeFileBlock(systemInfo, log, appPreferences);
        });
    }];
}

- (void)safelyExecuteBlock:(void(^)(void))block
{
    if (block)
    {
        [self.lock lock];
        block();
        [self.lock unlock];
    }
}

// MARK: - Info gathering

- (NSString *)appPreferencesForHostApplication
{
    NSString *domainName;
    if (self.userDefaultsDomain.length > 0)
    {
        domainName = self.userDefaultsDomain;
    }
    else
    {
        domainName = FMPHostApplication.sharedInstance.bundleID ?: @"";
    }
    NSDictionary *prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:domainName];
    return [prefsDict description];
}

- (NSString *)consoleLogsForHostApplication
{
    NSMutableString *generalLog = [NSMutableString string];
    
    for (NSURL *currentPathURL in self.logURLs)
    {
        if (![[NSFileManager defaultManager] isReadableFileAtPath:currentPathURL.path])
        {
            NSLog(@"Did fail to read log file at path: %@", currentPathURL.path);
            continue;
        }
        
        NSString *currentLog = [NSString stringWithContentsOfFile:currentPathURL.path
                                                     usedEncoding:nil
                                                            error:nil];
        if (nil == currentLog)
        {
            currentLog = [NSString stringWithContentsOfFile:currentPathURL.path
                                                   encoding:NSMacOSRomanStringEncoding
                                                      error:nil];
        }
        
        if (currentLog)
        {
            [generalLog appendFormat:@"-----%@-----\n\n%@", currentPathURL.lastPathComponent, currentLog];
        }
    }
    
    NSString *systemLog = [self systemConsoleLog];
    if (systemLog.length > 0)
    {
        [generalLog appendFormat:@"\n\n-----SYSTEM CONSOLE LOG-----\n\n%@", systemLog];
    }
    
    return generalLog.length > 0 ? [generalLog copy] : @"No logs found.";
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// TODO: ASL has been deprecated, replace with os_log if possible
- (NSString *)systemConsoleLog
{
    NSString *appName = FMPHostApplication.sharedInstance.name;
    NSDate *since = [NSDate dateWithTimeIntervalSinceNow:-86400]; // yesterday
    NSMutableString *logs = [NSMutableString string];
    
    aslmsg query = asl_new(ASL_TYPE_QUERY);
    if (query)
    {
        asl_set_query(query, ASL_KEY_SENDER, [appName UTF8String], ASL_QUERY_OP_EQUAL);
        asl_set_query(query, ASL_KEY_TIME, [[NSString stringWithFormat:@"%01f", [since timeIntervalSince1970]] UTF8String], ASL_QUERY_OP_GREATER_EQUAL);
        
        aslresponse response = asl_search(nil, query);
        asl_free(query);
        
        if (response)
        {
            aslmsg msg;
            
            while ((msg = aslresponse_next(response)) != nil)
            {
                const char* time = asl_get(msg, ASL_KEY_TIME);
                if (!time)
                {
                    continue;
                }
                
                const char* text = asl_get(msg, ASL_KEY_MSG);
                if (!text)
                {
                    continue;
                }
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:atof(time)];
                [logs appendFormat:@"%@: %s\n", date, text];
            }
            
            asl_free(msg);
            aslresponse_free(response);
        }
    }
     
    return logs;
}

@end

#pragma clang diagnostic pop
