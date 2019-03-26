//
//  NSTimer+EOCBlocksSupport.h
//  QHDanumuDemo
//
//  Created by chen on 15/7/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (EOCBlocksSupport)

/**
 *  <#Description#>
 *
 *  @param interval <#interval description#>
 *  @param block    <#block description#>
 *  @param repeats  <#repeats description#>
 *
 *  @return return value description
 */
+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void (^)())block
                                        repeats:(BOOL)repeats;

@end
