//
//  SiriBar.h
//  SiriBar
//
//  Created by Tasos Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiriBar : NSObject {
    Boolean screenraised;
    NSButton *windowclosebutton; // the fullscreen button that when clicked on, closes SiriBar. This button is assigned to backwindow.
    NSWindow *backwindow;
    IBOutlet NSButton *extrabutton;
}

@property (weak) IBOutlet NSWindow *window;
@property (retain) NSWindow *backwindow;

-(void)activateSiriBar;
-(void)raiseScreen;
-(void)lowerScreen;
-(void)toggleScreen;
-(void)deactivateSiriBar;
-(void)terminateWithOpenSiriBar;

@end
