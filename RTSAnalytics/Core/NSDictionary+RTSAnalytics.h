//
//  NSDictionary+Utils.h
//  RTSAnalytics
//
//  Created by Cédric Foellmi on 26/03/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RTSAnalytics)

/**
 *  Set value and key iff both are non-nil
 */
- (void)safeSetValue:(id)value forKey:(NSString *)key;

@end
