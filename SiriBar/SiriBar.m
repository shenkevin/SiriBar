//
//  SiriBar.m
//  SiriBar
//
//  Created by Tasos Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import "SiriBar.h"

@implementation SiriBar

-(void)activateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    system("screencapture -mxtpng /tmp/screenshot.png"); // Create a temporary screenshot
    //NSURL *imgurl = [[NSURL alloc] initFileURLWithPath:@"file:///tmp/screenshot.png"];
    NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"];
    NSRect secondframe = NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height);
    _backwindow = [[NSWindow alloc] initWithContentRect:secondframe styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    //[_backwindow setStyleMask:NSBorderlessWindowMask];
    //[_backwindow setFrame:secondframe display:YES];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [_backwindow setBackgroundColor:[NSColor colorWithPatternImage:screenimg]];
    [_backwindow setLevel:NSFloatingWindowLevel];
    windowclosebutton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,screenrect.size.width, screenrect.size.height)];
    [windowclosebutton setTarget:self];
    [windowclosebutton setAction:@selector(hidesiri:)];
    [windowclosebutton setTransparent:YES];
    [[_backwindow contentView] addSubview:windowclosebutton];
    [_backwindow makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication]
     setPresentationOptions: NSApplicationPresentationHideDock];
    
    [_window setLevel:NSFloatingWindowLevel+1];
    [_window setStyleMask:NSBorderlessWindowMask];
    NSRect panelRect = [[self window] frame];
    //panelRect.size.height = _HEIGHT;
    panelRect.size.width = screenrect.size.width;
    panelRect.origin.x = 0;
    panelRect.origin.y = 0;
    NSRect frame = NSMakeRect(0, -200, screenrect.size.width, 200);
    [_window setFrame:frame display:YES];
    [_window makeKeyAndOrderFront:self];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
    [_window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"linen_bg_tile"]]];
}

-(void)raiseScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, screenrect.size.height, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
}

-(void)lowerScreen {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, 200) display:YES];
}

-(void)deactivateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_backwindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES];
    [_window performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
    [_backwindow performSelector:@selector(close) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
    [[NSApplication sharedApplication] performSelector:@selector(setPresentationOptions:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
}

-(IBAction)showaboutwindow:(id)sender {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

-(IBAction)hidesiri:(id)sender {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
}

-(IBAction)hidescreenshot:(id)sender {
    if (!screenraised) {
        NSLog(@"raise");
        [self raiseScreen];
        [extrabutton setHidden:true];
        screenraised=true;
    }else{
        NSLog(@"lower");
        [self lowerScreen];
        [extrabutton setHidden:false];
        screenraised=false;
    }
}

@end
