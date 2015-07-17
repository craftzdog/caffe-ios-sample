//
//  Classifier.h
//  CaffeApp
//
//  Created by Takuya Matsuyama on 7/11/15.
//  Copyright (c) 2015 Takuya Matsuyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "caffe/caffe.hpp"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>
#include <iosfwd>
#include <memory>
#include <string>
#include <utility>
#include <vector>
#include <iomanip>

using namespace caffe;  // NOLINT(build/namespaces)
using std::string;

/* Pair (label, confidence) representing a prediction. */
typedef std::pair<string, float> Prediction;

class Classifier {
public:
  Classifier(const string& model_file,
             const string& trained_file,
             const string& mean_file,
             const string& label_file);
  
  std::vector<Prediction> Classify(const cv::Mat& img, int N = 5);
  
private:
  void SetMean(const string& mean_file);
  
  std::vector<float> Predict(const cv::Mat& img);
  
  void WrapInputLayer(std::vector<cv::Mat>* input_channels);
  
  void Preprocess(const cv::Mat& img,
                  std::vector<cv::Mat>* input_channels);
  
private:
  shared_ptr<Net<float> > net_;
  cv::Size input_geometry_;
  int num_channels_;
  cv::Mat mean_;
  std::vector<string> labels_;
};
