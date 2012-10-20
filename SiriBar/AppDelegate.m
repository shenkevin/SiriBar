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
    [self activateSiriBar];
}

-(void)activateSiriBar {
    [[NSApplication sharedApplication]
     setPresentationOptions:   NSApplicationPresentationAutoHideMenuBar
     | NSApplicationPresentationAutoHideDock];
    NSRect screenrect = [[NSScreen mainScreen] frame];
    system("screencapture -mxtpng /tmp/screenshot.png"); // Create a temporary screenshot
    //NSURL *imgurl = [[NSURL alloc] initFileURLWithPath:@"file:///tmp/screenshot.png"];
    NSImage *screenimg = [[NSImage alloc] initWithContentsOfFile:@"/tmp/screenshot.png"];
    NSRect secondframe = NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height);
    [_screenwindow setStyleMask:NSBorderlessWindowMask];
    [_screenwindow setFrame:secondframe display:YES];
    [[_screenwindow animator] setFrame:NSMakeRect(0, 200, screenrect.size.width, screenrect.size.height) display:YES];
    [_screenwindow setBackgroundColor:[NSColor colorWithPatternImage:screenimg]];
    [_screenwindow setLevel:NSFloatingWindowLevel];
    [_screenwindow makeKeyAndOrderFront:NSApp];
    
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

-(void)deactivateSiriBar {
    NSRect screenrect = [[NSScreen mainScreen] frame];
    [[_screenwindow animator] setFrame:NSMakeRect(0, 0, screenrect.size.width, screenrect.size.height) display:YES];
    [[_window animator] setFrame:NSMakeRect(0, -200, screenrect.size.width, 200) display:YES];
    [[NSApplication sharedApplication] setPresentationOptions:nil];
    //[_screenwindow close];
}

-(IBAction)showaboutwindow:(id)sender {
    [self deactivateSiriBar];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

@end
