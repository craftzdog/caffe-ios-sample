//
//  ViewController.m
//  CaffeApp
//
//  Created by Takuya Matsuyama on 7/11/15.
//  Copyright (c) 2015 Takuya Matsuyama. All rights reserved.
//

#import "ViewController.h"
#import "Classifier.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self predict];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)predict;
{
  NSString* model_file = [NSBundle.mainBundle pathForResource:@"deploy" ofType:@"prototxt" inDirectory:@"model"];
  NSString* label_file = [NSBundle.mainBundle pathForResource:@"labels" ofType:@"txt" inDirectory:@"model"];
  NSString* mean_file = [NSBundle.mainBundle pathForResource:@"mean" ofType:@"binaryproto" inDirectory:@"model"];
  NSString* trained_file = [NSBundle.mainBundle pathForResource:@"bvlc_reference_caffenet" ofType:@"caffemodel" inDirectory:@"model"];
  string model_file_str = std::string([model_file UTF8String]);
  string label_file_str = std::string([label_file UTF8String]);
  string trained_file_str = std::string([trained_file UTF8String]);
  string mean_file_str = std::string([mean_file UTF8String]);
  
  UIImage* example = [UIImage imageNamed:@"image_0002.jpg"];
  
  cv::Mat src_img;
  UIImageToMat(example, src_img);
  
  Classifier classifier = Classifier(model_file_str, trained_file_str, mean_file_str, label_file_str);
  std::vector<Prediction> result = classifier.Classify(src_img);

  for (std::vector<Prediction>::iterator it = result.begin(); it != result.end(); ++it) {
    NSString* label = [NSString stringWithUTF8String:it->first.c_str()];
    NSNumber* probability = [NSNumber numberWithFloat:it->second];
    NSLog(@"label: %@, prob: %@", label, probability);
  }
}

@end

