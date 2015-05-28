//
//  HGPhotoWall.h
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGPhotoWallDelegate <NSObject>

@optional
- (void)photoWallPhotoTaped:(NSUInteger)index;
- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)photoWallAddAction;
- (void)photoWallAddFinish;
- (void)photoWallDeleteFinish;

@end

@interface HGPhotoWall : UIView

@property (assign,nonatomic) id<HGPhotoWallDelegate> delegate;

- (void)setPhotos:(NSArray*)photos;
- (void)setEditModel:(BOOL)canEdit;
- (void)addPhoto:(NSString*)string;
- (void)deletePhotoByIndex:(NSUInteger)index;

@end
