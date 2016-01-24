//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"

#import "NVDSP.h"
#import "NVHighpassFilter.h"
#import "NVClippingDetection.h"
#import "NVLowpassFilter.h"
#import "NVNotchFilter.h"

@interface ViewController : UIViewController {
  RingBuffer *ringBuffer;
  Novocaine *audioManager;
  AudioFileReader *fileReader;
  AudioFileWriter *fileWriter;
  NVHighpassFilter *HPF;
  NVClippingDetection *CDT;
  NVLowpassFilter *LPF;   //add for test
  NVNotchFilter *NotchFilter;
    
  Novocaine *leftAudioManager;
  NVNotchFilter *leftNotchFilter;
  AudioFileReader *leftFileReader;
}
//顶部滑竿
- (IBAction)HPFSliderChanged:(UISlider *)sender;
- (IBAction)LPFSliderChanged:(UISlider *)sender;
- (IBAction)play:(UIButton *)sender;
- (IBAction)nextSong:(UIButton *)sender;
- (IBAction)previousSong:(UIButton *)sender;
//添加时间滑竿
- (IBAction)HPFtimeChanged:(UISlider *)sender;
//添加当前时间label
@property (retain, nonatomic) IBOutlet UISlider *timeSlider;
@property (retain, nonatomic) IBOutlet UILabel *currentTimeLabel;
//添加总时间label
@property (retain, nonatomic) IBOutlet UILabel *ToTalTimeLabel;

@property float HPF_cornerFrequency;
@property float LPF_cornerFrequency; //add for test





@end













