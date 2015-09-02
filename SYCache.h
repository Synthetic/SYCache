//
//  SYCache.h
//  SYCache
//
//  Created by Sam Soffes on 10/31/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageOnComplete)(UIImage *image);
typedef void(^ImageOnSend)(void);

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
- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id object))block;
- (BOOL)objectExistsForKey:(NSString *)key;


///----------------------------------------
/// @name Adding and Removing Cached Values
///----------------------------------------

- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;


///-------------------------------
/// @name Accessing the Disk Cache
///-------------------------------

/**
 Returns the path to the object on disk associated with a given key.
 
 @param key An object identifying the value.
 
 @return Path to object on disk or `nil` if no object exists for the given `key`.
 */
- (NSString *)pathForKey:(NSString *)key;

@end


#if TARGET_OS_IPHONE

@interface SYCache (UIImageAdditions)

- (UIImage *)imageForKey:(NSString *)key;
- (void)imageForKey:(NSString *)key usingBlock:(void (^)(UIImage *image))block;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

/** Download an image resource. */
- (void)imageWithStringURL:(NSString *)fullPath
         completionHandler:(ImageOnComplete)completion
       beforeDownloadImage:(ImageOnSend)beforeComplete;

/** Download an image resource which is associating to a key-string. */
- (void)imageWithKey:(NSString*)key
       withStringURL:(NSString *)fullPath
   completionHandler:(ImageOnComplete)completion;


@end

#endif
