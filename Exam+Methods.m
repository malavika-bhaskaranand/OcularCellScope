//
//  Exam+Methods.m
//  OcularCellscope
//
//  Created by PJ Loury on 5/2/14.
//  Copyright (c) 2014 UC Berkeley Ocular CellScope. All rights reserved.
//


#import "Exam+Methods.h"

@implementation Exam (Methods)


- (void)addEyeImagesObject:(EyeImage *)image {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.eyeImages];
    [tempSet addObject:image];
    self.eyeImages = tempSet;
}

-(EyeImage*)getFirstImage{
    return [self.eyeImages firstObject];
}

@end
