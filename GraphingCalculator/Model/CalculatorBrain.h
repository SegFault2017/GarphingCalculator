//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Raymond Tan on 2017-05-01.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#ifndef CalculatorBrain_h
#define CalculatorBrain_h

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double) operand;
-(void)pushVar:(NSString*) Var;
-(void)popOperand;
-(id) performOperation:(NSString *)operation;
-(void) clear;

@property (nonatomic,readonly) id program;

+(NSString *)descriptionOfProgram:(id) program;
+(NSString *) descriptionOfTopStack:(NSMutableArray *) stack;
+(id) runProgram:(id)program;
+(id) popOperandOffProgramStack:(NSMutableArray *) stack;
+(NSArray*) TwoOperation;
+(NSArray*) noOperation;
+(NSArray *) oneOperation;
+(NSString *) simplify:(NSString *) str;
+(id) runProgram:(id) program usingVarVal: (NSDictionary *) varDict;
+(NSSet*) variableUsedInProgram: (id) program;
+(NSArray*) varSet;

@end

#endif /* CalculatorBrain_h */
