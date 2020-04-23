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

/// The form's title label text.
@property (nonatomic, copy) NSString *title;

/// The form's subtitle label text.
@property (nonatomic, copy) NSString *subtitle;

/// An array of strings representing support ticket subjects.
@property (nonatomic, copy) NSArray<NSString *> *subjectOptions;

/// The form's name field placeholder text.
@property (nonatomic, copy) NSString *namePlaceholder;

/// The form's email field placeholder text.
@property (nonatomic, copy) NSString *emailPlaceholder;

/// The form's details field placeholder text.
@property (nonatomic, copy) NSString *detailsPlaceholder;

/// The form's name field value.
/// @discussion Use this property in case you already know the user's name
///             and want to prefill the form for him.
@property (nonatomic, copy) NSString *defaultName;

/// The form's email field value.
/// @discussion Use this property in case you already know the user's email
///             and want to prefill the form for him.
@property (nonatomic, copy) NSString *defaultEmail;

@end

NS_ASSUME_NONNULL_END
