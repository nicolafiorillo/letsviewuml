//
//  GenericItemCollectionViewCell.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/4/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _GenericItemCollectionViewCell_TextPosition
{
	GICVC_TextPositionLeft, GICVC_TextPositionCenter
} GICVC_TextPosition;

extern CGFloat const kGenericItemCollectionViewCellSeparatorDistance;
extern CGFloat const kGenericItemCollectionViewCellTitleDistance;
extern CGFloat const kGenericItemCollectionViewCellLineWidth;
extern CGFloat const kGenericItemCollectionViewCellLeftSpace;

@interface GenericItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)NSString* name;
@property (strong, nonatomic)UIImage* preview;

@property (strong, nonatomic)UIFont * font;

- (void)drawName:(CGContextRef)context position:(GICVC_TextPosition)position;
- (void)drawPreview:(CGContextRef)context;

@end
