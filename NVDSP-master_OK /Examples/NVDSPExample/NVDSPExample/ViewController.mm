//
//  ViewController.m
//  NVDSPExample
//
//  Created by Bart Olsthoorn on 25/04/2013.
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *timer;
    NSURL *inputFileURLCurrent;
    BOOL isSlide;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(showTimeChanged) userInfo:nil repeats:YES];
    [timer fire];
    isSlide = NO;
}
- (void)viewWillAppear:(BOOL)animated
{                              //缓冲区长 通道
//    ringBuffer = new RingBuffer(8192, 2);
    audioManager = [Novocaine audioManager];
    audioManager.isRightSound = YES;
    float samplingRate = audioManager.samplingRate;
    
    // Audio File Reading
    inputFileURLCurrent = [[NSBundle mainBundle] URLForResource:@"Whatever This Town" withExtension:@"mp3"];

//    HPF = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];
//    HPF.Q = 0.5f;
//    _HPF_cornerFrequency = 1050.0f;
//    
//    LPF = [[NVLowpassFilter alloc] initWithSamplingRate:samplingRate];
//    LPF.Q = 0.5f;
//    _LPF_cornerFrequency = 950.0f;

    NotchFilter = [[NVNotchFilter alloc] initWithSamplingRate:44100];
    NotchFilter.centerFrequency = 4500+(5500-4500)/2.0f;
//    NotchFilter.centerFrequency = 2000+(3100-2000)/2.0f;
    NotchFilter.Q = 0.5f;
    
//    leftAudioManager = [Novocaine audioManager];
//    leftAudioManager.isRightSound = NO;
//    
    leftNotchFilter = [[NVNotchFilter alloc] initWithSamplingRate:44100];
    leftNotchFilter.centerFrequency = 6000+(7000-6000)/2.0f;
//    leftNotchFilter.centerFrequency = 4500+(5500-4500)/2.0f;
    leftNotchFilter.Q = 0.5f;
    
    CDT = [[NVClippingDetection alloc] init];
    
    fileReader = [[AudioFileReader alloc]
                  initWithAudioFileURL:inputFileURLCurrent
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];
    
    [fileReader play];
    fileReader.currentTime = 0.0;
    
//    leftFileReader = [[AudioFileReader alloc]
//                  initWithAudioFileURL:inputFileURLCurrent
//                  samplingRate:leftAudioManager.samplingRate
//                  numChannels:leftAudioManager.numOutputChannels];
//    
//    [leftFileReader play];
//    leftFileReader.currentTime = 0.0;
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         audioManager.isRightSound = YES;
        [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         [leftNotchFilter LeftfilterData:data numFrames:numFrames numChannels:numChannels];
//         [NotchFilter RightfilterData:data numFrames:numFrames numChannels:numChannels];
         
//         [leftNotchFilter filterData:data numFrames:numFrames numChannels:numChannels];
//         [NotchFilter filterData:data numFrames:numFrames numChannels:numChannels];
         
//         HPF.cornerFrequency = _HPF_cornerFrequency;
//         [HPF filterData:data numFrames:numFrames numChannels:numChannels];
//         //add for test
//         LPF.cornerFrequency = _LPF_cornerFrequency;
//         [LPF filterData:data numFrames:numFrames numChannels:numChannels];
         //end
//         [CDT counterClipping:data numFrames:numFrames numChannels:numChannels];
     }];
    
//    [leftAudioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         leftAudioManager.isRightSound = NO;
//         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
//         [leftNotchFilter filterData:data numFrames:numFrames numChannels:numChannels];
//     }];
//    NSLog(@"或许是当前时间：%f",fileReader.currentTime);
//    NSLog(@"或许是总时间：%f",fileReader.duration);
    
}
#pragma mark -- 时间进度条
- (IBAction)tapSlide:(id)sender{
    isSlide = YES;
}

