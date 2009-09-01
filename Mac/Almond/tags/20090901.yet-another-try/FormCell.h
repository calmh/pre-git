//
//  FormCell.h
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FormCell : NSTextFieldCell {
}

@end

@interface NSObject(MethodCellDelegate)

- (float) height;

@end