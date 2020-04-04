//
//  FMPDefaultFileSelectionManager.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 12.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPDefaultFileSelectionManager.h"

@interface FMPDefaultFileSelectionManager ()
@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) NSOpenPanel *openPanel;
@end

@implementation FMPDefaultFileSelectionManager

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super init];
    if (self)
    {
        self.window = window;
        [self setupOpenPanel];
    }
    return self;
}

- (void)setupOpenPanel
{
    self.openPanel = [NSOpenPanel openPanel];
    self.openPanel.canChooseFiles = YES;
    self.openPanel.allowsMultipleSelection = YES;
    self.openPanel.canChooseDirectories = NO;
    self.openPanel.canCreateDirectories = NO;
}

- (void)selectFilesWithCallback:(FMPFileSelectionCallback)callback {
    [self.openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        callback(result == NSModalResponseCancel ? @[] : self.openPanel.URLs);
    }];
}

@end
