//
//  URLRequestExtensions.h
//  Vienna
//
//  Created by Barijaona Ramaholimihaso on 03/08/2018.
//  Copyright © 2018 uk.co.opencommunity. All rights reserved.
//

@import Foundation;

// category of NSMutableURLRequest for adding properties with getter and setter
@interface NSMutableURLRequest (userDict)

@property (nullable, copy, setter=vna_setUserInfo:) id vna_userInfo;
// add/set object into current userInfo
-(void)vna_setInUserInfo:(nullable id)object forKey:(nonnull NSString *)key;
-(void)vna_addInfoFromDictionary:(NSDictionary *_Nullable)additionalDictionary;

@end

// category of "POST" NSMutableURLRequest for setting POST values
@interface NSMutableURLRequest (MutablePostExtensions)

- (void)vna_setPostValue:(nullable NSString *)value
                  forKey:(nonnull NSString *)key;

@end
