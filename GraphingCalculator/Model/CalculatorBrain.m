//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Raymond Tan on 2017-05-01.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

//start public API

@interface CalculatorBrain ()
@property (strong,nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;



-(NSMutableArray *) programStack{
    if(!(_programStack)) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}



-(void) pushOperand:(double)operand{
    //since double is not an object
    //we would use NSNumber to wrap primative type into an object
    NSNumber *operandObject = [NSNumber numberWithDouble: operand];
    [self.programStack addObject:operandObject];
    
}

-(void) popOperand{
    if([_programStack count] >0) [self.programStack removeLastObject];
}

-(void) pushVar:(NSString *)Var{
    [self.programStack addObject:Var];
}

-(id) program{
    return [self.programStack copy];
    //make a copy to the client, so they wouldn't change the internal state of prgramstack
    //immutable
}


-(id) performOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
    
    //calculate the program
    return [CalculatorBrain  runProgram:self.program];
}


-(void) clear{
    if([self.programStack count] > 0) [self.programStack removeAllObjects];
    
    
}


+(id) popOperandOffProgramStack:(NSMutableArray *) stack{
    
    id result =0;
    id first;
    id second;
    
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){ //if the top is an NSNumber
        //result = [topOfStack doubleValue];
        result = [NSNumber numberWithDouble:[topOfStack doubleValue]];
        
    }
    else if([topOfStack isKindOfClass: [NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            first  = [self popOperandOffProgramStack:stack];
            second = [self popOperandOffProgramStack:stack];
            result = [NSNumber numberWithDouble:[first doubleValue] +
                      [second doubleValue]];
            
        }
        else if([operation isEqualToString:@"-"]){
            first = [self popOperandOffProgramStack:stack];
            second = [self popOperandOffProgramStack:stack];
            
           result = [NSNumber numberWithDouble: [second doubleValue] -
                     [first doubleValue]];
        }
        else if([operation isEqualToString:@"*"]){
            first  = [self popOperandOffProgramStack:stack];
            second = [self popOperandOffProgramStack:stack];
            
            result = [NSNumber numberWithDouble:[second doubleValue] *
                      [first doubleValue]];
        }
        else if([operation isEqualToString:@"π"]){
            result = [NSNumber numberWithDouble:M_PI];
        }
        else if([operation isEqualToString:@"Sin"]){
            first = [self popOperandOffProgramStack:stack];
            result = [NSNumber numberWithDouble: sin([first doubleValue])];
        }
        else if([operation isEqualToString:@"Cos"]){
            first = [self popOperandOffProgramStack:stack];
            result = [NSNumber numberWithDouble:cos([first doubleValue])];
            
        }
        else if([operation isEqualToString:@"√"]){

            first = [self popOperandOffProgramStack:stack];
            if([first doubleValue] > 0){
                result = [NSNumber numberWithDouble:[first doubleValue]];
            }
            else{
               result = @"Math Error:sqrt of neg num.";
               // result = 0;
            }
        }
        else if([operation isEqualToString:@"NEG"]){
            first = [self popOperandOffProgramStack:stack];
            result = [NSNumber numberWithDouble:-[first doubleValue]];
        }
        else{
            first = [self popOperandOffProgramStack:stack];
            if([first doubleValue] == 0) {
                result = @"Math Error:Zero division.";
               // result =  0;

            }
            else{
                second = [self popOperandOffProgramStack:stack];
                result = [NSNumber numberWithDouble:[second doubleValue] /
                          [first doubleValue]];
            }
            
        }
        
    }
    
    
    return result;
    
}


+(NSString *) simplify:(NSString *)str{
    
    NSString *simplfied= str;
    
    if ([str hasPrefix:@"("] && [str hasSuffix:@")"]) {
        simplfied = [simplfied substringFromIndex:1];
        simplfied= [simplfied substringToIndex:[simplfied length] - 1];
    }
    
    NSRange before = [simplfied rangeOfString:@"("];
    
    NSRange after = [simplfied rangeOfString:@")"];
    
    if (before.location <= after.location) {
        return simplfied;
    }
    else {
        return str;
    }
    
}


