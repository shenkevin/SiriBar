//
//  SiriBar.h
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiriBar : NSObject {
    Boolean screenRaised;
    Boolean setupDone;
    CGFloat siribarHeight;
    NSButton *windowCloseButton; // the fullscreen button that when clicked on, closes SiriBar. This button is assigned to backwindow.
    NSWindow *backWindow;
    IBOutlet NSButton *extraButton;
    CGDirectDisplayID *displays;
}

@property (weak) IBOutlet NSWindow *window;
@property (strong) NSWindow *backWindow;

-(void)activateSiriBar; // To raise SiriBar
-(void)raiseScreen; // To hide the screenshot, as to reveal more information
-(void)lowerScreen; // Opposite of the previous method
-(void)toggleScreen; // Lowers screen if it is raised, raises screen if lowered, etc. For the lazy folk :P
-(void)deactivateSiriBar; // Hide SiriBar and close the screenshot.
-(void)terminateWithOpenSiriBar; // Quit your application while SiriBar is open (not really needed - you could easily do this with deactivateSiriBar and performSelector:withObject:afterDelay:)

@end
