# SYCache

Simple in memory and on disk cache. It's backed by an [NSCache](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/NSCache_Class/Reference/Reference.html) in memory, so it automatically purges itself when memory gets low. Purged memory keys will automatically be loaded from disk the next time the are requested.

## Usage

The API is simple.

``` objective-c
- (id)objectForKey:(NSString *)key;
- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id object))block;
- (void)setObject:(id)object forKey:(NSString *)key;
```

See [SYCache.h](https://github.com/Synthetic/SYCache/blob/master/SYCache.h) for the full list of methods.
