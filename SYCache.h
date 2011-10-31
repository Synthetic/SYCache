//
//  SYCache.h
//  SYCache
//
//  Created by Sam Soffes on 10/31/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCache : NSObject

@property (nonatomic, copy, readonly) NSString *name;

///-------------------------------
/// @name Getting the Shared Cache
///-------------------------------

+ (SYCache *)sharedCache;


///-------------------
/// @name Initializing
///-------------------

- (id)initWithName:(NSString *)name;


///-----------------------------
/// @name Getting a Cached Value
///-----------------------------

- (id)objectForKey:(NSString *)key;
- (BOOL)hasObjectForKey:(NSString *)key;


///----------------------------------------
/// @name Adding and Removing Cached Values
///----------------------------------------

- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;


///-------------------------------
/// @name Accessing the Disk Cache
///-------------------------------

- (NSString *)pathForKey:(NSString *)key;

@end
