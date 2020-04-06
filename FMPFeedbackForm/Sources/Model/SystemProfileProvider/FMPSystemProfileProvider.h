//
//  FMPSystemProfileProvider.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef void (^FMPWriteSystemProfileCompletion)(NSURL *_Nullable fileURL);
typedef void (^FMPGatherSystemProfileCompletion)(NSString *_Nullable systemInfo,
                                                 NSString *_Nullable log,
                                                 NSString *_Nullable appPreferences);

@protocol FMPSystemProfileProvider <NSObject>

@property (nonatomic, copy, nullable) NSString *userDefaultsDomain;
@property (nonatomic, strong) NSArray<NSURL *> *logURLs;
- (void)gatherSystemProfileDataWithCompletion:(nullable FMPGatherSystemProfileCompletion)completion;
- (void)writeSystemProfileToFileWithCompletion:(nullable FMPWriteSystemProfileCompletion)completion;

@end

NS_ASSUME_NONNULL_END
