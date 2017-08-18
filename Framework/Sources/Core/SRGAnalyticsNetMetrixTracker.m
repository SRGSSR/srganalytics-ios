//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAnalyticsNetMetrixTracker.h"

#import "SRGAnalyticsLogger.h"
#import "SRGAnalyticsNotifications.h"
#import "SRGAnalyticsTracker.h"

#import <UIKit/UIKit.h>

@interface SRGAnalyticsNetMetrixTracker ()

@property (nonatomic, copy) SRGAnalyticsConfiguration *configuration;

@end

@implementation SRGAnalyticsNetMetrixTracker

#pragma mark Object lifecycle

- (instancetype)initWithConfiguration:(SRGAnalyticsConfiguration *)configuration
{
    if (self = [super init]) {
        self.configuration = configuration;
    }
    return self;
}

#pragma mark View tracking

- (void)trackView
{
    SRGAnalyticsConfiguration *configuration = self.configuration;
    NSString *netMetrixDomain = configuration.netMetrixDomain;
    if (! netMetrixDomain) {
        SRGAnalyticsLogInfo(@"NetMetrix", @"No NetMetrix domain is defined for this configuration. No event will be recorded");
        return;
    }
    
    NSString *netMetrixURLString = [NSString stringWithFormat:@"https://%@.wemfbox.ch/cgi-bin/ivw/CP/apps/%@/ios/%@", netMetrixDomain, configuration.netMetrixIdentifier, self.device];
    NSURL *netMetrixURL = [NSURL URLWithString:netMetrixURLString];
    
    if (! configuration.unitTesting) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:netMetrixURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"image/gif" forHTTPHeaderField:@"Accept"];
        
        // Which User-Agent MUST be used is defined at http://www.net-metrix.ch/fr/produits/net-metrix-mobile/reglement/directives
        NSString *systemVersion = [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        NSString *userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iOS-%@; CPU %@ %@ like Mac OS X)", self.device, self.operatingSystem, systemVersion];
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        SRGAnalyticsLogDebug(@"NetMetrix", @"Request %@ started", request.URL);
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            SRGAnalyticsLogDebug(@"NetMetrix", @"Request %@ ended with error %@", request.URL, error);
        }] resume];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:SRGAnalyticsNetmetrixRequestNotification
                                                            object:nil
                                                          userInfo:@{ SRGAnalyticsNetmetrixURLKey : netMetrixURL }];
    }
}

#pragma mark Information

- (NSString *)device
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return @"phone";
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return @"tablet";
    }
    else {
        return @"universal";
    }
}

- (NSString *)operatingSystem
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return @"iPhone OS";
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return @"iPad OS";
    }
    else {
        return @"OS";
    }
}

@end
