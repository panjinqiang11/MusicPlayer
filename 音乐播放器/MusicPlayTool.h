//
//  MusicPlayTool.h
//  音乐播放器
//
//  Created by 潘金强 on 16/8/5.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicPlayTool : NSObject
//歌曲总时间
@property(nonatomic,assign)NSTimeInterval duration;

//当前时间
@property(nonatomic,assign)NSTimeInterval currentTime;
+(instancetype)shareMusic;
- (void)playMusicWithFileName: (NSString*)FileName;
-(void)pause;
@end
