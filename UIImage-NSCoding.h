//
//  UIImage-NSCoding.h

#import <Foundation/Foundation.h>

@interface UIImage(NSCoding) <NSCoding>
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end

