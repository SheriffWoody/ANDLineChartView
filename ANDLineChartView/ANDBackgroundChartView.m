//
//  ANDBackgroundChartView.m
//  Pods
//
//  Created by Andrzej Naglik on 14.09.2014.
//
//

#import "ANDBackgroundChartView.h"
#import "ANDLineChartView.h"

#define INTERVAL_TEXT_LEFT_MARGIN 10.0
#define INTERVAL_TEXT_MAX_WIDTH 100.0

@interface ANDBackgroundChartView()
@property (nonatomic, weak) ANDLineChartView *chartContainer;
@property (nonatomic,readwrite)UIView *rulerView;
@end

@implementation ANDBackgroundChartView

- (instancetype)initWithFrame:(CGRect)frame chartContainer:(ANDLineChartView*)chartContainer{
    self = [super initWithFrame:frame];
    if(self){
        [self setContentMode:UIViewContentModeRedraw];
        [self setChartContainer:chartContainer];
        self.backgroundColor = [UIColor redColor];
        
        _rulerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    NSAssert(NO, @"Use initWithFrame:chartContainer:");
    return [self initWithFrame:frame chartContainer:nil];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *boundsPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CGContextSetFillColorWithColor(context, [[self.chartContainer chartBackgroundColor] CGColor]);
    [boundsPath fill];
    
    CGFloat maxHeight = [self viewHeight]-BottomSpace;
    
    [[UIColor colorWithRed:0.329 green:0.322 blue:0.620 alpha:1.000] setStroke];
    UIBezierPath *gridLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake([self.chartContainer spacingForElementAtRow:0],CGRectGetHeight([self frame])-BottomSpace);
    
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetHeight([self frame])-BottomSpace);
    [gridLinePath moveToPoint:startPoint];
    [gridLinePath addLineToPoint:endPoint];
    
    
    UIBezierPath *gridLinePath1 = [UIBezierPath bezierPath];
    CGPoint startPoint1 = CGPointMake(CGRectGetMinX([self frame]),0);
    
    CGPoint endPoint1 = CGPointMake(CGRectGetMinX([self frame]),CGRectGetHeight([self frame])-BottomSpace);
    [gridLinePath1 moveToPoint:startPoint1];
    [gridLinePath1 addLineToPoint:endPoint1];
    CGContextSaveGState(context);
    
    NSUInteger numberOfIntervalLines =  [self.chartContainer numberOfIntervalLines];
    NSUInteger numberOfElements =  [self.chartContainer numberOfElements];
    CGFloat intervalSpacing = (maxHeight/(numberOfIntervalLines-1));
    
    CGFloat maxIntervalValue = [self.chartContainer maxValue];
    CGFloat minIntervalValue = [self.chartContainer minValue];
    CGFloat maxIntervalDiff = (maxIntervalValue - minIntervalValue)/(numberOfIntervalLines-1);
    for(NSUInteger i = 0;i<numberOfIntervalLines;i++){
        [[self.chartContainer gridIntervalLinesColor] setStroke];
        [gridLinePath stroke];
//        NSString *stringToDraw = [self.chartContainer descriptionForValue:minIntervalValue + i*maxIntervalDiff];
//        UIColor *stringColor = [self.chartContainer gridIntervalFontColor];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//        
//        [stringToDraw drawInRect:CGRectMake(INTERVAL_TEXT_LEFT_MARGIN,
//                                            (CGRectGetHeight([self frame]) - [[self.chartContainer gridIntervalFont] lineHeight]),
//                                            INTERVAL_TEXT_MAX_WIDTH, [[self.chartContainer gridIntervalFont] lineHeight])
//                  withAttributes:@{NSFontAttributeName: [self.chartContainer gridIntervalFont],
//                                   NSForegroundColorAttributeName: stringColor,
//                                   NSParagraphStyleAttributeName: paragraphStyle
//                                   }];
        
        CGContextTranslateCTM(context, 0.0, - intervalSpacing);
        
    }
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    for(NSUInteger i = 0;i<numberOfElements;i++){
        CGFloat intervalSpacing = [self.chartContainer spacingForElementAtRow:i];
        [[self.chartContainer gridIntervalLinesColor] setStroke];
        
        CGContextTranslateCTM(context, intervalSpacing, 0);
        [gridLinePath1 stroke];
        
        
        NSString *stringToDraw = [self.chartContainer descriptionForRow:i];
        UIColor *stringColor = [self.chartContainer gridIntervalFontColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        [stringToDraw drawInRect:CGRectMake(CGRectGetMinX([self frame]),
                                            CGRectGetHeight([self frame])-BottomSpace+10,
                                            INTERVAL_TEXT_MAX_WIDTH, [[self.chartContainer gridIntervalFont] lineHeight])
                  withAttributes:@{NSFontAttributeName: [self.chartContainer gridIntervalFont],
                                   NSForegroundColorAttributeName: stringColor,
                                   NSParagraphStyleAttributeName: paragraphStyle
                                   }];
        
        
    }
    CGContextRestoreGState(context);
}

- (CGFloat)viewHeight{
    UIFont *font = [self.chartContainer gridIntervalFont];
    CGFloat maxHeight = round(CGRectGetHeight([self frame]) - [font lineHeight]);
    return maxHeight;
}


@end
