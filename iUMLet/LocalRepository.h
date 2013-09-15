//
//  LocalRepository.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/14/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository.h"

@interface LocalRepository : Repository

+ (LocalRepository *)createLocalRepository;

@end
