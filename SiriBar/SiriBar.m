//
//  SiriBar.m
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "SiriBar.h"

#pragma mark Editable values

#define _contextDuration 0.25 // How long the animations will be - default is 0.25
#define _completionDelay 0.25 // How long the delay will be before a method is run after an animation is run (to be used with performSelector:withObject:afterDelay: calls) - default is 0.25
#define _deactivateOnScreenClick true // Controls whether the button that deactivates SiriBar is placed onto _backwindow
#define _shadowEnabled true // Controls whether the shadow is enabled on _backwindow

#pragma mark - Implementation

@implementation SiriBar

@synthesize backWindow=_backWindow;

#pragma mark Primary methods

-(void)activateSiriBar {
    if (!siribarIsActive) { // If SiriBar isn't active
        siribarHeight = _siribar.frame.size.height; // Get original height of SiriBar window
        siribarIsActive=true; // Set that SiriBar was activated for the first time
    }else{ // Otherwise
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is already active", nil]; // Throw an exception - why are you activating SiriBar if it's already active?
    }
    if (!_siribar) {
        [NSException raise:@"Call to SiriBar is invalid" format:@"_siribar is nil", nil]; // Throw an exception - No _siribar, no activate, no fun today :(
    }
    NSRect screenrect = [[NSScreen mainScreen] frame]; // Get screen frame
    system("screencapture -mxtpng /tmp/screenshot.png &> /dev/null"); // Create a screenshot
    NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"]; // Create UIImage from screenshot.png
    _backWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO]; // Initialize _backWindow
    [_backWindow setReleasedWhenClosed:NO]; // _backWindow can't be released
    [[NSAnimationContext currentContext] setDuration:_contextDuration]; // Sets the duration of animations to _contextDuration
    [_backWindow setBackgroundColor:[NSColor colorWithPatternImage:screenimg]]; // Sets background to screenshot
    [_backWindow setLevel:NSFloatingWindowLevel+1]; // Sets level of _backWindow to be higher than _siribar and _extraWindow
    if (_shadowEnabled){ // If shadow should be enabled...
    [_backWindow setHasShadow:YES]; // ...then enable it.
    }
    if (_deactivateOnScreenClick){ // If SiriBar should deactivate if _backWindow is clicked...
    windowCloseButton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,screenrect.size.width, screenrect.size.height)]; // ...then create an NSButton that encases the whole screen
    [windowCloseButton setTarget:self]; // Set target to self
    [windowCloseButton setAction:@selector(deactivateSiriBar)]; // Set action to deactivate SiriBar
    [windowCloseButton setTransparent:YES]; // Make it transparent
    [[_backWindow contentView] addSubview:windowCloseButton]; // Add the button to _backWindow
    }
    [_backWindow makeKeyAndOrderFront:self]; // Open _backWindow
    [[NSApplication sharedApplication] setPresentationOptions: NSApplicationPresentationHideDock]; // Hide the dock (don't suppress it)
    
    [_siribar setLevel:NSFloatingWindowLevel]; // Set level of _siribar to floating level
    [_siribar setStyleMask:NSBorderlessWindowMask]; // Remove title bar
    [_siribar setFrame:NSMakeRect(0, -siribarHeight, screenrect.size.width, siribarHeight) display:YES]; // Set frame of SiriBar
    [_siribar setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"siribar_bg_tile"]]]; // Change background to siribar_bg_tile
    [_siribar makeKeyAndOrderFront:self]; // Open window
    [[_backWindow animator] setFrame:NSMakeRect(0, siribarHeight, screenrect.size.width, screenrect.size.height) display:YES]; // Move _backWindow up
    [[_siribar animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, siribarHeight) display:YES]; // Move _siribar up
}

-(void)deactivateSiriBar {
    if (!siribarIsActive) { // If SiriBar is not active
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil]; // Throw exception
    }else{ // Otherwise
        siribarIsActive=false; // Set siribarIsActive to false
        NSRect screenrect = [[NSScreen mainScreen] frame]; // Get screen frame
        [[NSAnimationContext currentContext] setDuration:_contextDuration]; // Set duration of animation to _contextDuration
        [[_backWindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES]; // Animate _backWindow lowering
        [[_siribar animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES]; // Animate _siribar lowering
        [_siribar performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay]; // Close _siribar
        [_extraWindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay]; // Close _extraWindow
        [_backWindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay]; // Close _backWindow
        [[NSApplication sharedApplication] performSelector:@selector(setPresentationOptions:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay]; // Show Dock
    }
}

-(void)terminateWithOpenSiriBar {
    [self deactivateSiriBar]; // Deactivate SiriBar
    [[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay]; // Quit app
}

#pragma mark Screen methods

-(void)raiseScreen {
    if (!siribarIsActive) { // If SiriBar is not active
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil]; // Throw exception
    }else{ // Otherwise
    NSRect screenrect = [[NSScreen mainScreen] frame]; // Get screen frame
    [[NSAnimationContext currentContext] setDuration:_contextDuration]; // Set duration of animation to _contextDuration
            [_extraWindow setLevel:NSFloatingWindowLevel]; // Get window to float
            [_extraWindow setStyleMask:NSBorderlessWindowMask]; // Hide title bar
            [_extraWindow setHasShadow:false]; // Disable shadow
            [_extraWindow setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"siribar_bg_tile"]]]; // Change background to siribar_bg_title
        [_extraWindow setFrame:NSMakeRect(0, siribarHeight, screenrect.size.width, screenrect.size.height-siribarHeight-22) display:YES]; // Set frame
            [_extraWindow makeKeyAndOrderFront:self]; // Show window
    [[_backWindow animator] setFrame:NSMakeRect(0, screenrect.size.height-22, screenrect.size.width, screenrect.size.height) display:YES]; //Animate _backWindow
    }
}

-(void)lowerScreen {
    if (!siribarIsActive) { // If SiriBar isn't active
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil]; // Throw exception
    }else{ // Otherwise
    NSRect screenrect = [[NSScreen mainScreen] frame]; // Get screen frame
    [[NSAnimationContext currentContext] setDuration:_contextDuration]; // Set animation duration to _contextDuration
    [[_backWindow animator] setFrame:NSMakeRect(0, siribarHeight, screenrect.size.width, screenrect.size.height) display:YES]; // Drop _backWindow
    }
}

-(void)toggleScreen {
    if (!screenRaised) { // If screen is down
        [self raiseScreen]; // Raise it
        screenRaised=true; // Set screenRaised boolean to true
    }else{ // Otherwise
        [self lowerScreen]; // Lower it
        screenRaised=false; // Set screenRaised boolean to false
    }
}

#pragma mark Booleans

-(BOOL)siribarIsActive {
    if (siribarIsActive){ // If SiriBar is active
        return YES; // Return yes
    }else{ // otherwise
        return NO; // Return no
    }
}

@end
