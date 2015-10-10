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
  
  UIImage* image = [UIImage imageNamed:@"image_0002.jpg"];
  CGSize imageSize = image.size;
  CGSize viewSize = self.view.bounds.size;
  
  UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
  imageView.frame = CGRectMake((viewSize.width-imageSize.width)/2, (viewSize.height-imageSize.height)/2, imageSize.width, imageSize.height);
  [self.view addSubview:imageView];

  UILabel* label = [[UILabel alloc] init];
  label.frame = CGRectMake(10, CGRectGetMaxY(imageView.frame)+10, viewSize.width-20, 50);
  label.numberOfLines = 2;
  label.textAlignment = NSTextAlignmentCenter;
  label.text = @"Classifying..";
  [self.view addSubview:label];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString* result = [self predictWithImage:image];
    label.text = result;
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSString*)predictWithImage: (UIImage*)image;
{
  NSString* model_file = [NSBundle.mainBundle pathForResource:@"deploy" ofType:@"prototxt" inDirectory:@"model"];
  NSString* label_file = [NSBundle.mainBundle pathForResource:@"labels" ofType:@"txt" inDirectory:@"model"];
  NSString* mean_file = [NSBundle.mainBundle pathForResource:@"mean" ofType:@"binaryproto" inDirectory:@"model"];
  NSString* trained_file = [NSBundle.mainBundle pathForResource:@"bvlc_reference_caffenet" ofType:@"caffemodel" inDirectory:@"model"];
  string model_file_str = std::string([model_file UTF8String]);
  string label_file_str = std::string([label_file UTF8String]);
  string trained_file_str = std::string([trained_file UTF8String]);
  string mean_file_str = std::string([mean_file UTF8String]);
  
  cv::Mat src_img, bgra_img;
  UIImageToMat(image, src_img);
  // needs to convert to BGRA because the image loaded from UIImage is in RGBA
  cv::cvtColor(src_img, bgra_img, CV_RGBA2BGRA);

  Classifier classifier = Classifier(model_file_str, trained_file_str, mean_file_str, label_file_str);
  std::vector<Prediction> result = classifier.Classify(bgra_img);

  NSString* ret = nil;
  
  for (std::vector<Prediction>::iterator it = result.begin(); it != result.end(); ++it) {
    NSString* label = [NSString stringWithUTF8String:it->first.c_str()];
    NSNumber* probability = [NSNumber numberWithFloat:it->second];
    NSLog(@"label: %@, prob: %@", label, probability);
    if (it == result.begin()) {
      ret = label;
    }
  }
  
  return ret;
}

@end

