//
//  SiriBar.m
//  SiriBar
//
//  Created by Tasos Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "SiriBar.h"

@implementation SiriBar

@synthesize backwindow=_backwindow;

-(void)activateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    system("screencapture -mxtpng /tmp/screenshot.png"); // Create a temporary screenshot
    NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"];
    NSRect secondframe = NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height);
    _backwindow = [[NSWindow alloc] initWithContentRect:secondframe styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [_backwindow setBackgroundColor:[NSColor colorWithPatternImage:screenimg]];
    [_backwindow setLevel:NSFloatingWindowLevel];
    windowclosebutton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,screenrect.size.width, screenrect.size.height)];
    [windowclosebutton setTarget:self];
    [windowclosebutton setAction:@selector(terminateWithOpenSiriBar)];
    [windowclosebutton setTransparent:YES];
    [[_backwindow contentView] addSubview:windowclosebutton];
    [_backwindow makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication]
     setPresentationOptions: NSApplicationPresentationHideDock];
    
    [_window setLevel:NSFloatingWindowLevel+1];
    [_window setStyleMask:NSBorderlessWindowMask];
    NSRect frame = NSMakeRect(0, -200, screenrect.size.width, 200);
    [_window setFrame:frame display:YES];
    [_window makeKeyAndOrderFront:self];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
    [_window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"siribar_bg_tile"]]];
}

-(void)raiseScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, screenrect.size.height, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [extrabutton setHidden:true];
}

-(void)lowerScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
    [extrabutton setHidden:false];
}

-(void)deactivateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES];
    [_window performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
    [_backwindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
    [[NSApplication sharedApplication] performSelector:@selector(setPresentationOptions:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
}

-(void)terminateWithOpenSiriBar {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
}

-(void)toggleScreen {
    if (!screenraised) {
        NSLog(@"raise");
        [self raiseScreen];
        screenraised=true;
    }else{
        NSLog(@"lower");
        [self lowerScreen];
        screenraised=false;
    }
}

@end
