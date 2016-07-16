//
//  label2ROIFilter.m
//  label2ROI
//
//  Copyright (c) 2016 EM. All rights reserved.
//

#import "label2ROIFilter.h"

@implementation label2ROIFilter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
    NSArray     *pixList    = [viewerController pixList: 0];
    int         totalSlices = [pixList count];
//    int         curSlice    = [[viewerController imageView] curImage];
//    DCMPix      *curPix     = [pixList objectAtIndex:curSlice];
    
    ROI         *returnedROI;
    
    
    
    int         i = 0;
    int         fatLabelValue = 1;
    NSLog(@"Total slices %i",totalSlices);
    for (i = 0; i < totalSlices; i++ )
    {
        NSLog(@"Current slice %i", i);
        DCMPix *curPix = [pixList objectAtIndex: i];
        returnedROI = [self labelToROIConverter:curPix label:fatLabelValue];
        // add the new ROI to the ROI list of the current image
        NSMutableArray  *roiSeriesList = [viewerController roiList];
        //int     curSlice = [[viewerController imageView] curImage];
        NSMutableArray  *roiImageList = [roiSeriesList objectAtIndex: i];
        
        [roiImageList addObject: returnedROI];
        
        [viewerController needsDisplayUpdate];
        
    }
    
    //float       ROIVolume = [viewerController computeVolume:MyROI points:nil error: nil];

    
    return 0;
}

- (ROI *) labelToROIConverter: (DCMPix *)curPix label:(int)labelValue
{
    ROI     *brushROI;
    float   pixHeight   = [curPix pheight];
    float   pixWidth    = [curPix pwidth];
    float   netPixels   = pixWidth * pixHeight;
    float   *fImageA    = [curPix fImage];
    
    unsigned char   *textureBuffer = (unsigned char*)malloc(netPixels*sizeof(unsigned char));
    
    int     x,j;
    
    for (x = 0; x < netPixels; x++)
    {
        textureBuffer[x] = 0x00;
    }
    
    j = 0;
    
    for (x = 0; x < netPixels; x++)
    {
        //NSLog(@"Pix value %f", fImageA[x]);
        if (fImageA[x] > 900)
        {
            textureBuffer[x] = 0xFF;
            j = j+1;
        }
    }
    brushROI = [[[ROI alloc] initWithTexture:textureBuffer
                                    textWidth:pixWidth textHeight:pixHeight
                                     textName:@"FAT" positionX:0 positionY:0
                                     spacingX:[curPix pixelSpacingX]  spacingY:[curPix pixelSpacingY]
                                  imageOrigin:NSMakePoint( [curPix originX], [curPix originY])] autorelease];
    NSLog(@"Total pixels in ROI %i", j);
    free(textureBuffer);
    
    return brushROI;
    
}

@end
