//
//  CrackedScreenView.m
//  CrackedScreen
//
//  Created by Heath Borders on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CrackedScreenView.h"
#import <AudioToolbox/AudioToolbox.h>

#define OUTER_POINTS_PER_SIDE 5

@interface CrackedScreenView()

@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) BOOL touched;
@property (nonatomic, retain) NSArray *outerPointValues;
@property (nonatomic, retain) NSURL *glassBreakWavUrl;
@property (nonatomic) SystemSoundID glassBreakWavSystemSoundID;

- (NSArray *) randomPointValuesBetweenZeroAnd: (CGFloat) maxFloat
						   pointMakerSelector: (SEL) pointMakerSelector;

- (NSValue *) topPointValueWithXValue: (NSValue *) xValue;
- (NSValue *) leftPointValueWithYValue: (NSValue *) yValue;
- (NSValue *) rightPointValueWithYValue: (NSValue *) yValue;
- (NSValue *) bottomPointValueWithXValue: (NSValue *) xValue;

@end


@implementation CrackedScreenView

@synthesize touchPoint = _touchPoint;
@synthesize touched = _touched;
@synthesize outerPointValues = _outerPointValues;
@synthesize glassBreakWavUrl = _glassBreakWavUrl;
@synthesize glassBreakWavSystemSoundID = _glassBreakWavSystemSoundID;

#pragma mark -
#pragma mark NSObject

- (id) initWithCoder:(NSCoder *) aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.glassBreakWavUrl = [[NSBundle mainBundle] URLForResource: @"glass-break"
														withExtension: @"wav"];
		AudioServicesCreateSystemSoundID((CFURLRef) self.glassBreakWavUrl,
										 &_glassBreakWavSystemSoundID);
	}
	
	return self;
}

- (void) dealloc {
	self.outerPointValues = nil;
	self.glassBreakWavUrl = nil;
	AudioServicesDisposeSystemSoundID (self.glassBreakWavSystemSoundID);
	
	[super dealloc];
}

#pragma mark -
#pragma mark UIResponder

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.touched) {
		UITouch *anyTouch = [touches anyObject];
		self.touchPoint = [anyTouch locationInView:self];
		self.touched = YES;
		
		NSMutableArray *outerPointValues = [NSMutableArray arrayWithCapacity:4 * OUTER_POINTS_PER_SIDE];
		[outerPointValues addObjectsFromArray:[self randomPointValuesBetweenZeroAnd:self.bounds.size.width
																 pointMakerSelector:@selector(topPointValueWithXValue:)]];
		[outerPointValues addObjectsFromArray:[self randomPointValuesBetweenZeroAnd:self.bounds.size.height
																 pointMakerSelector:@selector(leftPointValueWithYValue:)]];
		[outerPointValues addObjectsFromArray:[self randomPointValuesBetweenZeroAnd:self.bounds.size.height
																 pointMakerSelector:@selector(rightPointValueWithYValue:)]];
		[outerPointValues addObjectsFromArray:[self randomPointValuesBetweenZeroAnd:self.bounds.size.width
																 pointMakerSelector:@selector(bottomPointValueWithXValue:)]];
		self.outerPointValues = outerPointValues;
		[self setNeedsDisplay];
		AudioServicesPlayAlertSound(self.glassBreakWavSystemSoundID);
	}
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	self.touched = NO;
	self.outerPointValues = nil;
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark UIView

- (void) drawRect: (CGRect) rect {
	CGContextRef graphicsContextRef = UIGraphicsGetCurrentContext();
	if (self.touched) {
		CGContextSetRGBStrokeColor(graphicsContextRef, 1, 1, 1, 1);
		for (NSValue *outerPointValue in self.outerPointValues) {
			CGPoint outerPoint = [outerPointValue CGPointValue];
			CGContextMoveToPoint(graphicsContextRef, self.touchPoint.x, self.touchPoint.y);
			CGContextAddLineToPoint(graphicsContextRef, outerPoint.x, outerPoint.y);
		}
		CGContextDrawPath(graphicsContextRef, kCGPathStroke);
	} else {
		CGContextSetFillColorWithColor(graphicsContextRef, [[UIColor blackColor] CGColor]);
		CGContextFillRect(graphicsContextRef, self.bounds);
	}
}

#pragma mark -
#pragma mark private API

- (NSArray *) randomPointValuesBetweenZeroAnd: (CGFloat) maxFloat
						   pointMakerSelector: (SEL) pointMakerSelector {
	NSMutableArray *randomPointValues = [NSMutableArray arrayWithCapacity:OUTER_POINTS_PER_SIDE];
	for (NSUInteger i=0; i < OUTER_POINTS_PER_SIDE; i++) {
		CGFloat randomFloat = (CGFloat) (arc4random() % (u_int32_t) maxFloat);
		NSValue *randomFloatValue = [NSValue value:&randomFloat
									  withObjCType:@encode(CGFloat)];
		NSValue *randomPointValue = [self performSelector:pointMakerSelector 
											   withObject:randomFloatValue];
		[randomPointValues addObject:randomPointValue];
	}
	
	return randomPointValues;
}

- (NSValue *) topPointValueWithXValue: (NSValue *) xValue {
	CGFloat x;
	[xValue getValue:&x];
	return [NSValue valueWithCGPoint:CGPointMake(x, 0)];
}

- (NSValue *) leftPointValueWithYValue: (NSValue *) yValue {
	CGFloat y;
	[yValue getValue:&y];
	return [NSValue valueWithCGPoint:CGPointMake(0, y)];
}

- (NSValue *) rightPointValueWithYValue: (NSValue *) yValue {
	CGFloat y;
	[yValue getValue:&y];
	return [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width, y)];
}

- (NSValue *) bottomPointValueWithXValue: (NSValue *) xValue {
	CGFloat x;
	[xValue getValue:&x];
	return [NSValue valueWithCGPoint:CGPointMake(x, self.bounds.size.height)];
}

@end