+(NSString *) descriptionOfTopStack:(NSMutableArray *)stack{
    NSString *result;
    id topOfStack = [stack lastObject];
    if(topOfStack) {
        [stack removeLastObject];
    }
    else{
        return @"";
    }
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [NSString stringWithFormat:@"%g",[topOfStack doubleValue]];
        return result;
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        //it's a variable
        NSString *operation = topOfStack;
        if([[CalculatorBrain noOperation] containsObject:operation] ||
           !([[CalculatorBrain TwoOperation] containsObject:operation]
             &&[[CalculatorBrain oneOperation] containsObject:operation])){
               result = operation;
           }
        
        if([[CalculatorBrain TwoOperation] containsObject: operation]){
            NSString *first = [CalculatorBrain descriptionOfTopStack:stack];
            NSString *second = [CalculatorBrain descriptionOfTopStack:stack];
            
            result =[[second stringByAppendingString: operation]
                     stringByAppendingString: first];
            
            if([operation isEqualToString:@"+"] || [operation isEqualToString:@"-"])
                result = [NSString stringWithFormat:@"(%@)",result];
        }
        else if ([[CalculatorBrain oneOperation] containsObject:operation]){
            result = [CalculatorBrain simplify:
                      [CalculatorBrain descriptionOfTopStack:stack]];
            result = [NSString stringWithFormat:@"%@(%@) ",operation,result];
            
        }
        
        
    }
    
    
    return  result;
    
}

//+(NSSet*)

+(NSString *) descriptionOfProgram:(id)program{
    
    NSMutableArray *stack;
    NSMutableArray *allExp = [NSMutableArray array];
    NSString *description = @"";
    
    
    if([program isKindOfClass:[NSArray class]] && [program count] > 0){
        stack = [program mutableCopy];
    }
    else{
        return @"0";
    }
    
    
    while([stack count] > 0){
        [allExp addObject:
         [CalculatorBrain simplify:[CalculatorBrain descriptionOfTopStack:stack]]];
    }
    
    for(int i = 0;i< [allExp count] -1; i++){
        description = [NSString stringWithFormat:@"%@%@,",description,allExp[i]];
    }
    
    description = [description stringByAppendingString: allExp[[allExp count] -1]];
    
    return  description;
    
}




+(id) runProgram:(id)program{
    //when program is passed to us, program is immutable
    NSMutableArray *stack;
    //create a mutablearry to change the prgram
    
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy]; //returns a mutable copy to stack
    }
    
    return [self popOperandOffProgramStack:stack];
    
}

+(id) runProgram:(id)program usingVarVal:(NSDictionary *)varDict{
    
    NSMutableArray *stack = ([program count] > 0) ? [program mutableCopy] : nil;
    NSArray *keys = [varDict allKeys];
    
    for(int i =0 ;i < [stack count];i++){
        if([keys containsObject:stack[i]]){
            [stack replaceObjectAtIndex:i withObject:varDict[stack[i]]];
        }
    }
    
    return [CalculatorBrain runProgram:stack];
}


+(NSArray *) oneOperation{
    return @[@"Sin",@"Cos",@"√",@"NEG"];
}

+(NSArray *) TwoOperation{
    return @[@"+",@"-",@"*",@"÷"];
}

+(NSArray *) noOperation{
    return @[@"π"];
}


+(NSArray *) varSet{
    return  @[@"X",@"Y",@"Z"];
}


+(NSSet *) variableUsedInProgram:(id)program{
    NSMutableSet *theSet = [[NSMutableSet alloc] init];
    
    if([program isKindOfClass:[NSArray class]]){
        for (id element in program) {
            if([[CalculatorBrain varSet] containsObject:element]){
                [theSet addObject:element];
            }
        }
    }
    
    
    theSet = [theSet copy];
    return theSet;
}



@end
