//
//  S2TableViewRowCollection.m
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2012/08/07.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableViewRowCollection.h"



@implementation S2TableViewStaticRow {
}

- (id)initWithObject:(id)object value:(NSString*)value;
{
	if (self = [self initWithObject:object]) {
		self.usualCell = [S2TableViewStandardCell newRightDetailCell:@"__No"];
		self.usualCell.textLabel.text = self.title;
		self.usualCell.detailTextLabel.text = value;
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState;
{
	return self.usualCell;
}

@end



typedef void(^S2TableViewCellSelected)(NSIndexPath* indexPath);

@implementation S2TableViewSelectableRow {
	S2TableViewCellSelected _selected;
}

- (id)initWithObject:(id)object selected:(void(^)(NSIndexPath*))selected
{
	if (self = [self initWithObject:object]) {
		_selected = selected;
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState;
{
	S2TableViewStandardCell* cell = [S2TableViewStandardCell newRightDetailCell:@"__SelectableCell"];
	cell.textLabel.text = self.title;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)didSelected:(S2TableViewCellState)cellState;
{
	if (_selected) {
		_selected(self.indexPath);
	}
}

@end



@implementation S2TableViewButtonRow {
	S2TableViewCellSelected _selected;
}

- (id)initWithObject:(id)object selected:(void(^)(NSIndexPath*))selected;
{
	if (self = [self initWithObject:object]) {
		_selected = selected;
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState;
{
	S2TableViewStandardCell* cell = [S2TableViewStandardCell newBasicCell:@"__ButtonCell"];
	cell.textLabel.text = self.title;
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	return cell;
}

- (void)didSelected:(S2TableViewCellState)cellState;
{
	if (_selected) {
		_selected(self.indexPath);
	}
}

@end



@implementation S2TableViewImageRow {
	S2TableViewCellSelected _selected;
	UIImage* _image;
}

- (id)initWithObject:(id)object image:(UIImage*)image selected:(void(^)(NSIndexPath* indexPath))selected;
{
	if (self = [self initWithObject:object]) {
		_selected = selected;
		_image = image;
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState;
{
	S2TableViewImageCell* cell = [S2TableViewImageCell newCell];
	cell.titleLabel.text = self.title;
	cell.imageRightView.image = _image;
	if (cellState == S2TableViewCellStateView) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

- (void)didSelected:(S2TableViewCellState)cellState;
{
	if (cellState != S2TableViewCellStateEditing)
		return;

	if (_selected) {
		_selected(self.indexPath);
	}
}

@end



@implementation S2TableViewStringValueRow {
	NSString* _title;
	S2TableViewStringGetter _getter;
	S2TableViewStringSetter _setter;
	NSString* _defaultValue;
}

- (UITextField*)textField
{
	return self.editingCell.valueTextField;
}

- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter setter:(S2TableViewStringSetter)setter
{
	return [self initWithObject:object getter:getter setter:setter defaultValue:@""];
}

- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter setter:(S2TableViewStringSetter)setter defaultValue:(NSString*)defaultValue;
{
	if (self = [self initWithObject:object]) {
		_getter = getter;
		_setter = setter;
		_defaultValue = defaultValue;

		self.usualCell = [S2TableViewStandardCell newRightDetailCell:@"__String"];
		self.usualCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.usualCell.textLabel.text = self.title;
		self.editingCell = [S2TableViewTextEditCell instantiateCell:nil];
		self.editingCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.editingCell.titleLabel.text = self.title;
		__weak S2TableViewStringValueRow* _self = self;
		self.editingCell.valueChanged = ^(UITextField* sender) {
			setter(sender.text);
			sender.text = [_self callGetter];
		};
	}
	return self;
}

- (NSString*)callGetter;
{
	return _getter();
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState
{
	switch (cellState) {
		case S2TableViewCellStateView:
			self.usualCell.detailTextLabel.text = _getter();
			return self.usualCell;
			
		case S2TableViewCellStateEditing:
			self.editingCell.valueTextField.text = _getter();
//			[self.editingCell sizeToFit];
			return self.editingCell;
			
		default:
			return nil;
	}
}

@end



@implementation S2TableViewBooleanValueRow {
	S2TableViewBooleanGetter _getter;
	S2TableViewBooleanSetter _setter;
	NSString* _onString;
	NSString* _offString;
}

- (UISwitch*)switchControl
{
	return self.editingCell.valueSwitch;
}

- (id)initWithObject:(id)object getter:(S2TableViewBooleanGetter)getter setter:(S2TableViewBooleanSetter)setter
{
	return [self initWithObject:object getter:getter setter:setter onString:@"ON" offString:@"OFF"];
}

- (id)initWithObject:(id)object getter:(S2TableViewBooleanGetter)getter setter:(S2TableViewBooleanSetter)setter onString:(NSString*)onString offString:(NSString*)offString;
{
	S2TableViewStandardCell* usualCell = [S2TableViewStandardCell newRightDetailCell:@"__Boolean"];
	
	if (self = [self initWithObject:object]) {
		_getter = getter;
		_setter = setter;
		_onString = onString;
		_offString = offString;
		
		self.usualCell = usualCell;
		self.usualCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.usualCell.textLabel.text = self.title;
		self.editingCell = [S2TableViewSwitchEditCell instantiateCell:nil];
		self.editingCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.editingCell.titleLabel.text = usualCell.title;
		self.editingCell.valueChanged = ^(UISwitch* sender) {
			setter(sender.on);
		};
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState
{
	switch (cellState) {
		case S2TableViewCellStateView:
			self.usualCell.detail = _getter() ? _onString : _offString;
			return self.usualCell;
			
		case S2TableViewCellStateEditing:
			self.editingCell.valueSwitch.on = _getter();
			return self.editingCell;
			
		default:
			return nil;
	}
}

@end



@implementation S2TableViewMultiValuesRow {
	NSArray* _valueNames;
	S2TableViewMultiValuesGetter _getter;
	S2TableViewMultiValuesSetter _setter;
}

- (id)initWithObject:(id)object valueNames:(NSArray*)valueNames getter:(S2TableViewMultiValuesGetter)getter setter:(S2TableViewMultiValuesSetter)setter
{
	if (self = [self initWithObject:object]) {
		_valueNames = valueNames;
		_getter = getter;
		_setter = setter;
		
		self.usualCell = [S2TableViewStandardCell newRightDetailCell:@"__RightDetailCell"];
		self.usualCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.usualCell.textLabel.text = self.title;
		self.editingCell = [S2TableViewSegmentedEditCell instantiateCell:nil];
		self.editingCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.editingCell.titleLabel.text = self.title;
		[self.editingCell.valueSegmentedControl removeAllSegments];
		for (int index = 0; index < valueNames.count; ++index) {
			[self.editingCell.valueSegmentedControl insertSegmentWithTitle:[valueNames objectAtIndex:index] atIndex:index animated:NO];
		}
		[self.editingCell.valueSegmentedControl sizeToFitKeepRight];
		self.editingCell.valueChanged = ^(UISegmentedControl* sender) {
			setter(sender.selectedSegmentIndex);
		};
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState
{
	switch (cellState) {
		case S2TableViewCellStateView:
			self.usualCell.detailTextLabel.text = _valueNames[_getter()];
			return self.usualCell;
			
		case S2TableViewCellStateEditing:
			self.editingCell.valueSegmentedControl.selectedSegmentIndex = _getter();
			return self.editingCell;
			
		default:
			return nil;
	}
}

@end



@implementation S2TableViewMultiValueListRow {
	S2TableViewStringGetter _getter;
	S2TableViewCellSelected _selected;
}

- (id)initWithObject:(id)object getter:(S2TableViewStringGetter)getter selected:(void (^)(NSIndexPath*))selected
{
	if (self = [self initWithObject:object]) {
		_getter = getter;
		_selected = selected;
		
		self.usualCell = [S2TableViewStandardCell newRightDetailCell:@"__MultiValueListViewCell"];
		self.usualCell.selectionStyle = UITableViewCellSelectionStyleNone;
		self.usualCell.title = self.title;
		
		self.editingCell = [S2TableViewStandardCell newRightDetailCell:@"__MultiValueList"];
		self.editingCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.editingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.editingCell.title = self.title;
	}
	return self;
}

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState
{
	switch (cellState) {
		case S2TableViewCellStateView:
			self.usualCell.detail = _getter();
			return self.usualCell;
			
		case S2TableViewCellStateEditing:
			self.editingCell.detail = _getter();
			return self.editingCell;
			
		default:
			return nil;
	}
}

- (void)didSelected:(S2TableViewCellState)cellState
{
	if (cellState != S2TableViewCellStateEditing) {
		return;
	}

	if (_selected) {
		_selected(self.indexPath);
	}
}

@end
