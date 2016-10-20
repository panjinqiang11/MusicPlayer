//
//  MusicPlayTool.m
//  音乐播放器
//
//  Created by 潘金强 on 16/8/5.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import "MusicPlayTool.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicPlayTool()<AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *player;
//记录播放的音乐
@property (nonatomic,copy)NSString *fileName;
@end
@implementation MusicPlayTool
+(instancetype)shareMusic{
    
    static id instane ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instane = [[self alloc]init];
    });
    return instane;
}

- (void)playMusicWithFileName: (NSString*)FileName{
    
    
    if (![self.fileName isEqualToString:FileName]) {
        
        NSURL *url = [[NSBundle mainBundle]URLForResource:FileName withExtension:nil];
        
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        self.player.delegate = self;
        
        self.fileName = FileName;
        
       [self.player prepareToPlay];
    }
    
   
    
    [self.player play];
    
}

-(void)pause{
    
    [self.player pause];
}
-(NSTimeInterval )duration{
    
    return self.player.duration;
}

-(NSTimeInterval)currentTime{
    
    return self.player.currentTime;
}


-(void)setCurrentTime:(NSTimeInterval)currentTime{
    
    self.player.currentTime = currentTime;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    
}





@end
