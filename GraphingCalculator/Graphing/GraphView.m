//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Raymond Tan on 2017-05-07.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"
#define DEFAULT_SCALE 100
#define DEFAULT_MODE @"Line"
@interface GraphView ()
@end


@implementation GraphView
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize mode = _mode;

-(void) setUp{
    self.contentMode = UIViewContentModeRedraw;
}


-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    
    //[self setNeedsDisplay];//redraw
    return self;
}

-(void) awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}


-(float) scale{//get scale
    //if scale is not 0
    if(!_scale){
        return DEFAULT_SCALE;
    }
    else{
        return _scale;
    }
}

-(void) setScale:(float)scale{
    if(_scale != scale){
        _scale = scale;
    }
    
    [self.delegate storeScale:scale ForGraphView:self];
    
    [self setNeedsDisplay];//redraw is scale is changed
}

-(void) setOrigin:(CGPoint)origin{
    //effiency
    if(_origin.x != origin.x && _origin.y != origin.y){
        _origin = origin;
    }
    
    [self.delegate storeOriginX:self.origin.x andOriginY:self.origin.y
                   ForGraphView:self];
    
    [self setNeedsDisplay];//redraw
}

-(CGPoint) origin{
    //if the origin is 0, set it to the cnetre of the graph
    
    if(_origin.x == 0 && _origin.y == 0){
        _origin.x = (self.bounds.origin.x + self.bounds.size.width) /2;
        _origin.y = (self.bounds.origin.y + self.bounds.size.height) /2;
    }
    return _origin;
}


-(void) setMode:(NSString *)mode{
    if(_mode == nil){
        _mode = DEFAULT_MODE;;
    }
    else{
        _mode = [NSString stringWithFormat:@"%@",mode];
    }
}


/*
 // Only override drawRect: if you perform custom drawin
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
    CGFloat pixels = [self contentScaleFactor];
    
    double yVal;
    if([self.mode isEqualToString:@"Line"]){
        
        //Line Graph Mode
        yVal = [self.delegate yValueOfXForXvalue:-self.origin.x/self.scale inGraphView:self];
        CGContextMoveToPoint(context, 0, self.origin.y-yVal*self.scale);
        for (int x = 1; x < rect.size.width*pixels; x++) {
            
            yVal = [self.delegate yValueOfXForXvalue:(x/pixels-self.origin.x)/self.scale  inGraphView:self];
            CGContextAddLineToPoint(context, x/pixels, self.origin.y-yVal*self.scale);//convert view to the actual graph coordinate
        }
        [[UIColor blackColor] setStroke];
        CGContextDrawPath(context, kCGPathStroke);
        
    }
    else{
        
        //Dot Graph Mode
        [[UIColor blackColor] setFill];
        for (int x = 1; x < rect.size.width*pixels; x++) {
            yVal = [self.delegate yValueOfXForXvalue:(x/pixels-self.origin.x)/self.scale inGraphView:self];//convert view coordinate to the actual graph coordinate
            CGContextFillRect(context, CGRectMake((x-0.1)/pixels, self.origin.y-yVal*self.scale-0.1/pixels, 1.0/pixels, 1.0/pixels));
        }
    }
}

//Gestures


-(void) pinch:(UIPinchGestureRecognizer*) gesture{
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded){
        self.scale *= gesture.scale;
        gesture.scale = 1;
        
    }
}


-(void) moveGraph:(UIPanGestureRecognizer *) gesture{
    if(gesture.state == UIGestureRecognizerStateEnded ||
       gesture.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [gesture translationInView:self];
        CGPoint newPoint;
        newPoint.x = self.origin.x + translation.x;
        newPoint.y = self.origin.y + translation.y;
        
        self.origin = newPoint;
        [gesture setTranslation:CGPointZero inView:self];
    }
}


-(void) rePosition:(UITapGestureRecognizer *) gesture{
    if(gesture.state == UIGestureRecognizerStateEnded){
        self.origin = [gesture locationOfTouch:0 inView:self];
    }
}


@end
