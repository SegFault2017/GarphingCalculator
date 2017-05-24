//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Raymond Tan on 2017-05-07.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import <UIKit/UIKit.h>


//Protocol
@class GraphView;
@protocol GraphViewDelegate <NSObject>
-(double) yValueOfXForXvalue:(double) x inGraphView:(GraphView *) sender;
-(void)storeScale:(double) scale ForGraphView:(GraphView *) sender;
-(void) storeOriginX:(double) x andOriginY:(double) y ForGraphView:(GraphView*) sender;
@end


@interface GraphView : UIView

@property (nonatomic,weak)IBOutlet id <GraphViewDelegate> delegate;
@property (nonatomic) float scale;//we use scale for zoom in and zoom out
@property (nonatomic) CGPoint origin;//the origin of the graph
@property (nonatomic,weak) NSString *mode;
-(void) pinch:(UIPinchGestureRecognizer*) gesture;
-(void) moveGraph:(UIPanGestureRecognizer *) gesture;
-(void) rePosition:(UITapGestureRecognizer *) gesture;
-(void) setUp;
@end


