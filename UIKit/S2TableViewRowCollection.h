//
//  S2TableViewRowCollection.h
//  S2AppKit/S2
//
//  Created by ふみお on 2012/08/07.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableView.h"
#import "S2TableViewCellCollection.h"



@interface S2TableViewStaticRow : S2TableViewRow

@property S2TableViewStandardCell* usualCell;

- (id)initWithObject:(id)object value:(NSString*)value;

@end



/*
 *	タップして選択可能なRow
 */
@interface S2TableViewSelectableRow : S2TableViewRow

@property S2TableViewStandardCell* usualCell;

- (id)initWithObject:(id)object selected:(void(^)(NSIndexPath* indexPath))selected;

@end



/*
 *	コマンドボタンRow
 */
@interface S2TableViewButtonRow : S2TableViewRow

- (id)initWithObject:(id)object selected:(void(^)(NSIndexPath* indexPath))selected;

@end



@interface S2TableViewImageRow : S2TableViewRow

- (id)initWithObject:(id)object image:(UIImage*)image selected:(void(^)(NSIndexPath* indexPath))selected;

@property UIImage* image;

@end



typedef NSString* (^S2TableViewStringGetter)();
typedef void (^S2TableViewStringSetter)(NSString* value);

@interface S2TableViewStringValueRow : S2TableViewRow

@property S2TableViewStandardCell* usualCell;
@property S2TableViewTextEditCell* editingCell;
@property (weak, readonly) UITextField* textField;

- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter setter:(S2TableViewStringSetter)setter;
- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter setter:(S2TableViewStringSetter)setter defaultValue:(NSString*)defaultValue;

@end



typedef BOOL (^S2TableViewBooleanGetter)();
typedef void (^S2TableViewBooleanSetter)(BOOL value);

@interface S2TableViewBooleanValueRow : S2TableViewRow

@property S2TableViewCell* usualCell;
@property S2TableViewSwitchEditCell* editingCell;
@property (weak, readonly) UISwitch* switchControl;

- (id)initWithObject:(id)object getter:(S2TableViewBooleanGetter)getter setter:(S2TableViewBooleanSetter)setter;
- (id)initWithObject:(id)object getter:(S2TableViewBooleanGetter)getter setter:(S2TableViewBooleanSetter)setter onString:(NSString*)onString offString:(NSString*)offString;

@end



typedef int (^S2TableViewMultiValuesGetter)();
typedef void (^S2TableViewMultiValuesSetter)(NSInteger value);

@interface S2TableViewMultiValuesRow : S2TableViewRow

@property S2TableViewStandardCell* usualCell;
@property S2TableViewSegmentedEditCell* editingCell;
@property (weak, readonly) UISegmentedControl* segmentedControl;

- (id)initWithObject:(id)object valueNames:(NSArray*)valueNames getter:(S2TableViewMultiValuesGetter)getter setter:(S2TableViewMultiValuesSetter)setter;

@end



@interface S2TableViewMultiValueListRow : S2TableViewRow

@property S2TableViewStandardCell* usualCell;
@property S2TableViewStandardCell* editingCell;

- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter selected:(void(^)(NSIndexPath*))selected;

@end
