//
//  HDVlineChartView.m
//  Pods
//
//  Created by hudi on 15/4/28.
//
//

#import "HDVlineChartView.h"
#import "ANDLineChartView.h"

#define INTERVAL_TEXT_LEFT_MARGIN 10.0
#define INTERVAL_TEXT_MAX_WIDTH 100.0

@interface HDVlineChartView()
@property (nonatomic, weak) ANDLineChartView *chartContainer;
@end

@implementation HDVlineChartView

- (instancetype)initWithFrame:(CGRect)frame chartContainer:(ANDLineChartView*)chartContainer{
    self = [super initWithFrame:frame];
    if(self){
        [self setContentMode:UIViewContentModeRedraw];
        [self setChartContainer:chartContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    NSAssert(NO, @"Use initWithFrame:chartContainer:");
    return [self initWithFrame:frame chartContainer:nil];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *boundsPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    [boundsPath fill];
    
    CGFloat maxHeight = [self viewHeight]-BottomSpace;
    
    NSUInteger numberOfIntervalLines =  [self.chartContainer numberOfIntervalLines];
    CGFloat intervalSpacing = (maxHeight/(numberOfIntervalLines-1));
    
    CGFloat maxIntervalValue = [self.chartContainer maxValue];
    CGFloat minIntervalValue = [self.chartContainer minValue];
    CGFloat maxIntervalDiff = (maxIntervalValue - minIntervalValue)/(numberOfIntervalLines-1);
    for(NSUInteger i = 0;i<numberOfIntervalLines;i++){
        NSString *stringToDraw = [self.chartContainer descriptionForValue:minIntervalValue + i*maxIntervalDiff];
        UIColor *stringColor = [self.chartContainer gridIntervalFontColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        [stringToDraw drawInRect:CGRectMake(INTERVAL_TEXT_LEFT_MARGIN,
                                            (CGRectGetHeight([self frame])-BottomSpace - [[self.chartContainer gridIntervalFont] lineHeight]),
                                            INTERVAL_TEXT_MAX_WIDTH, [[self.chartContainer gridIntervalFont] lineHeight])
                  withAttributes:@{NSFontAttributeName: [self.chartContainer gridIntervalFont],
                                   NSForegroundColorAttributeName: stringColor,
                                   NSParagraphStyleAttributeName: paragraphStyle
                                   }];
        
        CGContextTranslateCTM(context, 0.0, - intervalSpacing);
        
    }
    
}

- (CGFloat)viewHeight{
    UIFont *font = [self.chartContainer gridIntervalFont];
    CGFloat maxHeight = round(CGRectGetHeight([self frame]) - [font lineHeight]);
    return maxHeight;
}

@end
