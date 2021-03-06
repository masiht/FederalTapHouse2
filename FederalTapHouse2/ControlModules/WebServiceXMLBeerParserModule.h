//
//  WebServiceXMLParserModule.h
//  FederalTaphouse2
//
//  Created by Di Kong on 2/6/15.
//  Copyright (c) 2015 Software Merchant. All rights reserved.
//

/**
 * This module deals with everything that has to do with XML parsing
 * that is returned from web server.
 *
 * Initialize with returned data from WebServiceConnectionModule
 * Then call startParsing to parse.
 * Result can be accessed by the beerList property.
 *
 */

#import <Foundation/Foundation.h>


@class BeerObject;
@class BeerDictionary;

/* Module interface */
@interface WebServiceXMLBeerParserModule : NSObject <NSXMLParserDelegate> {
    
    NSArray *imgList;
    NSMutableString *currentElement;
    BeerObject *currentBeer;
}

@property (nonatomic, strong)   NSData *data;
@property (nonatomic, readonly) BeerDictionary *beerDictionary;

- (instancetype)init;
- (instancetype)initWithData:(NSData *)d;
- (void)startParsing;

@end
