//
//  LyricTool.h
//  音乐播放器
//
//  Created by 潘金强 on 16/8/6.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicLuricModel.h"
@interface LyricTool : NSObject
+(NSArray *)lyricWithFileName:(NSString *)fileName;
@end
