//
//  GraphingViewController.m
//  GraphingCalculator
//
//  Created by Raymond Tan on 2017-05-07.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import "CalculatorBrain.h"
#import "GraphingViewController.h"
#import "GraphView.h"

#define TRIPLE 3;

@interface GraphingViewController () <GraphViewDelegate>
@property (weak, nonatomic) IBOutlet GraphView *graphview;
@property (nonatomic,weak) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *graphMode;
@end


@implementation GraphingViewController
@synthesize graphview = _graphview;
@synthesize stack = _stack;
@synthesize toolBar = _toolBar;
@synthesize graphMode = _graphMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){}
    return  self;
}

-(void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}


-(BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title = @"Calculator";

    
    NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
    [toolBarItems insertObject:barButtonItem atIndex:0];
    self.toolBar.items = toolBarItems;
}

-(void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
    [toolBarItems removeObjectIdenticalTo:barButtonItem];
    self.toolBar.items = toolBarItems;
    
}


-(void) setStack:(id)stack{
    if(![_stack isEqualToArray:stack]){//efficiency if stack is not euqal to other's stack
        _stack = stack;
        [self.graphview setNeedsDisplay];
        //any time the program/stack is set, we must redraw the graph
        
        self.title = [@"f(x) = " stringByAppendingString:
                      [CalculatorBrain descriptionOfProgram:self.stack]];
        [self viewUpdate];
    }
}


-(void) setGraphview:(GraphView *)graphview{
    _graphview = graphview;
    
    //set mode
    self.graphview.mode = [NSString stringWithFormat:@"%@",self.graphMode.text];
    //set delegate !!!!!!!!!!!!!!
    self.graphview.delegate = self;
    [self.graphview addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphview action:@selector(pinch:)]];
    [self.graphview addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphview action:@selector(moveGraph:)]];
    
    UITapGestureRecognizer *tripleTap;
    
    tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphview action:@selector(rePosition:)];
    
    tripleTap.numberOfTapsRequired = TRIPLE;
    [self.graphview addGestureRecognizer:tripleTap];
    
    [self viewUpdate];
    
}

-(void) viewUpdate{
    if(!_stack) return;
    if(!_graphview) return;
    
    NSString *program = [CalculatorBrain descriptionOfProgram:self.stack];
    
    float scale = [[NSUserDefaults  standardUserDefaults] doubleForKey:[@"scale."stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]]];
    double xOrigin = [[NSUserDefaults standardUserDefaults] doubleForKey:[@"x."stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]]];
    double yOrigin = [[NSUserDefaults standardUserDefaults] doubleForKey:[@"y." stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]]];
    
    if(scale) self.graphview.scale = scale;
    
    
    if(xOrigin && yOrigin) {
        CGPoint theOrigin;
        theOrigin.x = xOrigin;
        theOrigin.y = yOrigin;
        self.graphview.origin = theOrigin;
    }
    
    [self.graphview setNeedsDisplay];
    
    
}


-(void) storeScale:(double)scale ForGraphView:(GraphView *)sender{
    [[NSUserDefaults standardUserDefaults] setDouble:scale forKey:[@"scale." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.stack]]];
    
    //save the scale
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) storeOriginX:(double)x andOriginY:(double)y ForGraphView:(GraphView *)sender{
    
    [[NSUserDefaults standardUserDefaults] setDouble:x forKey:[@"x." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.stack]]];
    [[NSUserDefaults standardUserDefaults] setDouble:y forKey:[@"y." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.stack]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(double) yValueOfXForXvalue:(double)x inGraphView:(GraphView *)sender{
    //find corresponding y value for x
    
    id yVal = [CalculatorBrain runProgram:self.stack usingVarVal:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"X"]];
    
    return [yVal doubleValue];
}


- (IBAction)switchPressed:(UISwitch *)sender {
     sender.on = !sender.on;
    if (sender.on) {
        self.graphMode.text = @"Line";
        self.graphview.mode = [NSString stringWithFormat:@"%@", self.graphMode.text];
        
    }
    else{
        self.graphMode.text = @"Dot";
        self.graphview.mode = [NSString stringWithFormat:@"%@",self.graphMode.text];
    }
    
   
       [self.graphview setNeedsDisplay];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
