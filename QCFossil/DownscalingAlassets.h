//
//  DownscalingAlassets.h
//  QCFossil
//
//  Created by Yin Huang on 14/10/16.
//  Copyright © 2016 kira. All rights reserved.
//

#ifndef DownscalingAlassets_h
#define DownscalingAlassets_h


#endif /* DownscalingAlassets_h */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@interface ImageScaling : NSObject

static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count);

static void releaseAssetCallback(void *info);

+ (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;

+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

@end