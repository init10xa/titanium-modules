/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "IoVesselModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "Vessel.h"
#import "VesselAB.h"

@implementation IoVesselModule

-(void)_destroy
{
	// Make sure to release the callback objects
	RELEASE_TO_NIL(testNotAvailable);
	RELEASE_TO_NIL(testLoaded);
	
	[super _destroy];
}


#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"83419901-c7f8-4b11-a8bb-2c254d828a7f";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"io.vessel";
}

-(NSString *)variationName:(VesselABTestVariation) var
{
    switch (var) {
        case VesselABTestVariationA:
            return @"A";
        case VesselABTestVariationB:
            return @"B";
        case VesselABTestVariationC:
            return @"C";
        case VesselABTestVariationD:
            return @"D";
        case VesselABTestVariationE:
            return @"E";
        case VesselABTestVariationUnknown:
            return nil;
            
        default:
            return nil;
    }
}

-(void)sendTestLoaded:(NSString *)testName withVariation:(VesselABTestVariation)variation
{
	if (testLoaded != nil){
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[event setObject:testName forKey:@"test"];
		[event setObject:[self variationName:variation] forKey:@"variation"];
		
		// Fire an event directly to the specified listener (callback)
		[self _fireEventToListener:@"testLoaded" withObject:event listener:testLoaded thisObject:nil];
	}
}

-(void)sendTestNotAvailable
{
	if (testNotAvailable != nil){
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		// Fire an event directly to the specified listener (callback)
		[self _fireEventToListener:@"testNotAvailable" withObject:event listener:testNotAvailable thisObject:nil];
	}
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(void)initialize:(id)args
{
    ENSURE_SINGLE_ARG(args,NSString);
    NSLog(@"[INFO] vessel key is %@", args);
    [Vessel initializeWithAppSecret:args];
    
}

-(NSNumber*)isTestRunning:(id)args
{
    VesselAB *inst = [VesselAB sharedInstance];
    if(VesselABTestLoaded == inst.testLoadStatus) {
        return NUMBOOL(YES);
    } else {
        return NUMBOOL(NO);
    }
}

-(NSString *)whichVariation:(id) testName
{
    ENSURE_SINGLE_ARG(testName, NSString);
    VesselABTestVariation var = [VesselAB variationForTestName:testName];
    return [self variationName:var];
}

-(NSString *)whichVariationTestId:(id) testId
{
    NSInteger testIdInt = [TiUtils intValue:testId];
    VesselABTestVariation var = [VesselAB variationForTestID:testIdInt];
    return [self variationName:var];
}

-(NSString *)whichTest:(id)args
{
    VesselAB *inst = [VesselAB sharedInstance];
    return inst.testName;
}

-(NSNumber *)isTestVariationRunning:(id)args
{
    //ENSURE_SINGLE_ARG(args, NSDictionary);
    NSString *testName = [args objectAtIndex:0];
	NSString *variationName = [args objectAtIndex:1];
    
    /*
    NSString *testName = [args objectForKey:@"testName"];
    NSString *variationName = [args objectForKey:@"variationName"];
    */
    NSString *var = [self whichVariation:testName];
    return NUMBOOL([var isEqualToString:variationName]);
}

-(NSNumber *)getTestId:(id)args
{
    VesselAB *inst = [VesselAB sharedInstance];
    return NUMINT(inst.testID);
}

-(NSString *)getValue:(id)args
{
    //ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *key = [args objectAtIndex:0];
    NSString *defaultVal = [args objectAtIndex:1];
    /*
    NSString *key = [args objectForKey:@"key"];
    NSString *defaultVal = [args objectForKey:@"defaultValue"];
     */
    return [VesselAB valueForVariationVariable:key defaultValue:defaultVal];
}

-(void)reloadTest:(id)args
{
    [VesselAB reloadTest];
}

- (void) checkPointVisited:(id)checkpointName
{
    ENSURE_SINGLE_ARG(checkpointName, NSString);
    [VesselAB checkpointVisited:checkpointName];
}

- (void) startSession:(id)sessionName
{
    ENSURE_SINGLE_ARG(sessionName, NSString);
    [VesselAB startSession:sessionName];
}

- (void) endSession:(id)sessionName
{
    ENSURE_SINGLE_ARG(sessionName, NSString);
    [VesselAB endSession:sessionName];
}

- (void) endAllSessions:(id)args
{
    [VesselAB endAllSessions];
}

- (void) discardAllSessions:(id)args
{
    [VesselAB discardAllSessions];
}

-(void) setABListener:(id)args {
    /*
    ENSURE_SINGLE_ARG(args, NSDictionary);
	*/
	NSLog(@"[Vessel] setABListener called");
    testLoaded = [[args objectAtIndex:0] retain];
	testNotAvailable = [[args objectAtIndex:1] retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testChanged:)
                                                 name:VesselABTestChangedNotification object:nil];
    [VesselAB getTestWithSuccessBlock:^(NSString *testName, VesselABTestVariation variation)
     {
         [self sendTestLoaded:testName withVariation:variation];
     } failureBlock:^ {
         [self sendTestNotAvailable];
     }];
}

@end

