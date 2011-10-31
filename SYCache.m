//
//  SYCache.m
//  SYCache
//
//  Created by Sam Soffes on 10/31/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYCache.h"

@implementation SYCache {
	NSCache *_memoryCache;
	dispatch_queue_t _diskQueue;
	NSFileManager *_fileManager;
	NSString *_cacheDirectory;
}

@synthesize name = _name;

#pragma mark - NSObject

- (void)dealloc {
	[_memoryCache removeAllObjects];
	[_memoryCache release];
	_memoryCache = nil;
	
	dispatch_release(_diskQueue);
	_diskQueue = nil;
	
	[_name release];
	_name = nil;
	
	[_fileManager release];
	_fileManager = nil;
	
	[_cacheDirectory release];
	_cacheDirectory = nil;
	
	[super dealloc];
}


#pragma mark - Getting the Shared Cache

+ (SYCache *)sharedCache {
	static SYCache *sharedCache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedCache = [[SYCache alloc] initWithName:@"com.syntheticcorp.sycache.shared"];
	});
	return sharedCache;
}


#pragma mark - Initializing


- (id)initWithName:(NSString *)name {
	if ((self = [super init])) {
		_name = [name copy];
		_diskQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
		_fileManager = [[NSFileManager alloc] init];
		
		NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
		_cacheDirectory = [[cachesDirectory stringByAppendingFormat:@"/com.syntheticcorp.sycache/%@", name] retain];
		
		if (![_fileManager fileExistsAtPath:_cacheDirectory]) {
			[_fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}
	return self;
}


#pragma mark - Getting a Cached Value

- (id)objectForKey:(NSString *)key {
	__block id object = [_memoryCache objectForKey:key];
	if (object) {
		return object;
	}
	
	dispatch_sync(_diskQueue, ^{
		object = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForKey:key]] retain];
	});
	
	return [object autorelease];
}


- (BOOL)hasObjectForKey:(NSString *)key {
	__block BOOL exists = ([_memoryCache objectForKey:key] != nil);
	if (exists) {
		return exists;
	}
	
	dispatch_sync(_diskQueue, ^{
		exists = [_fileManager fileExistsAtPath:[self pathForKey:key]];
	});
	return exists;
}


#pragma mark - Adding and Removing Cached Values

- (void)setObject:(id)object forKey:(NSString *)key {
	[_memoryCache setObject:object forKey:key];
	
	dispatch_async(_diskQueue, ^{
		[NSKeyedArchiver archiveRootObject:object toFile:[self pathForKey:key]];
	});
}


- (void)removeObjectForKey:(id)key {
	[_memoryCache removeObjectForKey:key];
	dispatch_async(_diskQueue, ^{
		[_fileManager removeItemAtPath:[self pathForKey:key] error:nil];
	});
}


- (void)removeAllObjects {
	[_memoryCache removeAllObjects];
	dispatch_async(_diskQueue, ^{
		NSArray *paths = [_fileManager contentsOfDirectoryAtPath:_cacheDirectory error:nil];
		for (NSString *path in paths) {
			[_fileManager removeItemAtPath:[_cacheDirectory stringByAppendingPathComponent:path] error:nil];
		}
	});
}


#pragma mark - Accessing the Disk Cache

- (NSString *)pathForKey:(NSString *)key {
	return [_cacheDirectory stringByAppendingPathComponent:key];
}

@end
