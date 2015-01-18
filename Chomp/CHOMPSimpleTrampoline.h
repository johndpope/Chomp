//
//  CHOMPSimpleTrampoline.h
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import <Foundation/Foundation.h>

#import "CHOMPTrampoline.h"


// this class is a basic trampoline which implements various "simple"
// HOMs that don't involve iteration

@interface CHOMPSimpleTrampoline : CHOMPTrampoline {
	id userData;
}

+ trampolineWithSelector:(SEL)sel target:obj userData:ud;

+ trampolineWithTarget:obj performAfterDelay:(NSTimeInterval)delay;

- initWithSelector:(SEL)sel target:obj userData:ud;

- (void)performAfterDelayWithInvocation:(NSInvocation *)invocation;
- (void)ignoreExceptionsWithInvocation:(NSInvocation *)invocation;

@end
