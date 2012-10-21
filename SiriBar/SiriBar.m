//
//  SiriBar.m
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "SiriBar.h"

#define _contextDuration 0.25 // How long the animations will be - default is 0.25
#define _completionDelay 0.25 // How long the delay will be before a method is run after an animation is run (to be used with performSelector:withObject:afterDelay: calls) - default is 0.5
#define _extrabuttonOnRaisedScreen true

@implementation SiriBar

@synthesize backwindow=_backwindow;

-(void)activateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    CGError	err = CGDisplayNoErr;
    CGDisplayCount		dspCount = 0;
    // Get the list of active displays
	
	/* More error-checking here. */
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Could not get active display list (%d)\n", err);
        return;
    }
    CGImageRef imageref = CGDisplayCreateImage(188826177);
    NSImage* image = [[NSImage alloc] initWithSize:screenrect.size];
    [image lockFocus];
    CGContextDrawImage([[NSGraphicsContext currentContext]
                        graphicsPort], *(CGRect*)&screenrect, imageref);
    [image unlockFocus];
    //system("screencapture -mxtpng /tmp/screenshot.png"); // Create a temporary screenshot
    //NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"];
    NSRect secondframe = NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height);
    _backwindow = [[NSWindow alloc] initWithContentRect:secondframe styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [_backwindow setReleasedWhenClosed:NO];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [_backwindow setBackgroundColor:[NSColor colorWithPatternImage:image]];
    [_backwindow setLevel:NSFloatingWindowLevel+1];
    [_backwindow setHasShadow:YES];
    windowclosebutton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,screenrect.size.width, screenrect.size.height)];
    [windowclosebutton setTarget:self];
    [windowclosebutton setAction:@selector(deactivateSiriBar)];
    [windowclosebutton setTransparent:YES];
    [[_backwindow contentView] addSubview:windowclosebutton];
    [_backwindow makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication]
     setPresentationOptions: NSApplicationPresentationHideDock];
    
    [_window setLevel:NSFloatingWindowLevel];
    [_window setStyleMask:NSBorderlessWindowMask];
    NSRect frame = NSMakeRect(0, -200, screenrect.size.width, 200);
    [_window setFrame:frame display:YES];
    [_window makeKeyAndOrderFront:self];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
    [_window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"siribar_bg_tile"]]];
}

-(void)raiseScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backwindow animator] setFrame:NSMakeRect(0, screenrect.size.height-22, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height-22) display:YES];
    if (!_extrabuttonOnRaisedScreen){
    [extrabutton setHidden:true];
    }
}

-(void)lowerScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
    [extrabutton setHidden:false];
}

-(void)deactivateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[NSAnimationContext currentContext] setDuration:_contextDuration];
    [[_backwindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES];
    [_window performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
    [_backwindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
    [[NSApplication sharedApplication] performSelector:@selector(setPresentationOptions:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
}

-(void)terminateWithOpenSiriBar {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]+_completionDelay];
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
