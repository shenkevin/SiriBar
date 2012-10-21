//
//  AppDelegate.h
//  SiriBar
//
//  Created by Evan Petousis on 20/10/12.
//  Copyright (c) 2012 1-Bit Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SiriBar.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet SiriBar *siribar;
    Boolean screenraised;
}

-(IBAction)activateSiriBar:(id)sender;
-(IBAction)deactivateSiriBar:(id)sender;
-(IBAction)toggleScreen:(id)sender;
-(IBAction)showaboutwindow:(id)sender;

@end
