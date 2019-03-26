//
//  NSURL+Video.m
//  KenuoTraining
//
//  Created by Robert on 16/3/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "NSURL+Video.h"
#import "NSDate+BTAddition.h"


@implementation NSURL (Video)

+ (void)convertVideoQuailtyWithInputURL:(NSURL *)inputURL
                              outputURL:(NSURL *)outputURL
                        completeHandler:(void (^)(AVAssetExportSession *))handler {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];

    NSURL *tmpDirUrl = [NSURL fileURLWithPath:KNB_PATH_TMP isDirectory:YES];

    if (!outputURL) {
        outputURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",
                                                                    [NSDate getTheCurrentDateSimpleFormat]]
                           relativeToURL:tmpDirUrl];
    }
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown:
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted: {
                handler(exportSession);
                break;
            }
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCancelled:
                break;
        }
    }];
}

@end
