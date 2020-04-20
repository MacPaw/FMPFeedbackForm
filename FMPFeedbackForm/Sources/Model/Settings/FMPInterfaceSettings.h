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

/// An icon that is displayed in the top left corner of the form (most likely your app icon).
/// @discussion If @c nil (default value) - no icon is displayed.
@property (nonatomic, strong) NSImage *icon;

/// Size of the icon that is displayed in the top left corner of the form.
/// @discussion Defaults to 64x64.
@property (nonatomic, assign) NSSize iconSize;

/// A string that is displayed in the form's title label.
@property (nonatomic, copy) NSString *title;

/// A string that is displayed in the form's subtitle label.
@property (nonatomic, copy) NSString *subtitle;

/// An array of strings representing support ticket subjects.
@property (nonatomic, copy) NSArray<NSString *> *subjectOptions;

/// A string value of the form's name field placeholder.
@property (nonatomic, copy) NSString *namePlaceholder;

/// A string value of the form's email field placeholder.
@property (nonatomic, copy) NSString *emailPlaceholder;

/// A string value of the form's details field placeholder.
@property (nonatomic, copy) NSString *detailsPlaceholder;

/// A string value to set in the form's name field.
/// @discussion Use this property in case you already know the user's name
///             and want to prefill the form for him.
@property (nonatomic, copy) NSString *defaultName;

/// A string value to set in the form's email field.
/// @discussion Use this property in case you already know the user's email
///             and want to prefill the form for him.
@property (nonatomic, copy) NSString *defaultEmail;

@end

NS_ASSUME_NONNULL_END
