//
//  WebServiceConnectionModule.m
//  FederalTaphouse2
//
//  Created by Di Kong on 2/6/15.
//  Copyright (c) 2015 Software Merchant. All rights reserved.
//

/**
 * Implementation of web service connection module
 *
 */
#import "AppDelegate.h"
#import "WebServiceConnectionModule.h"
#import "WebServiceXMLLoginParserModule.h"
#import "WebServiceXMLBeerParserModule.h"


@interface WebServiceConnectionModule()

@property (nonatomic, readwrite) NSData *responseData;

@end


@implementation WebServiceConnectionModule

/* Default constructor */
- (instancetype)init {
    
    self = [self initWithUrl:nil method:nil];
    return self;
}

/* Designated constructor with username and password, url, and method */
-(instancetype)initWithUrl:(NSString *)u Username:(NSString *)username Password:(NSString *)password method:(NSString *)m  {
    self = [super init];
    
    if (self) {
        self.username = username;
        self.password = password;
        self.url = u;
        self.method = m;
        responseDataMutable = [NSMutableData data];
    }
    return self;
}

/* Constructor with url and method */
- (instancetype)initWithUrl:(NSString *)u method:(NSString *)m {
    
    self = [self initWithUrl:u Username:nil Password:nil method:m];
    return self;
}


/* Method to start the connection to url with method */
- (void)establishConnection {
    
    if (self.url == nil || self.method == nil) {
        return;
    }
    NSString *envelopeText = [self generateEnvelope];
    NSData *envelopeData = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelopeData];
    [request setValue:@"application/soap+xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%li", (unsigned long)[envelopeData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection __unused *con = [[NSURLConnection alloc] initWithRequest:request
                                                                    delegate:self
                                                            startImmediately:YES];
}

/* Returns the envelope XML string with method embedded */
- (NSString *)generateEnvelope {
    
    // cases for different methods
    // Available methods would be:
    // - getBeerList
    // - IsUserValid
    // - registerDeviceToken
    // - ...
    
    /*if ([_method isEqualToString:@"getBeerList"]) {
        
        return @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
        "                 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
        "                 xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
        "  <soap12:Body>\n"
        "    <getBeerList xmlns=\"http://tempuri.org/\" />\n"
        "  </soap12:Body>\n"
        "</soap12:Envelope>\n";
        
    } else*/
    if ([_method isEqualToString:@"IsUserValid"]) {
        
        return [NSString stringWithFormat:
                @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                "<soap12:Body>\n"
                "<IsUserValid xmlns=\"http://tempuri.org/\">\n"
                "<UserID>%@</UserID>\n"
                "<Password>%@</Password>\n"
                "</IsUserValid>\n"
                "</soap12:Body>\n"
                "</soap12:Envelope>\n",_username, _password];
    
    } else if ([_method isEqualToString:@"registerDeviceToken"]) {
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        return [NSString stringWithFormat:
        @"\"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
        "<soap12:Body>\n"
        "<registerDeviceToken xmlns=\"http://tempuri.org/\">\n"
        "<UserID>%@</UserID>\n"
        "<DeviceToken>%@</DeviceToken>\n"
        "</registerDeviceToken>\n"
        "</soap12:Body>\n"
        "</soap12:Envelope>\n", _username, app.deviceToken];
    }
    else /*if ([_method isEqualToString:@"getAllDeviceTokens"])*/ {
        
        return [NSString stringWithFormat:
                @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
                "                 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
                "                 xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                "  <soap12:Body>\n"
                "    <%@ xmlns=\"http://tempuri.org/\" />\n"
                "  </soap12:Body>\n"
                "</soap12:Envelope>\n", _method];
    }
    return nil;
}


#pragma mark - URL Connection Delegate Method

/* Called when connection fails */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"WebServiceConnection failed with error: %@ %@",
          [error localizedDescription], [error.userInfo objectForKey:NSURLErrorFailingURLErrorKey]);
}


#pragma mark - URL Connection Data Method

/* Called when data comes in, possibly called multiple times to append data */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseDataMutable appendData:data];
}

/* Called when http response comes in */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

/* Called when connection returns all data and is terminated
 * Signals caller that connection is finished by calling signalFrom:self
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.responseData = [NSData dataWithData:responseDataMutable];
    
    /* NSLog output if needed */
    
//    NSString *dataString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"WebServiceConnection returned data successfully.\n\n%@", dataString);
    
    [self.signalDelegate connectionDidFinishSignalFrom:self];
}


@end
