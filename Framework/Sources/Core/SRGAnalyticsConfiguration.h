//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  @name Supported business units
 */
typedef NSString * SRGAnalyticsBusinessUnitIdentifier NS_STRING_ENUM;

OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierRSI;
OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierRTR;
OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierRTS;
OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierSRF;
OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierSRG;
OBJC_EXPORT SRGAnalyticsBusinessUnitIdentifier const SRGAnalyticsBusinessUnitIdentifierSWI;

@interface SRGAnalyticsConfiguration : NSObject <NSCopying>

/**
 *  Create a measurement configuration.
 *
 *  @param businessUnitIdentifier The identifier of the business unit which measurements are made for. Usually the
 *                                business unit which publishes the application.
 *  @param container              The TagCommander container identifier to which measurements will be sent. Check with
 *                                the team responsible for measurements of your application to get the correct container
 *                                to use.
 *  @param comScoreVirtualSite    The comScore virtual site to which measurements must be sent. Check with
 *                                the team responsible for measurements of your application to get the correct site to use.
 *  @param netMetrixIdenfifier    The NetMetrix application identifier to send measurements for. Check with
 *                                the team responsible for measurements of your application to get the correct identifier
 *                                to use.
 */
- (instancetype)initWithBusinessUnitIdentifier:(SRGAnalyticsBusinessUnitIdentifier)businessUnitIdentifier
                                     container:(NSInteger)container
                           comScoreVirtualSite:(NSString *)comScoreVirtualSite
                           netMetrixIdentifier:(NSString *)netMetrixIdentifier;

/**
 *  Set to `YES` if measurements are studied by the General SRG SSR Direction, to `NO` if the business
 *  unit itself will perform the studies.
 *
 *  Default value is `NO`.
 */
@property (nonatomic, getter=isCentralized) BOOL centralized;

/**
 *  Set to `YES` to unit test measurements.
 *
 *  Default value is `NO`.
 *
 *  @discussion When unit testing is enabled, notifications are emitted so that unit tests can verify what information is
 *              being sent and when. Note that:
 *                - TagCommander service calls will be disabled, and the hearbeat will be reduced to 3 seconds.
 *                - NetMetrix and comScore service calls will be disabled.
 */
@property (nonatomic, getter=isUnitTesting) BOOL unitTesting;

/**
 *  The SRG SSR business unit which measurements are associated with.
 */
@property (nonatomic, readonly, copy) SRGAnalyticsBusinessUnitIdentifier businessUnitIdentifier;

/**
 *  The TagCommand site which will be used.
 */
@property (nonatomic, readonly) NSInteger site;

/**
 *  The TagCommander container identifier.
 */
@property (nonatomic, readonly) NSInteger container;

/**
 *  The comScore virtual site to which measurements must be sent. By default `business_unit-app-test-v`.
 */
@property (nonatomic, readonly, copy) NSString *comScoreVirtualSite;

/**
 *  The NetMetrix identifier which is used.
 */
@property (nonatomic, readonly, copy) NSString *netMetrixIdentifier;

/**
 *  The heartbeat interval which will be applied.
 */
@property (nonatomic, readonly) NSTimeInterval heartbeatInterval;

@end

@interface SRGAnalyticsConfiguration (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
