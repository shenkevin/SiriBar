//
//  SiriBar.m
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "SiriBar.h"

#pragma mark - Editable values

#define _contextDuration 0.25 // How long the animations will be - default is 0.25
#define _completionDelay 0.25 // How long the delay will be before a method is run after an animation is run (to be used with performSelector:withObject:afterDelay: calls) - default is 0.5
#define _extrabuttonOnRaisedScreen true
#define _deactivateOnScreenClick true
#define _shadowEnabledOnScreenshot true

@implementation SiriBar

@synthesize backWindow=_backWindow;

-(void)activateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    if (!setupDone) {
        siribarHeight = _window.frame.size.height;
        setupDone=true;
    }
    system("screencapture -mxtpng /tmp/screenshot.png"); // Create a temporary screenshot
    NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"];
    NSRect secondframe = NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height);
    _backWindow = [[NSWindow alloc] initWithContentRect:secondframe styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [_backWindow setReleasedWhenClosed:NO];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backWindow animator] setFrame:NSMakeRect(0, siribarHeight, screenrect.size.width, screenrect.size.height) display:YES];
    [_backWindow setBackgroundColor:[NSColor colorWithPatternImage:screenimg]];
    [_backWindow setLevel:NSFloatingWindowLevel+1];
    [_backWindow setHasShadow:YES];
    if (_deactivateOnScreenClick){
    windowCloseButton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,screenrect.size.width, screenrect.size.height)];
    [windowCloseButton setTarget:self];
    [windowCloseButton setAction:@selector(deactivateSiriBar)];
    [windowCloseButton setTransparent:YES];
    [[_backWindow contentView] addSubview:windowCloseButton];
    }
    [_backWindow makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication]
     setPresentationOptions: NSApplicationPresentationHideDock];
    
    [_window setLevel:NSFloatingWindowLevel];
    [_window setStyleMask:NSBorderlessWindowMask];
    NSRect frame = NSMakeRect(0, -siribarHeight, screenrect.size.width, siribarHeight);
    [_window setFrame:frame display:YES];
    [_window makeKeyAndOrderFront:self];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, siribarHeight) display:YES];
    [_window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"siribar_bg_tile"]]];
}

-(void)raiseScreen {
    if (!setupDone) {
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil];
    }else{
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backWindow animator] setFrame:NSMakeRect(0, screenrect.size.height-22, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height-22) display:YES];
    if (!_extrabuttonOnRaisedScreen){
    [extraButton setHidden:true];
    }
    }
}

-(void)lowerScreen {
    if (!setupDone) {
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil];
    }else{
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backWindow animator] setFrame:NSMakeRect(0, siribarHeight, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, siribarHeight) display:YES];
    [extraButton setHidden:false];
    }
}

-(void)deactivateSiriBar {
    if (!setupDone) {
        [NSException raise:@"Call to SiriBar is invalid" format:@"SiriBar is not active", nil];
    }else{
        setupDone=false;
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backWindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES];
    [_window performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
    [_backWindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
    [[NSApplication sharedApplication] performSelector:@selector(setPresentationOptions:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
    }
}

-(void)terminateWithOpenSiriBar {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
}

-(void)toggleScreen {
    if (!screenRaised) {
        NSLog(@"raise");
        [self raiseScreen];
        screenRaised=true;
    }else{
        NSLog(@"lower");
        [self lowerScreen];
        screenRaised=false;
    }
}

@end
