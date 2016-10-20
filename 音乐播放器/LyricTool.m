//
//  LyricTool.m
//  音乐播放器
//
//  Created by 潘金强 on 16/8/6.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import "LyricTool.h"

@implementation LyricTool
+(NSArray *)lyricWithFileName:(NSString *)fileName{
    
    
    NSString *path  = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    
    //根据路径拿到歌词
    NSString *lyricString = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
    
    
    //根据换行符截取
    NSArray *lineArra = [lyricString componentsSeparatedByString:@"\n"];
    
    //创建数组存放模型
    NSMutableArray *modelArray = [NSMutableArray array];
    
    //遍历每一行歌词
    for (NSString *line in lineArra) {
       NSString *pattern = @"\\[[0-9][0-9]:[0-9][0-9].[0-9][0-9]\\]";
        //创建正则表达式
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        //利用正则进行匹配
        NSArray *matchArray = [regular matchesInString:line options:0 range:NSMakeRange(0,line.length)];
        

        // 拿到最后一个
        NSTextCheckingResult *match = [matchArray lastObject];
        
        //截取歌词部分
        NSString *content = [line substringFromIndex:match.range.location + match.range.length];
        //遍历时间部分,拿出每一个时间范围
        for (NSTextCheckingResult *match  in matchArray) {
            //截取每一个时间部分的字符创
            NSString *timeStr = [line substringWithRange:match.range];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"[mm:ss.SS]";
            
            NSDate *timeDate = [formatter dateFromString:timeStr];
            NSDate *zeroDate = [formatter dateFromString:@"[00:00.0"];
            
            //获取时间间隔
            NSTimeInterval time = [timeDate timeIntervalSinceDate:zeroDate];
            
            //给模型赋值
            
            MusicLuricModel *lyricModel = [[MusicLuricModel alloc]init];
            
            lyricModel.time = time;
            lyricModel.content = content;
            //存放模型
            [modelArray addObject:lyricModel];
            
            

        }
        
    }
    //时间排序un
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    return [modelArray sortedArrayUsingDescriptors:@[sort]];

}

    

@end
