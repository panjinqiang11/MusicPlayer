//
//  ViewController.m
//  音乐播放器
//
//  Created by 潘金强 on 16/8/5.
//  Copyright © 2016年 潘金强. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayTool.h"
#import "MusicModel.h"
#import "YYModel.h"
#import "LyricTool.h"
//#import "MusicLuricModel.h"
@interface ViewController ()
//背景
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
//歌手图片
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;
//歌手
@property (weak, nonatomic) IBOutlet UILabel *singer;
//专辑
@property (weak, nonatomic) IBOutlet UILabel *album;
//歌词索引
@property (nonatomic,assign)NSInteger currentIndex;
//plist文件数据数组
@property (nonatomic,strong)NSMutableArray *musicArray;
//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//定时器
@property (nonatomic,strong)NSTimer *timer;
//总时长
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *silder;
//当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
//歌词数组
@property (nonatomic,strong)NSArray *lyricsArray;

@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation ViewController
#pragma mark -滑动滑块
- (IBAction)changeSilder:(id)sender {
    MusicPlayTool *tool = [MusicPlayTool shareMusic];
    
    
    tool.currentTime = self.silder.value * tool.duration;
}
#pragma mark -下一首
- (IBAction)clikNextButton:(id)sender {
    if (self.currentIndex == self.musicArray.count - 1) {
        self.currentIndex = 0;
    }else{
        
        self.currentIndex ++;
    }
    
    [self setupUI];
    
    
    
}
#pragma mark -点击上一首
- (IBAction)clikPreviousButton:(id)sender {
    
    if (self.currentIndex == 0) {
        self.currentIndex = self.musicArray.count -1;
    }else{
        self.currentIndex -- ;
    }
    
    [self setupUI];
}
#pragma mark -点击播放按钮
- (IBAction)clikPlayButton:(id)sender {
    
    MusicModel *model = self.musicArray[self.currentIndex];
    MusicPlayTool *tool = [MusicPlayTool shareMusic];
    if (self.playButton.selected) {//如果按钮是选中状态
    
        //停止播放
        [tool pause];
        //关闭定时器
        [self closeTimer];
    }else{
    [tool playMusicWithFileName:model.mp3];//开始播放
        [self openTimer];//开启定时器
    }
    
    self.playButton.selected = !self.playButton.selected;
}

#pragma mark - 给控件赋值
- (void)setupUI{
    MusicModel *model = self.musicArray[self.currentIndex];
    
    self.singerImageView.image = [UIImage imageNamed:model.image];
    
    self.singer.text = model.singer;
    self.album.text = model.album;
    
    self.bjImageView.image = [UIImage imageNamed:model.image];
    
    self.playButton.selected = NO;
    
      [self closeTimer];
    
    [self clikPlayButton:self.playButton];
    
    
    
  
    
    //获取总得时间
    MusicPlayTool *tool = [MusicPlayTool shareMusic];
    
    self.duration.text = [self getTimeWithtime:tool.duration];
    
//解析歌词
    self.lyricsArray = [LyricTool lyricWithFileName:model.lrc];
    

    
    
}

- (NSString *)getTimeWithtime:(NSTimeInterval)time{
    
    int second = (int)time % 60;
    int minute = time / 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
#pragma mark -懒加载数组
-(NSArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
        NSArray *info = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mlist.plist" ofType:nil]];
        
        for (NSDictionary *dic in info) {
            MusicModel *model = [MusicModel yy_modelWithDictionary:dic];
            [_musicArray addObject:model];
        }
        
    }
        return _musicArray;
    }
    
 #pragma mark - 开启定时器
- (void)openTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(upUI) userInfo:nil repeats:YES];
}
#pragma mark -关闭定时
- (void)closeTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 定时器方法
- (void)upUI{
    MusicPlayTool *tool = [MusicPlayTool shareMusic];
    
    self.currentTime.text = [self getTimeWithtime:tool.currentTime];
    
    self.singerImageView.transform = CGAffineTransformRotate(self.singerImageView.transform, M_PI_2*0.01);
    
    self.silder.value = tool.currentTime / tool.duration;
    [self updateLyric];
    
    if (tool.currentTime >= tool.duration - 1) {
        [self clikNextButton:self.nextButton];
    }
    
}

- (void)updateLyric{
    MusicPlayTool *tool = [MusicPlayTool shareMusic];
    for (int i = 0; i < self.lyricsArray.count; i++) {
        MusicLuricModel *firstModel = self.lyricsArray[i];
        MusicLuricModel *secondModel = nil;
        if (i == self.lyricsArray.count - 1) {
            secondModel = self.lyricsArray[i];
        }else{
            
            secondModel = self.lyricsArray[i + 1];
        }

        
        if (tool.currentTime > firstModel.time && tool.currentTime < secondModel.time) {
        
            self.lyricLabel.text = firstModel.content;
            
            
            
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加毛玻璃
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:self.view.frame];
    
    [self.bjImageView addSubview:toolbar];
    
    self.singerImageView.layer.cornerRadius = self.singerImageView.frame.size.width * 0.5;
    
    self.singerImageView.layer.masksToBounds = YES;

    
    [self setupUI];
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    //强制更新
    
//    [self.view layoutIfNeeded];
//    
//    self.singerImageView.layer.cornerRadius = self.singerImageView.frame.size.width * 0.5;
//    
//    self.singerImageView.layer.masksToBounds = YES;
}
@end
