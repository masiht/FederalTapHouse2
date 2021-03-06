//
//  FoodObject.h
//  FederalTapHouse2
//
//  Created by Di Kong on 2/6/15.
//  Copyright (c) 2015 Software Merchant. All rights reserved.
//

/**
 * This class models the food items on menu
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FoodObject : NSObject

@property (nonatomic, strong) UIImage *foodImage;
@property (nonatomic, copy) NSString *foodName;
@property (nonatomic, copy) NSString *foodDescription;
@property (nonatomic, copy) NSString *foodPrice;
@property (nonatomic, readonly) float foodPriceValue;
@property (nonatomic, copy) NSString *foodCategory;     // category: appetizer, entree, dessert etc

- (instancetype)init;
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name description:(NSString *)dscrptn price:(NSString *)price category:(NSString *)cat;

@end
