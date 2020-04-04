//
//  FMPFileSelectionManager.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef void (^FMPFileSelectionCallback)(NSArray<NSURL *> *fileURLs);

@protocol FMPFileSelectionManager <NSObject>
- (void)selectFilesWithCallback:(FMPFileSelectionCallback)callback;
@end

NS_ASSUME_NONNULL_END
