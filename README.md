Caffe iOS sample
================

This is an example XCode project using iOS version of Caffe built by [aleph7](https://github.com/aleph7/caffe).

It also includes a class `Classifier` which is the `cpp_classification` imported from Caffe C++ example.
It can classify images and outputs result with labels in the XCode console.

## Dependencies

* opencv2.framework

## Get started

Clone it:

```
$ git clone --recursive git@github.com:noradaiko/caffe-ios-sample.git
```

### Prepare model files

You need your `caffemodel`, `deploy.prototxt`, `mean.binaryproto` and `labels.txt` into `model/` directory.


## How to classify

```
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
```

Output into console:

```
for (std::vector<Prediction>::iterator it = result.begin(); it != result.end(); ++it) {
  NSString* label = [NSString stringWithUTF8String:it->first.c_str()];
  NSNumber* probability = [NSNumber numberWithFloat:it->second];
  NSLog(@"label: %@, prob: %@", label, probability);
}
```

## License and Citation

### This example

[BSD 2-Clause license](https://github.com/BVLC/caffe/blob/master/LICENSE)

### Caffe

Caffe is released under the [BSD 2-Clause license](https://github.com/BVLC/caffe/blob/master/LICENSE).
The BVLC reference models are released for unrestricted use.

Please cite Caffe in your publications if it helps your research:

    @article{jia2014caffe,
      Author = {Jia, Yangqing and Shelhamer, Evan and Donahue, Jeff and Karayev, Sergey and Long, Jonathan and Girshick, Ross and Guadarrama, Sergio and Darrell, Trevor},
      Journal = {arXiv preprint arXiv:1408.5093},
      Title = {Caffe: Convolutional Architecture for Fast Feature Embedding},
      Year = {2014}
    }

