//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

#define AssertIsWithin1Second(expression1, expression2) XCTAssertTrue(fabs([expression1 doubleValue] - expression2) < 1000.)

@interface SRGAnalytics_Demo_2_MediaPlayerTests : KIFTestCase

@end

@implementation SRGAnalytics_Demo_2_MediaPlayerTests

- (void)setUp
{
    [super setUp];
    [KIFSystemTestActor setDefaultTimeout:30.0];
}

// Expected behavior: When playing a segment, selecting the same segment generates a pause for the segment (seeking to the
// beginning), followed by a play for the same segment
- (void)testOpenMediaPlayerAndSwitchToTheSameSegment
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to 1st segment. Expect full-length end immediately followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment1");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Manually switch to the same segment. Expect segment pause and play for the same segment
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // Pause for the first segment
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment1");
                
                // Not finished yet
                return NO;
            }
            // Play for the full-length (even if there is a segment, it was not selected by the user)
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment1");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

- (void)testOpenMediaPlayerAndPlaySegmentBeforeSeekingOutsideIt
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to the segment. Expect full-length end immediately followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Seek outside the segment. Expect segment pause followed by segment play, then the segment transition
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the segment
            if (numberOfNotificationsReceived == 3)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                
                // Not finished yet
                return NO;
            }
            // Play for the full-length
            else if (numberOfNotificationsReceived == 4)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester setValue:40. forSliderWithAccessibilityLabel:@"slider"];
        [tester waitForTimeInterval:2.0f];          // Must wait a little bit after setting a slider value, otherwise issues might arise when executing a test afterwards
                
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

- (void)testOpenMediaPlayerAndPlaySegmentBeforeSeekingInsideIt
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to the segment. Expect full-length end immediately followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Seek outside the segment. Expect segment pause followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // Pause for the segment
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"pause");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                
                // Not finished yet
                return NO;
            }
            // Play for the segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester setValue:3. forSliderWithAccessibilityLabel:@"slider"];
        [tester waitForTimeInterval:2.0f];          // Must wait a little bit after setting a slider value, otherwise issues might arise when executing a test afterwards
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

// Expected behavior: When closing the player while a segment is being played, no end event is expected for the segment, only for the
// full-length
- (void)testOpenMediaPlayerAndPlayFullLengthWhileClosingThePlayer
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close the player. Only an end event is expected for the full-length
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Done"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    [tester waitForTimeInterval:2.0f];
}

// Expected behavior: When closing the player while a segment is being played, no end event is expected for the segment, only for the
// full-length
- (void)testOpenMediaPlayerAndPlaySegmentWhileClosingThePlayer
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to the segment. Expect full-length end immediately followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close the player. Only an end event is expected for the segment
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
            XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
            return YES;
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Done"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    [tester waitForTimeInterval:2.0f];
}

// Try to seek into a blocked segment. Must pause the full-length
- (void)testOpenMediaPlayerAndSeekIntoBlockedSegment
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Seek into the blocked segment
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"pause");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester setValue:43. forSliderWithAccessibilityLabel:@"slider"];
        [tester waitForTimeInterval:2.0f];          // Must wait a little bit after setting a slider value, otherwise issues might arise when executing a test afterwards
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

// Pause while the full-length is being played
- (void)testOpenMediaPlayerPlayThenPauseFullLength
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Pause
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"pause");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];

        [tester tapViewWithAccessibilityLabel:@"play"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

// Pause while a segment is being played
- (void)testOpenMediaPlayerPlayThenPauseSegment
{
    // Initial full-length play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to the segment. Expect full-length end immediately followed by segment play
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"full_length");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #1"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Pause
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"pause");
            XCTAssertEqualObjects(labels[@"clip_name"], @"segment");
            return YES;
        }];
        
        [tester tapViewWithAccessibilityLabel:@"play"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

- (void)testOpenMediaPlayerAndManuallyPlaySecondPhysicalSegment
{
    // Initial physical segment play when opening
    {
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Only consider relevant events
            if (!labels[@"clip_name"])
            {
                return NO;
            }
            
            XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
            XCTAssertEqualObjects(labels[@"clip_name"], @"physical_segment1");
            return YES;
        }];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:2] inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Go to other segment. Expect end for 1st segment, followed by play for the second
    {
        __block NSInteger numberOfNotificationsReceived = 0;
        [self expectationForNotification:@"SRGAnalyticsComScoreRequestDidFinish" object:nil handler:^BOOL(NSNotification *notification) {
            NSDictionary *labels = notification.userInfo[@"SRGAnalyticsLabels"];
            
            // Skip heartbeats
            if ([labels[@"ns_st_ev"] isEqualToString:@"hb"])
            {
                return NO;
            }
            
            numberOfNotificationsReceived++;
            
            // End for the full-length
            if (numberOfNotificationsReceived == 1)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"end");
                XCTAssertEqualObjects(labels[@"clip_name"], @"physical_segment1");
                
                // Not finished yet
                return NO;
            }
            // Play for the first segment
            else if (numberOfNotificationsReceived == 2)
            {
                XCTAssertEqualObjects(labels[@"ns_st_ev"], @"play");
                XCTAssertEqualObjects(labels[@"clip_name"], @"physical_segment2");
                return YES;
            }
            else
            {
                return NO;
            }
        }];
        
        [tester tapViewWithAccessibilityLabel:@"Segment #2"];
        
        [self waitForExpectationsWithTimeout:20. handler:nil];
    }
    
    // Close
    {
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
    
    [tester waitForTimeInterval:2.0f];
}

@end
