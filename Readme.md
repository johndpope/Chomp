<HTML>
<HEAD>
<TITLE>How to use the Cocoa Higher-Order Messaging Platform</TITLE>
</HEAD>

<BODY>
<h2>How to use the Cocoa Higher-Order Messaging Platform</h2>
<h3>1. Basics</h3>

<P>A Higher-Order Message is a message which takes another message as its argument. This is done with the following syntax construction:</P>
<PRE>
[[obj higher_order_message] argument];
</PRE>

<P>Even though this is different from what you normally expect to see in Objective-C syntax, HOM does not require any compiler support. The compiler sees both the HOM and the argument as normal ObjC messages, and the magic is all done by the CHOMP library.</P>

<h3>2. Iteration</h3>

<h4>2.a. <CODE>-do</CODE></h4>
<P>The main use for HOMs is for simpler iteration support. HOMs often allow you to accomplish in one simple line of code something that requires many lines of code otherwise. Let's look at a simple example first. Say you have an array of objects and you want to send the -step message to every object in the array. This is simple enough to do in Cocoa:</P>
<PRE>
[array makeObjectsPerformSelector:@selector(step)];
</PRE>
<P>With a HOM, it's even simpler:</P>
<PRE>
[[array do] step];
</PRE>
<P>The HOM form is shorter, simpler to write, and easier to read. Also, since the argument message can be any Objective-C message expression, you can do things that the normal Cocoa version can't do:</P>
<PRE>
[[array do] stepInRange:NSMakeRange(0, length)];
</PRE>
<P>This simply can't be done without writing a full enumerator loop, which is going to be at least a few lines of code.</P>

<P>You can use the <CODE>-do</CODE> message to send any message to the contents of any Cocoa collection, whether it's an NSArray, NSSet, or NSDictionary. (NSDictionaries send the message to their objects, not their keys.)</P>

<H4>2.b. <CODE>-each</CODE></H4>

<P>CHOMP's iteration support only gets better. Let's take the following Cocoa code:</P>
<PRE>
NSEnumerator *targetEnum = [targets objectEnumerator];
NSEnumerator *argument1Enum = [array1 objectEnumerator];
NSEnumerator *argument2Enum = [array2 objectEnumerator];
id target;
while((target = [targetEnum nextObjec]))
    [target someMethod:[argument1Enum nextObject]
            withObject:[argument2Enum nextObject]];
</PRE>
<P>This is pretty straightforward code, right? We iterate over several arrays and send a message made up of the objects within. Let's look at how to do this with HOM:</P>
<PRE>
[[targets do] someMethod:[array1 each] withObject:[array2 each]];
</PRE>
<P>Six lines of wordy code reduced to a single line which exactly expresses what it's doing.</P>

<P>Any time you have an NSEnumerator as an argument inside a HOM message argument, the HOM will iterate over that enumerator instead of passing it blindly along. The <CODE>-each</CODE> method is a shortcut for the <CODE>-objectEnumerator</CODE> message.</P>

<H4>2.c. <CODE>-collect</CODE></H4>

<P>The <CODE>-collect</CODE> HOM might be the most useful one of the bunch. It's exactly the same as <CODE>-do</CODE>, except that it returns an array or set that holds the result of every message send. Here's an example:</P>
<PRE>
id array1 = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
id array2 = [[array1 collect] stringByAppendingString:@".0"];
</PRE>
<P><CODE>array2</CODE> now contains "1.0", "2.0", and "3.0". <CODE>-collect</CODE> can also use the <CODE>-each</CODE> message, just like <CODE>-do</CODE>. To make a new array that contains the result of appending two arrays of strings together, you can do this:</P>
<PRE>
combinedArray = [[array1 collect] stringByAppendingString:[array2 each]];
</PRE>

<P>When you send <CODE>-collect</CODE> to an NSSet, the result is also an NSSet. When you send it to an array or dictionary, the result is an NSArray.</P>

<P>Note that <CODE>-collect</CODE> only works on messages which return an object. If you give it a message which returns an int, an NSRange, or any other non-object type, it will act exactly like <CODE>-do</CODE> and will simply return nil.</P>

<H4>2.d. <CODE>-doSelf</CODE>, <CODE>-collectSelf</CODE></H4>

<P>So far we've seen how to iterate over a collection as the target of a message, and how to iterate over arguments. You may have noticed that we have the choice of iterating over arguments or simply using the same object every time, but we always iterate over the target. What if we wanted to iterate over an argument but not over the target? That's what these messages are for.</P>

<P><CODE>-doSelf</CODE> and <CODE>-collectSelf</CODE> work exactly like <CODE>-do</CODE> and <CODE>-collect</CODE>, except that they don't iterate over the object you send them to. You can still pass <CODE>-each</CODE> arguments in the HOM's argument, allowing you to iterate over a collection as an argument. You can send these messages to any NSObject.</P>

<P>Invoking a method with every element of a collection:</P>
<PRE>
- (void)someMethod:argument { ... }

[[self doSelf] someMethod:[array each]];
</PRE>

<P>Adding a prefix to every string in an array:</P>
<PRE>
id array1 = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
id array2 = [[@"1." collectSelf] stringByAppendingString:[array2 each]];
</PRE>

<P>Taking an array of keys, and getting an array of values for those keys from a dictionary:</P>
<PRE>
id valueArray = [[dictionary collectSelf] objectForKey:[keys each]];
</PRE>

<P>Take an array holding strings, and make an array holding mutable strings with the same contents:</P>
<PRE>
id mutableArray = [[NSMutableString collectSelf] stringWithString:[array each]];
</PRE>

<P>This last one looks pretty wacky, but it works just fine. Remember that all Objective-C classes are instances of NSObject, and class messages work just like instance messages.</P>

<P>Sending <CODE>-collectSelf</CODE> always results in an NSArray. If you use a message whose return type is not an object, the result is nil.</P>

<h3>3. Other HOMs</h3>

<P>The HOM concept can also be applied to other things. Many methods which accept selectors can be rewritten using HOMs to gain flexibility.</P>

<h4>3.a. <CODE>-performAfterDelay:</CODE></h4>
<P>This method is equivalent to <CODE>-performSelector:withObject:afterDelay:</CODE>. It always returns 0. Example:
<PRE>
[[object performAfterDelay:5.0] messageWithArgument:object2 inRange:someRange];
</PRE>

<h4>3.b. <CODE>-ignoreExceptions</CODE></h4>
<P>This method sends the given message but traps and ignores any exceptions that occur during the send. It returns the result of the message if no exception was thrown, or 0 if an exception was thrown. Example:</P>
<PRE>
[[obj ignoreExceptions] thisMightThrow];
</PRE>
</BODY>
</HTML>

