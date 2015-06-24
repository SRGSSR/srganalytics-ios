//
//  Created by Frédéric Humbert-Droz on 19/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <SRGAnalytics/SRGAnalytics.h>
#import "CustomMediaPlayerViewController.h"

@interface CustomMediaPlayerViewController () <RTSAnalyticsMediaPlayerDelegate>

@end

@implementation CustomMediaPlayerViewController

#pragma mark - RTSAnalyticsMediaPlayerDelegate

- (BOOL) shouldTrackMediaWithIdentifier:(NSString *)identifier
{
	return [identifier hasSuffix:@"VODCell"];
}

@end
