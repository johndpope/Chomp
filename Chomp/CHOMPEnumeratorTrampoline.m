//
//  CHOMPEnumeratorTrampoline.m
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import "CHOMPEnumeratorTrampoline.h"

#import "CHOMPSingleObjectEnumerator.h"
#import <Foundation/Foundation.h>

enum _NSObjCValueType {
    NSObjCNoType        = 0,
    NSObjCVoidType      = 'v',
    NSObjCCharType      = 'c',
    NSObjCShortType     = 's',
    NSObjCLongType      = 'l',
    NSObjCLonglongType  = 'q',
    NSObjCFloatType     = 'f',
    NSObjCDoubleType    = 'd',
    NSObjCBoolType      = 'B',
    NSObjCSelectorType  = ':',
    NSObjCObjectType    = '@',
    NSObjCStructType    = '{',
    NSObjCPointerType   = '^',
    NSObjCStringType    = '*',
    NSObjCArrayType     = '[',
    NSObjCUnionType     = '(',
    NSObjCBitfield      = 'b'
};

@implementation CHOMPEnumeratorTrampoline

+ trampolineWithSelector:(SEL)sel collection:cln iterate:(BOOL)iter
{
    return [[[self alloc] initWithSelector:sel collection:cln iterate:iter] autorelease];
}

- initWithSelector:(SEL)sel collection:cln iterate:(BOOL)iter
{
    if ((self = [super initWithSelector:sel target:cln])) {
        iterate = iter;
    }
    return self;
}

- (void)iterateWithInvocation:(NSInvocation *)invocation {
    // this method handles the basic iteration over the invocation's target and
    // arguments as appropriate, while allowing subclasses to specialize its behavior
    
    // in order to enumerate over arguments, we need to find every NSEnumerator in the
    // argument list and remember them for later
    
    NSMethodSignature *signature = [invocation methodSignature];
    unsigned numOfArgs = [signature numberOfArguments];
    Class NSEnumeratorClass = [NSEnumerator class];
    unsigned *enumeratorIndexes = malloc((numOfArgs - 2) * sizeof(*enumeratorIndexes));
    NSMutableArray *enumerators = [NSMutableArray array];
    unsigned numberOfEnumerators = 0;
    unsigned arg;
    for (arg = 2; arg < numOfArgs; arg++) { // skip self and _cmd
        if ([signature getArgumentTypeAtIndex:arg][0] == NSObjCObjectType) {
            id obj;
            [invocation getArgument:&obj atIndex:arg];
            if ([obj isKindOfClass:NSEnumeratorClass]) {
                enumeratorIndexes[numberOfEnumerators] = arg;
                [enumerators addObject:obj];
                numberOfEnumerators++;
            }
        }
    }
    
    BOOL canProcessReturnValue = [signature methodReturnType][0] == NSObjCObjectType;
    
    [self prepareWithInvocation:invocation];
    
    // prepare the enumerator we use for the collection
    // if we're not iterating over the collection, use a placeholder enumerator
    // if the arguments don't contain any enumerators and we're not iterating
    // over the target, then we only want to iterate once, otherwise iterate
    // until the argument enumerators run out
    BOOL canIterate = iterate || numberOfEnumerators > 0;
    NSEnumerator *objectEnumerator;
    if (iterate)
        objectEnumerator = [target objectEnumerator];
    else
        objectEnumerator = [CHOMPSingleObjectEnumerator enumeratorWithObject:target repeat:canIterate];
    
    id obj;
    while ((obj = [objectEnumerator nextObject])) {
        unsigned enumerator;
        for (enumerator = 0; enumerator < numberOfEnumerators; enumerator++) {
            id curObj = [[enumerators objectAtIndex:enumerator] nextObject];
            if (!curObj) // enumerator finished, abort the enumeration
                goto endOfIteration; // ugly!
            [invocation setArgument:&curObj atIndex:enumeratorIndexes[enumerator]];
        }
        
        NS_DURING
        [self sendInvocation : invocation toTarget : obj];
        NS_HANDLER free(enumeratorIndexes); // clean up memory
        
        [localException raise];
        NS_ENDHANDLER
        
        if (canProcessReturnValue) {
            id returnValue;
            [invocation getReturnValue:&returnValue];
            [self processReturnValue:returnValue];
        }
    }
    
endOfIteration:
    free(enumeratorIndexes);
    
    if (canProcessReturnValue) {
        id obj = [self getReturnValue];
        [invocation setReturnValue:&obj];
    }
    else if ([signature methodReturnLength] > 0) {
        void *zeroValue = calloc(1, [signature methodReturnLength]);
        [invocation setReturnValue:&zeroValue];
        free(zeroValue);
    }
    
    [self finalizeWithInvocation:invocation];
}

- (void)prepareWithInvocation:(NSInvocation *)invocation {
}

- (void)sendInvocation:(NSInvocation *)invocation toTarget:obj
{
    [invocation invokeWithTarget:obj];
}

- (void)processReturnValue:retVal
{
}

- getReturnValue
{
    return nil;
}

- (void)finalizeWithInvocation:(NSInvocation *)invocation {
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    // if we aren't iterating, then we can just ask the object itself
    if (!iterate)
        return [target methodSignatureForSelector:sel];
    
    // pick an arbitrary object from the collection and use that
    
    // if the collection contains nothing, the signature isn't very important
    // we'll use NSObject's -description signature, since it returns id
    if ([target count] == 0)
        return [NSObject instanceMethodSignatureForSelector:@selector(description)];
    
    // try a couple of selectors to get an arbitrary object
    if ([target respondsToSelector:@selector(objectAtIndex:)])
        return [[target objectAtIndex:0] methodSignatureForSelector:sel];
    else if ([target respondsToSelector:@selector(anyObject)])
        return [[target anyObject] methodSignatureForSelector:sel];
    else {
        // last resort: ask it for an enumerator and take the first object from it
        // this is probably really slow
        return [[[target objectEnumerator] nextObject] methodSignatureForSelector:sel];
    }
}

@end
