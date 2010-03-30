# HKHelperKit

HKHelperKit fixes some annoyances when developing Objective-C applications.  Mostly it just adds some methods to SDK classes to make them easier and less verbose to use.

## Usage

1. Clone this repository into a `HKHelperKit` subfolder within your project.
2. Drag the `HKHelperKit` folder into XCode.
3. Now simply use `#include "HKHelperKit.h"` anywhere that you want to use `HKHelperKit` methods.

## Features

_This list is WAY out of date...  Just checkout the header files to see what's up._

`HKHelperKit` enhances the following classes in the following ways:

### NSString

* `[NSString stringFromResource:@"MyFile.html"];` loads an app resource from teh main bundle with teh provided file name into an autoreleased string.
* Simple search methods
    * `[@"foobar" conatinsString:@"oob"];`
    * `[@"foobar" startsWithString:@"foo"];`
    * `[@"foobar" endsWithString:@"bar"];`
* `[someString isPresent];` method that is shorthand for: `string != nil && ![string isEqualToString:@""];`.
* `[@"foobar" compareCaseInsensitive:@"FooBAR"];`
* `NSData` conversion
    * `[NSString stingWithData:someNSDataObject];`
    * `[NSString stingWithData:someNSDataObject encoding:NSASCIIStringEncoding];`
    * `[@"foobar" data]`
* `[@"foo/space here" stringByEscapingURL]` => `@"foo%2Fspace%20here"`
* `[@"foo/space here" stringByPercentEscapingCharacters:@" "]` => `@"foo/space%20here"`

### UIAlertView

* `[UIAlertView showSimpleAlertWithTitle:@"A Title" message:@"A Message!"];` Shows an alert with an `OK` button
* `[UIAlertView showSimpleAlertWithTitle:@"A Title" message:@"A Message!" buttonTitle:@"Not OK"];` Shows an alert with a single custom button title

### UIBarButtonItem

* Convenience Initializers
    * `[UIBarButtonItem itemWithSystemType:UIBarButtonSystemItemAdd];`
    * `[UIBarButtonItem itemWithSystemType:UIBarButtonSystemItemAdd target:object action:@selector(someSelector)];`
    * `[UIBarButtonItem itemWithTitle:@"foobar" target:object action:@selector(someSelector)];`
    * `[UIBarButtonItem itemWithImage:someUIImage target:object action:@selector(someSelector)];`
    * `[UIBarButtonItem flexibleSpace];`
    * `[UIBarButtonItem fixedSpace:123];`

### UIImage

* Added `NSCoding` support to `UIImage`
* `[someImage imageByResizing:CGSizeMake(123, 456)];`

### UINavigationController

* `navigationController.backViewController` read only property that works just like `topViewController` except it return the controller immediately preceding the top one (or nil).

### UIViewController

* Convenience Initializers
    * `[UIViewController controller];`
    * `[UIViewController controllerWithNib];` This loads the nib with the same name as the view controller class.  `[MyController controllerWithNib]` is the same as `[[[MyController alloc] initWithNibName:@"MyController" bundle:nil] autorelease]`
    * `[UIViewController controllerWithNibName:@"SomeNibName"];`
    * `[UIViewController controllerWithNibName:@"SomeNibName" bundle:someBundle];`
    * `[[UIViewController alloc] initWithNibName:@"SomeNibName"];`
    * `[[UIViewController alloc] initWithNib];` instance level initializer that works as described in the `controllerWithNib` class method.