- (IBAction)HPFtimeChanged:(UISlider *)sender {
    isSlide = NO;
//    audioManager = [Novocaine audioManager];
//    float samplingRate = audioManager.samplingRate;
   //此处调用正在播放歌曲的URL
//    inputFileURLCurrent = [[NSBundle mainBundle] URLForResource:@"Whatever This Town" withExtension:@"mp3"];
    
//    [fileReader pause];
    
    if (fileReader.playing) {
        
    }
    [self playerWaveFilteringInitWithAudioFileURL:inputFileURLCurrent fileReaderCurrentTime:self.timeSlider.value * fileReader.duration HPFFreq:_HPF_cornerFrequency HPFQ:0.5f LPFFreq:_LPF_cornerFrequency LPFQ:0.5f];
    
//    if (!HPF) {
//        HPF = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];
//        HPF.Q = 0.5f;
//        _HPF_cornerFrequency = 1050.0f;
//    }
//    if (!LPF) {
//        LPF = [[NVLowpassFilter alloc] initWithSamplingRate:samplingRate];
//        LPF.Q = 0.5f;
//        _LPF_cornerFrequency = 950.0f;
//    }
//    if (!CDT) {
//        CDT = [[NVClippingDetection alloc] init];
//    }
//    
//    if (!fileReader) {
//        fileReader = [[AudioFileReader alloc]
//                      initWithAudioFileURL:inputFileURLCurrent
//                      samplingRate:audioManager.samplingRate
//                      numChannels:audioManager.numOutputChannels];
//    }
//    else{
//        [fileReader initWithAudioFileURL:inputFileURLCurrent samplingRate:audioManager.samplingRate numChannels:audioManager.numOutputChannels];
//    }
//    [fileReader play];
//    fileReader.currentTime = self.timeSlider.value * fileReader.duration;
//    
//    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
//         HPF.cornerFrequency = _HPF_cornerFrequency;
//         [HPF filterData:data numFrames:numFrames numChannels:numChannels];
//         //add for test
//         LPF.cornerFrequency = _LPF_cornerFrequency;
//         [LPF filterData:data numFrames:numFrames numChannels:numChannels];
//         //         end
//         [CDT counterClipping:data numFrames:numFrames numChannels:numChannels];
//     }];

}
#pragma mark -- 定时器方法
-(void)showTimeChanged {
    if (!isSlide) {
        NSString *durationStr = [NSString stringWithFormat:@"%.0f",fileReader.duration];
        NSString *currentStr = [NSString stringWithFormat:@"%.0f",fileReader.currentTime];
        double currentValue = floor(fmod(fileReader.currentTime, 60.0f));
//        NSLog(@"[currentStr intValue]60 [%02d] vs [%02.0f]",[currentStr intValue]%60,currentValue);
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02.0f",[currentStr intValue]/60,currentValue];
        self.ToTalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",[durationStr intValue]/60,[durationStr intValue]%60];
        self.timeSlider.value = fileReader.currentTime/fileReader.duration;
    }
}
#pragma mark -- 高波
- (IBAction)HPFSliderChanged:(UISlider *)sender{
    _HPF_cornerFrequency = sender.value;
}
#pragma mark -- 低波
- (IBAction)LPFSliderChanged:(UISlider *)sender {
     _LPF_cornerFrequency = sender.value;
}
#pragma mark -- 播放按钮
- (IBAction)play:(UIButton *)sender{
    audioManager = [Novocaine audioManager];
    if (audioManager.playing) {
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [audioManager pause];
    }
    else{
        [sender setTitle:@"暫停" forState:UIControlStateNormal];
        [audioManager play];
    }
}
#pragma mark -- 下一曲
- (IBAction)nextSong:(UIButton *)sender{
    inputFileURLCurrent = [[NSBundle mainBundle] URLForResource:@"Whatever This Town" withExtension:@"mp3"];
    [self playerWaveFilteringInitWithAudioFileURL:inputFileURLCurrent fileReaderCurrentTime:0 HPFFreq:1050.0f HPFQ:0.5f LPFFreq:950.0f LPFQ:0.5f];
    
}
#pragma mark -- 上一曲
- (IBAction)previousSong:(UIButton *)sender{
    inputFileURLCurrent = [[NSBundle mainBundle] URLForResource:@"rain" withExtension:@"mp3"];
    [self playerWaveFilteringInitWithAudioFileURL:inputFileURLCurrent fileReaderCurrentTime:0 HPFFreq:1050.0f HPFQ:0.5f LPFFreq:950.0f LPFQ:0.5f];

}
#pragma mark -- 滤波播放
-(void)playerWaveFilteringInitWithAudioFileURL:(NSURL *)senderUrl fileReaderCurrentTime:(float)senderTime HPFFreq:(float)HPFFreq HPFQ:(float)HPFQ  LPFFreq:(float)LPFFreq LPFQ:(float)LPFQ{

    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    if (!HPF) {
        HPF = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];
        HPF.Q = HPFQ;
        _HPF_cornerFrequency = HPFFreq;
    }
    if (!LPF) {
        LPF = [[NVLowpassFilter alloc] initWithSamplingRate:samplingRate];
        LPF.Q = LPFQ;//0.5
        _LPF_cornerFrequency = LPFFreq;//950.0f;
    }
    if (!CDT) {
        CDT = [[NVClippingDetection alloc] init];
    }
    
    if (!fileReader) {
        fileReader = [[AudioFileReader alloc]
                      initWithAudioFileURL:senderUrl
                      samplingRate:audioManager.samplingRate
                      numChannels:audioManager.numOutputChannels];
    }
    else{
        if (fileReader.playing) [fileReader stop];
        [fileReader initWithAudioFileURL:senderUrl samplingRate:audioManager.samplingRate numChannels:audioManager.numOutputChannels];
    }
    
    [fileReader play];
    fileReader.currentTime = senderTime;
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         
         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         [leftNotchFilter LeftfilterData:data numFrames:numFrames numChannels:numChannels];
         [NotchFilter RightfilterData:data numFrames:numFrames numChannels:numChannels];
//         HPF.cornerFrequency = _HPF_cornerFrequency;
//         [HPF filterData:data numFrames:numFrames numChannels:numChannels];
//         //add for test
//         LPF.cornerFrequency = _LPF_cornerFrequency;
//         [LPF filterData:data numFrames:numFrames numChannels:numChannels];
//         //end
//         [CDT counterClipping:data numFrames:numFrames numChannels:numChannels];
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_currentTimeLabel release];
    [_ToTalTimeLabel release];
    [_timeSlider release];
    [super dealloc];
}
@end
