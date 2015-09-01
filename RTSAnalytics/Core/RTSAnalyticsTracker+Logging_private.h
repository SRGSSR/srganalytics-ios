//
//  Created by Frédéric Humbert-Droz on 08/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import "RTSAnalyticsTracker.h"

/**
 *  Category on `RTSAnalyticsTracker` which implements Comscore logging methods.
 * 
 *  Comscore SDK does not provide an easy way to debug sent labels for view events and stream measurements.
 *  `RTSAnalyticsTracker+Logging` allows to print in the debugger console the request status and all labels sent by the Comscore SDK.
 *
 *  @see `CSRequest+RTSNotification` category
 */
@interface RTSAnalyticsTracker (Logging)

/**
 *  Start logging events to the `RTSAnalyticsLogger`
 */
- (void)startLoggingInternalComScoreTasks;

@end
