//
//  CHOMPSingleObjectEnumerator.h
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import <Foundation/Foundation.h>


// This is a simple NSEnumerator class that presents a single object
// through the enumerator interface. This can help make some code
// more consistent and have fewer special cases.

@interface CHOMPSingleObjectEnumerator : NSEnumerator {
	id object;
	BOOL repeat;
}

+ enumeratorWithObject:obj repeat:(BOOL)yorn;

- initWithObject:obj repeat:(BOOL)yorn;

@end
