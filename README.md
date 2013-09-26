latest-chatty-2
===============

iOS 7 Conversion / Semi-rewrite

*Disclaimers/Known Issues:
- Colors, fonts, etc. aren't finalized as I am trying out different things.
- iPad has not been touched yet at all, probably blows up completely there.
- The (x) to clear text fields on Search view isn't currently working.
- The status bar background color change when menu is opened is not fully functional yet

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
- Super Secret Fart Mode added. This is an easter egg, so don't tell the shack about it! I want someone to find it on their own :) Protip: go to Settings view and try shaking your device

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
