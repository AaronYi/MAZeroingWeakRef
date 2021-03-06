//
//  MAWeakArray.m
//  ZeroingWeakRef
//
//  Created by Mike Ash on 7/13/10.
//

#import "MAWeakArray.h"

#import "MAZeroingWeakRef.h"


@implementation MAWeakArray

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    if((self = [super init]))
    {
        _weakRefs = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    self = [self initWithCapacity:cnt];
    
    for(NSInteger i = 0; i < cnt; i++)
        if(objects[i] != nil)
            [self addObject:objects[i]];
    
    return self;
}

- (void)dealloc
{
    [_weakRefs release];
    [super dealloc];
}

- (NSUInteger)count
{
    return [_weakRefs count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [[_weakRefs objectAtIndex: index] target];
}

- (void)addObject: (id)anObject
{
    [_weakRefs addObject: [MAZeroingWeakRef refWithTarget: anObject]];
}

- (void)insertObject: (id)anObject atIndex: (NSUInteger)index
{
    [_weakRefs insertObject: [MAZeroingWeakRef refWithTarget: anObject]
                    atIndex: index];
}

- (void)removeLastObject
{
    [_weakRefs removeLastObject];
}

- (void)removeObjectAtIndex: (NSUInteger)index
{
    [_weakRefs removeObjectAtIndex: index];
}

- (void)replaceObjectAtIndex: (NSUInteger)index withObject: (id)anObject
{
    [_weakRefs replaceObjectAtIndex: index
                         withObject: [MAZeroingWeakRef refWithTarget: anObject]];
}

- (id)copyWithZone:(NSZone *)zone
{
    id *objects = calloc([self count], sizeof(id));
    NSInteger count = 0;
    
    for(id obj in self)
        if(obj != nil)
        {
            objects[count] = obj;
            count++;
        }
    
    NSArray *ret = [[NSArray alloc] initWithObjects:objects count:count];
    
    free(objects);
    
    return ret;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    id *objects = calloc([self count], sizeof(id));
    NSInteger count = 0;
    
    for(id obj in self)
        if(obj != nil)
        {
            objects[count] = obj;
            count++;
        }
    
    NSArray *ret = [[NSMutableArray alloc] initWithObjects:objects count:count];
    
    free(objects);
    
    return ret;
}

@end
