//
//  CHOMPTrampoline.h
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import <Foundation/Foundation.h>

// This is the base CHOMP trampoline class; it is abstract, and should never be
// instantiated. Subclasses must provide an implementation of
// -methodSignatureForSelector: as well as an implementation of whatever SELs
// clients will be passing to it.

// A CHOMPTrampoline will catch any invocations sent to it and send them to itself
// using the selector given. Subclasses should therefore implement at least one
// method which takes an NSInvocation as an argument, and do their work from there.

@interface CHOMPTrampoline : NSProxy {
	SEL selector;
	id target;
}

+ trampolineWithSelector:(SEL)sel target:obj;

- initWithSelector:(SEL)sel target:obj;

@end
