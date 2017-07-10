//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGAnalytics_MediaPlayer/SRGAnalytics_MediaPlayer.h>
#import <SRGDataProvider/SRGDataProvider.h>

/**
 *  Standard implementation of analytics for subdivision stemming from the data provider library. Chapters
 *  (which are subdivisions as well) can be seen as full-length segments.
 */
@interface SRGSubdivision (SRGAnalytics_DataProvider) <SRGAnalyticsSegment>

@end