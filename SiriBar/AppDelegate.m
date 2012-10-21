//
//  AppDelegate.m
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [siribar activateSiriBar];
}

-(IBAction)showaboutwindow:(id)sender {
    [siribar deactivateSiriBar];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

-(IBAction)toggleScreen:(id)sender {
    if (!screenraised) {
        NSLog(@"raise");
        [siribar raiseScreen];
        screenraised=true;
    }else{
        NSLog(@"lower");
        [siribar lowerScreen];
        screenraised=false;
    }
}

@end
