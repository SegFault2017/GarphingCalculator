//
//  ViewController.m
//  Calculator
//
//  Created by Raymond Tan on 2017-04-30.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphingViewController.h"


@interface CalculatorViewController ()//private
@property (nonatomic) BOOL enteringDigit;
//nonatomic means seeter and getter method will not be thread safe

@property (nonatomic) BOOL isZero;
@property (strong,nonatomic) CalculatorBrain *brain;//add a pointer to point to our model
@property (nonatomic) BOOL isVar;
@property (strong,nonatomic) NSDictionary *tests;


@end

@implementation CalculatorViewController

@synthesize display =_display;
@synthesize enteringDigit = _enteringDigit;
@synthesize brain = _brain;
@synthesize description = _description;
@synthesize isVar = _isVar;
@synthesize tests =_tests;


-(CalculatorBrain*) brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//outlet refers to a @property through which
//we send messages to something in our view from our controller

//action mean a method that is going to be sent from an object in our view


-(NSDictionary *) tests{
    if(!_tests)  _tests = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithFloat:1.0], @"X",
                           [NSNumber numberWithFloat:2.0], @"Y",
                           [NSNumber numberWithFloat:3.0], @"Z", nil];
    
    return _tests;
}


- (IBAction)digitpressed:(UIButton *)sender {
    
    //every time button is touched  digitpressed is going to be sent to the controllerwith the UIButton
    
    //Static typing
    
    NSString *digit = [sender currentTitle];
    //UIButton respond to the message currentTitle to figure which button is touched
    //NSLog(@"user touched %@",digit);
    
    
    //UILabel *myDispaly = [self display];
    //get a pointer points to display
    if(_enteringDigit){
        if(_isZero && [digit compare:@"0"] == NSOrderedSame){
            _display.text = digit;
        }
        else{
            if(_isZero) _display.text = @"";
            _display.text =[[[self display] text] stringByAppendingString: digit];
            _isZero =false;
        }
    }
    else{
        if([digit compare:@"0"] == NSOrderedSame) self.isZero =YES;
        _display.text = digit;
        _enteringDigit = YES;
    }
    
    self.isVar = NO;
}
- (IBAction)enterPressed {
    if(!_isVar)[self.brain pushOperand:[self.display.text doubleValue]];
    //NSString respond to double as well
    //using model's method
    self.enteringDigit = NO;
    //self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}


- (IBAction)operationPressed:(UIButton *)sender {
    if(self.enteringDigit){
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    if([operation isEqualToString:@"-/+"]) operation =@"NEG";
    id result =[self.brain performOperation: operation];
    self.display.text = [NSString stringWithFormat:@"%@",result];
    if(result== 0) self.display.text =@"0";
    self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
}


- (IBAction)dotPressed:(UIButton *)sender {
    if(_enteringDigit){
        NSRange dot = [self.display.text rangeOfString:@"."];
        if(dot.location == NSNotFound)//if there is not dot
            self.display.text = [self.display.text stringByAppendingString:
                                @"."];
    }
    else{//case "0"
        self.display.text = [self.display.text stringByAppendingString:
                             @"."];
    }
    self.enteringDigit = YES;
    
}

- (IBAction)clearButton {
    self.display.text = @"0";
    _enteringDigit = NO;
    self.description.text = @"";
    [self.brain clear];
    self.isVar = NO;
}

- (IBAction)varPressed:(UIButton *)sender {
    self.isVar = YES;
    [self.brain pushVar:[sender currentTitle]];
    
}


-(void)updateUI{
    if([self.brain.program count] == 0) {
        self.display.text= @"0";
        self.description.text = @"";
        return;
    }
    id val = [CalculatorBrain runProgram:self.brain.program usingVarVal:self.tests];
    self.display.text = [NSString stringWithFormat:@"%@",val];
    if(val == 0) self.display.text =@"0";
    self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)undoPressed {
    if(self.enteringDigit){
        if([self.display.text length] >0){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
            
        }else{
            self.enteringDigit =NO;
            [self updateUI];
        }
        
    }
    else{
        [self.brain popOperand];
        [self updateUI];
    }
   
}


-(GraphingViewController *) splitViewGraphController{
    id gvc = [self.splitViewController.viewControllers lastObject];
    
    if(![gvc isKindOfClass:[GraphingViewController class]]){
        gvc = nil;
    }
    
    return gvc;
}



- (IBAction)functionPressed {
    
    //split view
    if([self splitViewGraphController]){
        [[self splitViewGraphController] setStack:self.brain.program];
    }
    else{
        //segue
          [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setStack:self.brain.program];
}




@end
