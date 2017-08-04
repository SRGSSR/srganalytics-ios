//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGAnalytics/SRGAnalytics.h>
#import <SRGMediaPlayer/SRGMediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Streaming measurement additions to SRGAnalytics. The SRGAnalytics_MediaPlayer framework is an optional SRGAnalytics
 *  companion framework which can be used to easily measure audio and video consumption in applications powered by 
 *  the SRG MediaPlayer library. If you need to implement streaming measurements for other players, use an instance of
 *  `SRGAnalyticsPlayerTracker`.
 *
 *  When playing a media, two levels of analytics information (labels) are consolidated:
 *    - Labels associated with the content URL being played.
 *    - Labels associated with segment being played, which are merged and might override content URL labels.
 *
 *  The SRGAnalytics_MediaPlayer framework automatically takes care of content and segment playback tracking, and 
 *  supplies mechanisms to add your custom measurement labels to stream events if needed.
 *
 *  ## Usage
 *
 *  Simply add `SRGAnalytics_MediaPlayer.framework` to your project (which should already contain the main
 *  `SRGAnalytics.framework` as well as `SRGMediaPlayer.framework` as dependencies).
 *
 *  The tracker itself must have been started before any measurements can take place (@see `SRGAnalyticsTracker`).
 * 
 *  By default, provided a tracker has been started, all SRG MediaPlayer controllers are automatically tracked without any
 *  additional work. You can disable this behavior by setting the `SRGMediaPlayerController` `tracked` property to `NO`.
 *  If you do not want any events to be emitted by a player, you should set this property to `NO` before beginning
 *  playback.
 *
 *  By default, standard SRG playback information (playhead position, type of event, etc.) is sent in stream events.
 *  To supply additional measurement information (e.g. title or duration), you must use custom labels.
 *
 *  ## Additional measurement labels
 *
 *  You can supply additional custom measurement labels with stream events sent from your application. These labels
 *  are provided through `SRGAnalyticsPlayerLabels` instances whose properties can be set depending on which information
 *  is needed.
 *
 *  Custom information can be added to both content and segment labels. When playing a segment, its labels are merged
 *  with labels associated with the content, overriding existing keys. You can take advantage of this behavior to add
 *  segment information on top of content labels.
 *  
 *  ### Labels associated with the content
 *
 *  Labels associated with a media being played can be supplied when starting playback, using one of the plaback
 *  methods made available below. 
 *
 *  ### Labels associated with a segment
 *
 *  To supply labels for a segment, have your segment model class conform to the `SRGAnalyticsSegment` protocol instead 
 *  of `SRGSegment`, and implement the required `srg_analyticsLabels` method.
 */
@interface SRGMediaPlayerController (SRGAnalytics_MediaPlayer)

/**
 *  Same as `-[SRGMediaPlayerController prepareToPlayURL:atTime:withSegments:userInfo:completionHandler:]`, but with optional
 *  analytics labels.
 *
 *  @param analyticsLabels The analytics labels to send in stream events.
 */
- (void)prepareToPlayURL:(NSURL *)URL
                  atTime:(CMTime)time
            withSegments:(nullable NSArray<id<SRGSegment>> *)segments
         analyticsLabels:(nullable SRGAnalyticsPlayerLabels *)analyticsLabels
                userInfo:(nullable NSDictionary *)userInfo
       completionHandler:(nullable void (^)(void))completionHandler;

/**
 *  Same as `-[SRGMediaPlayerController playURL:atTime:withSegments:userInfo:]`, but with optional analytics labels.
 *
 *  @param analyticsLabels The analytics labels to send in stream events.
 */
- (void)playURL:(NSURL *)URL
         atTime:(CMTime)time
   withSegments:(nullable NSArray<id<SRGSegment>> *)segments
analyticsLabels:(nullable SRGAnalyticsPlayerLabels *)analyticsLabels
       userInfo:(nullable NSDictionary *)userInfo;

/**
 *  Same as `-[SRGMediaPlayerController prepareToPlayURL:atIndex:inSegments:withUserInfo:completionHandler:]`, but with 
 *  optional analytics labels.
 *
 *  @param analyticsLabels The analytics labels to send in stream events.
 */
- (void)prepareToPlayURL:(NSURL *)URL
                 atIndex:(NSInteger)index
              inSegments:(NSArray<id<SRGSegment>> *)segments
     withAnalyticsLabels:(nullable SRGAnalyticsPlayerLabels *)analyticsLabels
                userInfo:(nullable NSDictionary *)userInfo
       completionHandler:(nullable void (^)(void))completionHandler;

/**
 *  Same as `-[SRGMediaPlayerController playURL:atIndex:inSegments:withUserInfo:]`, but with optional analytics labels.
 *
 *  @param analyticsLabels The analytics labels to send in stream events.
 */
- (void)playURL:(NSURL *)URL
        atIndex:(NSInteger)index
     inSegments:(NSArray<id<SRGSegment>> *)segments
withAnalyticsLabels:(nullable SRGAnalyticsPlayerLabels *)analyticsLabels
       userInfo:(nullable NSDictionary *)userInfo;

/**
 *  Set to `NO` to disable automatic player controller tracking. The default value is `YES`.
 *
 *  @discussion Media players are tracked between the time they prepare a media for playback and the time they return to
 *              the idle state. You can start and stop tracking at any time, which will automatically send the required
 *              stream events. If you do not want to track a player at all, be sure that you set this property to `NO`
 *              before starting playback
 */
@property (nonatomic, getter=isTracked) BOOL tracked;

@end

NS_ASSUME_NONNULL_END
