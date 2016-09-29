//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaPlayerController+SRGAnalytics_MediaPlayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Stream measurement additions to `SRGMediaPlayerViewController`.
 *
 *  For more information about stream measurements, @see SRGMediaPlayerController+SRGAnalytics.h
 */
@interface SRGMediaPlayerViewController (SRGAnalytics_MediaPlayer)

/**
 *  Same as `-[SRGMediaPlayerViewController initWithContentURL:userInfo:]`, but with an additional parameter for 
 *  analytics label customization. These analytics labels are automatically sent in stream events generated by the
 *  player when it plays the media
 *
 *  @param trackingDelegate The tracking delegate to use. The delegate is retained
 */
- (instancetype)initWithContentURL:(NSURL *)contentURL
                  trackingDelegate:(nullable id<SRGAnalyticsMediaPlayerTrackingDelegate>)trackingDelegate
                          userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
