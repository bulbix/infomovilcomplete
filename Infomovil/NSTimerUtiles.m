//
//  NSTimerUtilies.m
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 20/07/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import "NSTimerUtiles.h"


@implementation NSTimer (NSTimerUtilies)


+ (NSTimer *)creaTimerConIntervalo:(NSTimeInterval)intervalo aPartirDeFecha:(NSDate *)fechaRef target:(id)target selector:(SEL)sel
{
	NSDate *fechaActual = [[NSDate alloc] init];
	NSTimeInterval aPartir = [fechaActual timeIntervalSinceDate:fechaRef];

	[fechaActual release];
	if ( aPartir >= intervalo )
		aPartir = 0;
	else
		aPartir = intervalo - aPartir;
	
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:aPartir]
											  interval:intervalo
												target:target
											  selector:sel
											  userInfo:nil
											   repeats:YES];
	
	// Add the timer to the current run loop.
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	
	return [timer autorelease];
}

+ (NSTimer *)timerEjecucionInmediataConIntervalos:(NSTimeInterval)intervalo target:(id)target selector:(SEL)sel
{
	return nil;
}

+ (NSTimer *)timerConIntervalos:(NSTimeInterval)intervalo aPartirDeFecha:(NSDate *)fechaRef target:(id)target selector:(SEL)sel
{
	return nil;
}

+ (NSTimer *)timerConIntervalos:(NSTimeInterval)intervalo target:(id)target selector:(SEL)sel
{
	return nil;
}


@end
