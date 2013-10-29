latest-chatty-2
===============

iOS 7 Conversion Fork
To be merged back to squeegy's master repo once completed.

3.4.14
====
- Tap status bar in Thread view to scroll replies table to the top
- Scroll indicators lightened so that scroll position is easier to see on the dark backgrounds

3.4.13
====
- Thread separator toolbar buttons positioned evenly across bar when mod tools are on or off
- Thread separator toolbar for iPad same as iPhone now, buttons no longer across the top of the app, buttons in thread toolbar now (I could make top or thread separator toolbar an option I suppose...)
- Alignment fix for thread timer pie icon
- Date color in Thread view matched with date color in Chatty view
- Keyboard hides properly with the Done button in Settings on iPad
- Keyboard hides properly when scrolling the Settings view on iPad
- Cell animation into view disabled for all tables (the animation was quick, but can potentially block user input when scrolling very fast via flick)
- Image picker control now cancels correctly on iPad
- Removed references to no-longer-existing images in some nib files
- Side menu parallax effect increased slightly

3.4.12
====
- Build to add more beta testers to provisioning profile
- Minor change to network activity indicator usage when uploading to Chattypics

3.4.11
====
- Fixed visual bug with Chatty view navigation bar
- New iPad launch images
- Post tagging view for iPad fixed
- Minor message cell frame adjustments for iPad
- Minor search view frame adjustments
- Adjusted spacing of side menu icons for iPhone
- Revised the way unread message badges are calculated and applied within the app and on the app icon in Springboard

3.4.10
====
- Initial iPad build
- (x) to clear text fields on Search view is now functional again
- Better network activity indicator usage
- Side menu item spacing evened out for both iPhones
- Farts on scroll instead of cell tap
- Crashlytics integration
- Revised timer pie icons
- Recent Search buttons now have colored border around them
- Credits/Licenses buttons in Settings now have colored border around them
- Capitalized mod tags
- Opening the side menu while Browser view is in full screen mode will bring the browser bars back into view

3.4.9
====
- New icons in Browser view's bottom toolbar
- Any showing keyboard is always dismissed when the side menu is toggled or panned open
- Minor visual change to top navigation bars (white stroke added to bottom)
- Launch image update due to navigation bar tweak
- All various NSDateFormatter instances are now a singleton instance
- App now checks for new shackmessages when the side menu is panned open if it's been 5 minutes since the last check
- Side menu background now scales to fill height of menu
- Visual redesign for the tagging interface while composing a post

3.4.8
====
- Parallax effect added to side menu open/close action
- Side menu is now the same width size regardless of orientation
- Side menu now has a fixed background image
- Revised the implementation of changing the color of the bar under status area & menu button color when side menu is open/closed with toggle or pan gesture, no longer a bug when panning menu completely closed
- Post category bar and expiration bar color tweaks
- Resolve alignment bug with loading spinner when loading a section from the side menu

3.4.7
====
- Further updates to UI: coloring, images, etc.
- Navigation/toolbars are now opaque
- New launch image due to navigation bar change
- Table cells now animate their opacity in slightly when they are scrolled into view
- Opening the side menu now animates a black bar into view underneath the status text area
- Top left menu button changes color when side menu is opened
- Browser view bottom toolbar buttons evenly spaced apart

3.4.6
====
- New icons throughout, do not have replacement icons for Browser view bottom toolbar yet

3.4.5
====
- UI darkened by default, dark mode removed (will be going farther with this to allow a white theme similar to stock iOS 7 apps)
- Typography updated for less Helvetica Neue Light and more Helvetica Neue Regular (iOS 7 system font)
- Project converted from manual reference counting to automatic reference counting (ARC) -- Thanks Yanks!
- Removal of SBJSON dependency -- Thanks Yanks!
- Removal of RegexKit dependency -- Thanks Yanks!
- Testing out moving the thread timestamp to the bottom right of cell (like the iPad does), not certain this will remain
- Recent Search saving is now controllable via a user setting
- Settings preferences alphabetized
- Potential bottom toolbar fix for Browser view when transitioning between full and non-full screen view mode
- Browser view's title now displays "Loading..." while loading the external page, title becomes the HTML document's <title> after the page has finished loading
- Better fart randomization
- Search view usable with both orientations again
- Build version added to iOS Settings.app app entry (working on that saved state user option there next)
- Side menu just shows active state on icon instead of entire cell being highlighted now

3.4.4
====
- Uploading images no longer changes the status bar text color to black.
- Post/message body text input on Compose and Send Message views now sizes automatically to fill the view based on the keyboard. The text input animates in size to expand/shrink when the keyboard is open or dismissed.
- Tapping a Recent Search button now bubbles that recent search to the top of the list the next time Recent Search view is accessed.

3.4.3
====
- 1px blue dot beside the chat bubbles in Stories view fixed
- Status bar loading indicator appears/disappears as necessary now
- Loading spinner in Browser view removed completely in favor of the status bar loading indicator (which means there is no loading indicator visible when Browser view is full screen after scrolling down the page). I'd like to make a thin progress bar at the top of the screen similar to iOS 7 Safari in the end.
- Testing an open source component to replace the loading overlays. They are visible when loading a main section, loading a thread, or tagging a thread only for now.
- Super Secret Fart Mode added (how to enable it is a secret!)

3.4.2
====
- Search view UI has been touched up, search button under the terms/author/parent table has been removed in favor of a top right navigation bar button to do the same thing. This top right button hides when on the "Recent" segment.
- Browser view now hides all bars (status bar, nav bar, tool bar) when starting to scroll down a page above a certain velocity. Starting a scroll back up the page with a certain velocity will bring back the bars. It's kind of like iOS 7 Safari but not as good because I suck.

3.4.1
====
- Open source pull to refresh component ditched in favor of built-in SDK refresh control (no more "last refresh" date label though however)
- SDK refresh control stays visible until refresh completes and the loading overlay is not used during refresh
- Thread/replies separator bar and all buttons are swipe-able up/down to move bar
- Thread/replies now even spaces all buttons and ditched the grippy handle in the center due to the above change
- Bunch of under the cover memory management clean up crap, it could be crashy?
- Settings now pans text fields into view when focused, and animates the keyboard away on touch scroll
- New app icon

3.4.0
====
- Initial iOS 7 rewrite build
