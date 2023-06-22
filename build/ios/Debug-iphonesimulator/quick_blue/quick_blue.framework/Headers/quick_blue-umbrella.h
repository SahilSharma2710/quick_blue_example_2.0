#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QuickBluePlugin.h"

FOUNDATION_EXPORT double quick_blueVersionNumber;
FOUNDATION_EXPORT const unsigned char quick_blueVersionString[];

