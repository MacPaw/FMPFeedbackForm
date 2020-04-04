//
//  FMPInterfaceSettings.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FMPInterfaceSettings : NSObject

@property (nonatomic, class, readonly) FMPInterfaceSettings *defaultSettings;

// Don't forget to update FMPInterfaceSettings+ObservableProperties when you add new properties

@property (nonatomic, strong) NSImage *icon;
@property (nonatomic, assign) NSSize iconSize;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSArray<NSString *> *subjectOptions;
@property (nonatomic, copy) NSString *namePlaceholder;
@property (nonatomic, copy) NSString *emailPlaceholder;
@property (nonatomic, copy) NSString *detailsPlaceholder;
@property (nonatomic, copy) NSString *defaultName;
@property (nonatomic, copy) NSString *defaultEmail;

@end

NS_ASSUME_NONNULL_END
