latest-chatty-ios
===============

See [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on how to build the app locally.

4.11.2
====
- Stopped line at bottom of some screens from rendering

4.11.1
====
- LOL tagging functionality restored

4.11.0
====
- ChattyPics replaced with Imgur for image uploads. RIP ChattyPics.
- ShackAPI option removed from Settings
- Woggle keyword notification update page accessible via Settings

4.10.4
====
- Built with Xcode 11.1 as workaround to current bug in developer tooling with text views

4.10.3
====
- Fix bug with notification prompt

4.10.2
====
- Fix bug with notifications on iOS 13

4.10.1
====
- Shack LOL tags changed: removed [ugh], added [wow] and [aww]

4.10.0
====
- Built with iOS 13 SDK
- Bug fix for make post / send message progress indication on iOS 13

4.9.0
====
- Update to Shack[LOL] view for nu[LOL]

4.8.8
====
- Analytics migration
- Code cleanup
- Tweaked default viewable post category filters
- User must accept Guidelines on first app launch
- Guidelines accessible in Settings view
- Tap author name in thread view to report user/post via Shack Message

4.8.7
====
- Added setting to enable/disable Swipe To Go Back on iPhone

4.8.6
====
- iPad keyboard shortcuts added (thanks 0vrlrd)
- Code cleanup

4.8.5
====
- Credits/License action bug fix in Settings
- 3D Touch previews added to search results

4.8.4
====
- iOS 12 support
- Bug fix for reply post text color (thanks Yanks)

4.8.3
====
- Age rating updated on App Store listing
- Message sending bug fix for unicode characters

4.8.2
====
- Safari View bar coloring now consistent with rest of app

4.8.1
====
- Swipe to go back action disabled for New Post, Reply, and Message composition screens

4.8.0
====
iPhone X Support!
-Minor changes to the Settings and Review Thread views to support the X

Landscape orientation removed from iPhone
-Can utilize landscape for external sites viewed through the Safari View browser preference

Revised iPhone gestures
-Swipe right anywhere on a child view to go back
-Swipe right to open main menu when no more views to go back to are available

Bug Fixes
-YouTube links now correctly open the YouTube app when the "Use YouTube" preference is on
-3D Touch shortcuts fixed

4.7.0
====
- Push Notifications!
    Register for push within the new "Notifications" section in the in-app settings.
    Opt-in for notifications on replies and/or vanity mentions.
- Various other minor bug fixes

4.6.2
====
- iPad Pro icon addition
- Safari View can now be dismissed with edge swipe

4.6.1
====
- Comment reply refresh bug fix

4.6.0
====
3D Touch Support (iPhone 6s & 6s Plus only)
- Peek & pop chatty threads, messages, and stories
- Peek & pop to Safari app on URLs in thread and story views
- App icon shortcuts for "Replies to me", "My Messages", "Search", and "New Comment"

Additional Changes
- iPad Pro layout tweaks
- Tweak UI of API & Browser Preference selectors in Settings
- Cancel button added to Settings
- Loading indication added to Story view
- Story title added to navigation bar when viewing story

4.5.1
====
- Revised browser preference setting to be of picker style instead of various switches
- New browser preference to allow use of iOS 9 Safari in-app view (iOS 9 only)
- Fix for 3rd party external apps not opening from Latest Chatty

4.5.0
====
- iOS 9 support
- Bug fix for post & message send not showing loading indication overlay
- New setting to allow changing reply traversal button behavior to traverse by date or sequentially
- Minor UI color changes

4.4.0
====
- New thread pinning UI: a pin button is now part of the thread/reply separator toolbar, no longer a double tap action on the navigation header
- Tap the "Password" or "Pics Password" labels in Settings to toggle viewing of passwords
- Revised ViewDeck side menu for phones, now much larger (percentage based on screen size) to better support all screen sizes
- Removed black bar from appearing behind status bar when ViewDeck menu opens due to iOS 8 now hiding status bars in landscape orientation
- Camera / Photo upload feature on iPad now utilizes the full screen
- Keyboard now overlays text inputs on Post/Message composition screens, automatically resizes it's inner size based on keyboard size & availability.
- Side menu on iPhone now larger, still behaves the same as it previously did.
- Better support for images embedded in Stories in wake of the gnuShack redesign.
- Bug fix for iPhone status bar not hiding in landscape orientation after opening a webpage in Browser view on iOS 8
- Bug fix for iPad camera/photo uploads on iOS 8
- Bug fix for pinned thread UI coloring on iPad
- Bug fix for iPad UI orientation on iOS 8
- Bug fix for story previews
- Bug fix for displaying action sheets in the wrong way on iOS 8
- Compiled in iOS 8 SDK, support iPhone 6 and 6 Plus

4.3.4
====
- Removed Flurry analytics framework
- Now use Crashlytics’ new “Answers” realtime analytics (no new code needed to be added! only enabled in the Crashlytics account)
- Support for new chatty thread URL format that started appearing post-gnuShack

4.3.3
====
- Bug fixes for iOS 8

4.3.2
====
- Bug fix for pinning while a thread is loading. Was causing a thread of id 0 to be stuck in the pinned thread dictionary that could never be removed. Failing to load this 0 id thread was not graceful and caused any other pinned threads to vanish from the chatty.
- Crashlytics version increase
- Flurry version increase

4.3.1
====
- iPad bug fix for posting new threads not clearing compose view and refreshing chatty
- iPad bug fix for message cells in portrait
- Revised error message alert view messaging when posts fail
- Support for disabling "Submit" buttons on post/message compose views until character requirements are met in all fields
- Thread view's post/reply separator bar now splits the screen by 1/3, 1/2, or 2/3 rather than the previous 1/4, 1/5, 4/5 values

4.3.0
====
- 4.2.3 RC submitted to App Store

4.2.3 Release Candidate
====
- Revised support for LOL tagging via POST instead of GET

4.2.2
====
- Pinning a thread and then popping the thread view controller off the stack back to the chatty will reflect that pinned thread at the top of the chatty list colored in the pinned color
- Unpinning a thread and then popping the thread view controller off the stack back to the chatty will reflect that the unpinned thread is now placed after any pinned threads in the unpinned color
- 4 lines of preview text for chatty cells on iPad
- Additional support for parsing more shacknews.com thread URLs to instantiate a thread view controller directed at the threadId on the URL
- New support for parsing various different shacknews.com search URLs to instantiate a search results view controller directed at the term/user/author values on the URL

4.2.1
====
- iPhone now shows three lines of preview text (up from two) in chatty/search thread cells when no [lol] tags exist for the thread ([lol] tags are never visible in search thread cells). iPad is unchanged and always showed three lines.
- iCloud support. Settings now sync across your iOS devices. The only setting that does not sync is the "Allow Landscape" preference as that is usually set differently between phone and pad devices. Collapsed threads are also synced.
- Pin threads support. Double tap the top navigation bar when viewing a thread to pin the root thread to the chatty. Pinned threads appear with a purple background color at the top of the chatty. Threads will be unpinned after they have expired. Pinned threads are also synced with iCloud.
- In-app Shack[lol] browser now maintains scroll position when going back to the Shack[lol] browser after tapping a post to load it.
- Bug fix for persisting user settings to database on device, erroneously sending the synchronize message too frequently and causing crashes. The API docs indicate to not call it unless you want immediate persistence (like on app termination), otherwise the framework periodically calls synchronize for you. All instances of immediate persistence have been removed and immediate persistence only occurs on "Save" button tap in Settings view and upon app termination.
- Bug fix for accessing comments attached to a story before the story has finished loading (and thus provides the correct id to the threads loader for loading only threads attached that story).

4.2.0
====
- 4.1.3 RC submitted to App Store

4.1.3 Release Candidate
====
- lol tags visually changed. They are no longer colored badges, but rather colored text. Font was also made bold and size increased.
- Removed "x" separator from lol tags
- Bug fix for threads that only contained custom tags (custom tags aren't shown in the app on purpose)
- Tag construction code refactored
- Lowercased the tags in the action sheet when tagging a post for consistency purposes
- Short date stamps now only occur on dates that are <24 hours old. Short date stamps are now available on messages and in thread view as well (again, only if they are <24 hours old).
- UI tweaks to layout of objects in thread cells
- Changed wording of some Settings preferences

4.1.2
====
- Date stamps changed for chatty/search view table cells. Now displays one of the follow depending on "time ago" criteria:
Xyr ago
Xd ago
Xhr Xm ago
Xm ago
Xs ago
where Xyr = years, Xd = days, Xhr = hours, Xm = minutes, Xs = seconds
- Tweaks to lol tag fetching, now fetches on thread refresh in addition to chatty refresh (5 minute caching still applies to both)
- Removed category color stripes in replies table cells, entire cell background now colored with category color
- Minor interface alignment tweaks

4.1.1
====
- Initial pass at support for LOL Tags! Some items of note:
Enable in Settings with setting "LOL Tags"
Will fetch current LOL tags on app load and every chatty refresh if it's been 5 minutes since the last fetch
Tags are visible in the main chatty view's table cells, thread view's post view and replies table cells
Replies table will show a colored tag icon for the tag with the highest count (first tag encountered will show in event of tie)
There is not currently a threshold for tag display, ie: a thread with 1x lol tag will show the tag. Can result in threads being a little noisy, so a threshold of say 5 before a tag is rendered may be desirable.
Because the INF tag looks similar to the current "blue ball" indicator in the replies table, indication of a post made by you in the replies table now colors the preview text (and author name on iPad) blue, removing all use of the "blue ball" indicator
- Padded post text in post view and compose view slightly for easier text selection
- Root post author names now colored yellow in replies table on iPad
- Phone number detection disabled for web pages loaded in browser view
- Built for 64 bit iOS

4.1
====
- 4.0.3 RC submitted to App Store

4.0.3 Release Candidate
====
- Removed text shadows throughout
- Revised error messaging/handling
- Ability to reload chatty via an alert view if it fails to load
- Username colored blue for current user in replies table on iPad
- Username colored white when row selected in replies table on iPad
- API server picker view sized correctly for iPad
- Bug fix for dealloc of Browser vc
- One-time reset applied to all users' API server address setting to winchatty
- Shelfed "Chatty Tags" feature for now
- Removed Donation button in Settings

4.0.2
====
- API server selector picker view in Settings, includes manual entry as well
- API server defaults to winchatty.com/chatty for new/fresh app installs
- Mod requests send a reindex request to winchatty regardless of API selection
- Keyboards fly up after view fully loads now
- Search segemented control colored gray now
- Bug fix for opening links in Chrome
- Bug fix for iPad popovers (fixed bug by removing their use altogether, lol!)
- Bug fix for shrinking of user names in iPad replies table
- Bug fix for pull-to-refresh control, will now cancel refreshing when view disappears or app is backgrounded
- Bug fix for volume slider in videos played through Browser view
- Potential bug fix for intermittent shack message sending bug
- ShackLOL on iPad now expands to full screen upon navigation
- Links inside spoiler tags are now hidden until revealed, with an underline to signify that a link is in the spoiler
- Reduced weight of iPad italic text, always looked bold + italic previously
- Image picker for iPad now has a dark gray colored navigation bar rather than light gray
- Stories and Message viewing now on top of a pure black background
- Donation button added to Settings view
- Activity indicator bug fix
- Badge number bug fix on main menu list items
- Experimental "Chatty Tags" feature to create attributed strings from the body of posts when generating the Chatty vc table cells

4.0.1
====
- Bug fixes for Browser view on iPhone/iPad
- Bug fix for selection of infinite loading cell in Chatty/Search Results views

4.0
====
- 3.4.14 RC submitted to App Store

3.4.14 Release Candidate
====
- Tap status bar in Thread view to scroll replies table to the top
- Scroll indicators lightened so that scroll position is easier to see on the dark backgrounds
- iPad Browser view toolbar relocated to bottom of screen (like iPhone)
- Story view no long shows title of story in nav bar
- Stories view comment count no longer tappable to jump to chatty attached to story
- Chatty button on top right of Story view now jumps directly to Thread view for the thread associated with the story (nuShack only), legacy stories that don't have a single comment thread continue to load a Chatty view of comments for the story
- Thread traversal buttons now point up and down instead of left and right
- Resolved the updating of the in-app badge count on the messages icon for unread messages
- ChattyPics uploads now append a space to the end of the generated URL that is pasted into post view (to prevent someone from uploading multiple images back-to-back and having the URLs run together)
- Fixed thread separator toolbar shadow image alignment
- Flurry analytics integration
- Remove some logging and old pre-iOS 6 fallback code

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
