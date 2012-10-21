# SiriBar #

SiriBar is a little project written by me that simulates the Siri interface from the iPhone.

## Implementing SiriBar ##

1. Copy SiriBar.h and SiriBar.m to your project.
2. Add an NSObject, and change the class to SiriBar.
3. Connect a window (for best effect make this window 200px high) to the window object.
4. (optional) If you want an extra button, connect a button to the extrabutton object (so it can hide and show at the appropriate time)
5. Import SiriBar.h into a class that you want to use to activate SiriBar with.
6. (optional) If you want a background for SiriBar, add an image to your project called siribar_bg_tile (use whatever image extension required). It can be a pattern/repeating image if required.
7. Create an IBOutlet for the SiriBar class (eg. siribar)
8. Connect the IBOutlet to the SiriBar object in your xib
9. Use [siribar activateSiriBar]; to activate.
It's that easy!

The six primary methods are:  
-(void)activateSiriBar; //To raise SiriBar  
-(void)activateSiriBar; // To raise SiriBar  
-(void)raiseScreen; // To hide the screenshot, as to reveal more information  
-(void)lowerScreen; // Opposite of the previous method  
-(void)toggleScreen; // Lowers screen if it is raised, raises screen if lowered, etc. For the lazy folk :P  
-(void)deactivateSiriBar; // Hide SiriBar and close the screenshot.  
-(void)terminateWithOpenSiriBar; // Quit your application while SiriBar is open (not really needed - you could easily do this with deactivateSiriBar and performSelector:withObject:afterDelay:)  