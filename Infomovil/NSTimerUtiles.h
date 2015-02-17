//
//  NSTimerUtilies.h
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 20/07/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (NSTimerUtilies)

//+ (NSTimer *)creaTimerConIntervalos:(NSTimeInterval)intervalo aPartirDeFecha:(NSDate *)fechaRef target:(id)target selector:(SEL)sel;
//+ (NSTimer *)creaTimerConIntervalos:(NSTimeInterval)intervalo aPartirDeFecha:(NSDate *)fechaRef target:(id)target selector:(SEL)sel;
//
//
//- (NSTimer *)creaTimerEjecucionInmediataConIntervalo:(NSTimeInterval)intervalo target:(id)target selector:(SEL)sel;


+ (NSTimer *)timerEjecucionInmediataConIntervalos:(NSTimeInterval)intervalo target:(id)target selector:(SEL)sel;
+ (NSTimer *)timerConIntervalos:(NSTimeInterval)intervalo aPartirDeFecha:(NSDate *)fechaRef target:(id)target selector:(SEL)sel;
+ (NSTimer *)timerConIntervalos:(NSTimeInterval)intervalo target:(id)target selector:(SEL)sel;


@end
