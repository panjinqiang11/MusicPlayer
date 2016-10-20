//
//  MusicModel.h
//  音乐播放器
//
//  Created by 潘金强 on 16/8/5.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
/*
 <key>image</key>
 <string>樊桐舟.jpg</string>
 <key>lrc</key>
 <string>突然的自我.lrc</string>
 <key>mp3</key>
 <string>突然的自我.mp3</string>
 <key>name</key>
 <string>突然的自我</string>
 <key>singer</key>
 <string>樊桐舟</string>
 <key>album</key>
 <string>绝色Ⅱ</string>
 <key>type</key>
 <integer>2</integer>
 
 */
//歌手
@property(nonatomic,copy)NSString *singer;
//歌词
@property(nonatomic,copy)NSString *lrc;
//歌手图片
@property(nonatomic,copy)NSString *image;
//歌曲文件
@property(nonatomic,copy)NSString *mp3;
//歌曲名字
@property(nonatomic,copy)NSString *name;
//专辑
@property(nonatomic,copy)NSString *album;
//类型
@property(nonatomic,assign)NSInteger type;
@end
