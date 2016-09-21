//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "Segment.h"

#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentsPlayerViewController : UIViewController <SRGTimelineSliderDelegate, SRGTimelineViewDelegate, SRGTimeSliderDelegate>

- (instancetype)initWithContentURL:(NSURL *)contentURL identifier:(NSString *)identifier segments:(nullable NSArray<Segment *> *)segments userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
