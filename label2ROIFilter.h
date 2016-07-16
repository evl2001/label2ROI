//
//  label2ROIFilter.h
//  label2ROI
//
//  Copyright (c) 2016 EM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@interface label2ROIFilter : PluginFilter {

}

- (long) filterImage:(NSString*) menuName;

- (ROI *) labelToROIConverter: (DCMPix *)curPix label:(int)labelValue;

@end
