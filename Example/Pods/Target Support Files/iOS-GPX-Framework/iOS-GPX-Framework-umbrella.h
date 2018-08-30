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

#import "GPX.h"
#import "GPXAuthor.h"
#import "GPXBounds.h"
#import "GPXConst.h"
#import "GPXCopyright.h"
#import "GPXElement.h"
#import "GPXElementSubclass.h"
#import "GPXEmail.h"
#import "GPXExtensions.h"
#import "GPXLink.h"
#import "GPXMetadata.h"
#import "GPXParser.h"
#import "GPXPerson.h"
#import "GPXPoint.h"
#import "GPXPointSegment.h"
#import "GPXRoot.h"
#import "GPXRoute.h"
#import "GPXRoutePoint.h"
#import "GPXTrack.h"
#import "GPXTrackPoint.h"
#import "GPXTrackSegment.h"
#import "GPXType.h"
#import "GPXWaypoint.h"

FOUNDATION_EXPORT double iOS_GPX_FrameworkVersionNumber;
FOUNDATION_EXPORT const unsigned char iOS_GPX_FrameworkVersionString[];

