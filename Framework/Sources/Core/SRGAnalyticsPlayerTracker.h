//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  @name Media player events
 */
typedef NS_ENUM(NSInteger, SRGAnalyticsPlayerState) {
    /**
     *  The player is buffering.
     */
    SRGAnalyticsPlayerStateBuffering = 1,
    /**
     *  The player is currently playing content.
     */
    SRGAnalyticsPlayerStatePlaying,
    /**
     *  Playback is paused.
     */
    SRGAnalyticsPlayerStatePaused,
    /**
     *  The player is seeking.
     */
    SRGAnalyticsPlayerStateSeeking,
    /**
     *  The player is stopped (interrupting playback).
     */
    SRGAnalyticsPlayerStateStopped,
    /**
     *  Playback ended normally.
     */
    SRGAnalyticsPlayerStateEnded,
    /**
     *  Normal heartbeat.
     */
    SRGAnalyticsPlayerStateHeartbeat,
    /**
     *  Live heartbeat (to be sent when playing in live conditions only).
     */
    SRGAnalyticsPlayerStateLiveHeartbeat
};

/**
 *  Additional playback measurement labels.
 */
@interface SRGAnalyticsPlayerLabels : NSObject <NSCopying>

/**
 *  @name Player information
 */

/**
 *  The media player display name, e.g. "AVPlayer" if you are using `AVPlayer` directly.
 */
@property (nonatomic, copy, nullable) NSString *playerName;

/**
 *  The media player version.
 */
@property (nonatomic, copy, nullable) NSString *playerVersion;

/**
 *  The volume of the player, on a scale from 0 to 100.
 *
 *  @discussion As the name suggests, this value must represent the volume of the player. If the player is not started or
 *              muted, this value must be set to 0.
 */
@property (nonatomic, nullable) NSNumber *playerVolumeInPercent;        // Long

/**
 *  @name Playback information
 */

/**
 *  Set to `@YES` iff subtitles are enabled at the time the measurement is made.
 */
@property (nonatomic, nullable) NSNumber *subtitlesEnabled;             // BOOL

/**
 *  Set to the current positive shift from live conditions, in milliseconds. Must be 0 for live streams without timeshift 
 *  support, and `nil` for on-demand streams.
 */
@property (nonatomic, nullable) NSNumber *timeshiftInMilliseconds;      // Long

/**
 *  The current bandwidth in bits per second.
 */
@property (nonatomic, nullable) NSNumber *bandwidthInBitsPerSecond;     // Long

/**
 *  @name Custom information
 */

/**
 *  Additional custom information, mapping variables to values. See https://srfmmz.atlassian.net/wiki/spaces/INTFORSCHUNG/pages/197019081 
 *  for a full list of possible variable names.
 *
 *  You should rarely need to provide custom information with measurements, as this requires the variable name to be
 *  declared on TagCommander portal first (otherwise the associated value will be discarded).
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *customInfo;

/**
 *  Additional custom information to be sent to comScore. See https://srfmmz.atlassian.net/wiki/spaces/SRGPLAY/pages/36077617/Measurement+of+SRG+Player+Apps
 *  for a full list of possible variable names.
 *
 *  @discussion This information is sent in Stream Sense.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *comScoreCustomInfo;

/**
 *  Additional custom segment information to be sent to comScore. See https://srfmmz.atlassian.net/wiki/spaces/SRGPLAY/pages/36077617/Measurement+of+SRG+Player+Apps
 *  for a full list of possible variable names.
 *
 *  @discussion This information is sent in StreamSense clips.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *comScoreCustomSegmentInfo;

/**
 *  Merge the receiver with the provided labels (overriding values defined by it, otherwise keeping available ones).
 *  Use this method when you need to override full-length labels with more specific segment labels (use `-copy` to
 *  start with a copy if you don't want to preserve the original values for later).
 *
 *  @discussion Custom value dictionaries are merged as well.
 */
- (void)mergeWithLabels:(nullable SRGAnalyticsPlayerLabels *)labels;

@end

/**
 *  Tracker for media playback consumption. This tracker ensures that the media analytics event sequences are always
 *  reliable, guaranteeing correct measurements.
 *
 *  When you need to track a new media playback, simply instantiate an `SRGAnalyticsPlayerTracker`, keeping a strong
 *  reference to it, and call the tracking method when you need to record an event.
 *
 *  Implementing media player tracking is tricky to get right, and should only be required if your player is not based
 *  on SRG MediaPlayer (e.g. if you use `AVPlayer` directly). Please refer to the official documentation more information:
 *    https://srfmmz.atlassian.net/wiki/spaces/INTFORSCHUNG/pages/195595938/Implementation+Concept+-+draft
 */
@interface SRGAnalyticsPlayerTracker : NSObject

/**
 *  Set to `YES` when playing a livestream.
 *
 *  @discussion This state should be changed before the player state is updated to playing. Otherwise, the position won't 
 *              be correct during playback.
 */
@property (nonatomic, getter=isLivestream) BOOL livestream;

/**
 *  Update the tracker with the specified state and player information. An update will only result in an event when necessary.
 *  You should update the state when appropriate (and as often as it is fit) to accurately match the state of the player.
 *
 *  @param state    The current player state.
 *  @param position The current player playback position, in milliseconds.
 *  @param labels   Additional detailed information.
 */
- (void)updateWithPlayerState:(SRGAnalyticsPlayerState)state
                     position:(NSTimeInterval)position
                       labels:(nullable SRGAnalyticsPlayerLabels *)labels;

@end

NS_ASSUME_NONNULL_END
