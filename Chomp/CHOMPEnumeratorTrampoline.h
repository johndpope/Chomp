//
//  CHOMPEnumeratorTrampoline.h
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import <Foundation/Foundation.h>

#import "CHOMPTrampoline.h"


// This class provides a framework for HOM enumeration constructs.

@interface CHOMPEnumeratorTrampoline : CHOMPTrampoline {
	BOOL iterate;
}

+ trampolineWithSelector:(SEL)sel collection:cln iterate:(BOOL)iter;

- initWithSelector:(SEL)sel collection:cln iterate:(BOOL)iter;

- (void)iterateWithInvocation:(NSInvocation *)invocation;

// the following methods allow subclasses to add additional behavior

// allows subclasses to perform setup for an iteration session
// the default implementation does nothing
- (void)prepareWithInvocation:(NSInvocation *)invocation;

// send the invocation to the given target
// the default implementation simply invokes the invocation; if a subclass
// overrides this, it must either invoke the invocation itself, or call
// super to do it
- (void)sendInvocation:(NSInvocation *)invocation toTarget:obj;

// allows subclasses to do something with the return values from the method calls
// this will only be called if the method actually returns an object
// the default implementation does nothing
- (void)processReturnValue:retVal;

// allows subclasses to provide a custom return value for the entire HOM
// this will only be called if the method actually returns an object
// the default implementation returns nil
- getReturnValue;

// allows subclasses to perform a takedown for an iteration session
// the default implementation does nothing
- (void)finalizeWithInvocation:(NSInvocation *)invocation;

@end
