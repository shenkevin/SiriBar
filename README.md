# SiriBar #

SiriBar is a little project written by me that simulates the Siri interface from the iPhone.

![SiriBar screenshot](https://dl.dropbox.com/u/31396142/siribar_screenshot.png)

## Implementing SiriBar ##

1. Copy SiriBar.h and SiriBar.m to your project.
2. Add an NSObject, and change the class to SiriBar.
3. Connect a window to the siribar object.
4. Connect a window to the extraWindow object (that is shown when raiseScreen: is called)
5. Import SiriBar.h into a class that you want to use to activate SiriBar with.
6. (optional) If you want a background for SiriBar, add an image to your project called siribar_bg_tile (use whatever image extension required). It can be a pattern/repeating image if required.
7. Create an IBOutlet for the SiriBar class (eg. siribar)
8. Connect the IBOutlet to the SiriBar object in your xib
9. Use [siribar activateSiriBar]; to activate.
It's that easy!

The six methods are:  
-(void)activateSiriBar; //To raise SiriBar  
-(void)activateSiriBar; // To raise SiriBar  
-(void)raiseScreen; // To hide the screenshot, as to reveal more information  
-(void)lowerScreen; // Opposite of the previous method  
-(void)toggleScreen; // Lowers screen if it is raised, raises screen if lowered, etc. For the lazy folk :P  
-(void)deactivateSiriBar; // Hide SiriBar and close the screenshot.  
-(void)terminateWithOpenSiriBar; // Quit your application while SiriBar is open (not really needed - you could easily do this with deactivateSiriBar and performSelector:withObject:afterDelay:)  
  
### Optional ###
• SBWindow (set this as the class of _extraWindow) - to allow _extraWindow to become key window.  
• Apple linen (named siribar_bg_tile) - Background used by Apple for Siri, Notification Centre, etc. Use this for the background of SiriBar.  
  
### Tips ###
The NSWindow extraWindow will have an NSBorderlessWindowMask, which removes the title bar. As such it cannot become key window, causing objects such as NSTextFields not to work properly. To fix this, create an NSWindow subclass and implement - (BOOL)canBecomeKeyWindow, and return true. You can also just use SBWindow, included in the optional group in the SiriBar files group.