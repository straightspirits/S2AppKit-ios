//
//  S2TableViewCellCollection.m
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/18.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2TableViewCellCollection.h"
#import "S2UIKit.h"



@implementation S2TableViewCell {
	BOOL _enabled;
}

- (void)awakeFromNib;
{
	[super awakeFromNib];

	if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
		self.layoutMargins = UIEdgeInsetsZero;
	}
}

- (NSString *)title
{
	return nil;
}

- (void)setTitle:(NSString*)title
{
}

- (NSString *)detail
{
	return nil;
}

- (void)setDetail:(NSString *)detail
{
}

- (UIImage *)image
{
	return nil;
}

- (void)setImage:(UIImage *)image
{
}

- (BOOL)enabled
{
	return _enabled;
}

- (void)setEnabled:(BOOL)enabled
{
	_enabled = enabled;
	
	// 全ての子ビューのenabledプロパティを設定する
	for (id view in self.contentView.subviews) {
		if ([view respondsToSelector:@selector(setEnabled:)]) {
			[view setEnabled:enabled];
		}
	}
}

/* override */
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset;
{
	[super setSeparatorInset:separatorInset];

	if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
		self.layoutMargins = separatorInset;
	}
}

- (void)addSubviewAtRight:(UIView*)view
{
	CGSize viewSize = view.size;

	// 右固定の子ビューをview.width分左にずらす
	for (UIView* contentSubview in self.contentView.subviews) {
		if (!(contentSubview.autoresizingMask & UIViewAutoresizingFlexibleRightMargin)) {
			contentSubview.x -= viewSize.width;
		}
	}

	CGSize cellSize = self.contentView.size;
	const int HORIZONTAL_MARGIN = 4;
	
	view.frame = CGRectMake(cellSize.width - HORIZONTAL_MARGIN - viewSize.width, (cellSize.height - viewSize.height) / 2, viewSize.width, viewSize.height);
	view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;	// 右固定、上下中心

	[self.contentView addSubview:view];
}

@end



@implementation S2TableViewStandardCell

+ (id)newCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	return [[self alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
}

+ (id)newBasicCell:(NSString*)reuseIdentifier
{
	return [self newCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

+ (id)newLeftDetailCell:(NSString*)reuseIdentifier
{
	return [self newCellWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

+ (id)newRightDetailCell:(NSString*)reuseIdentifier
{
	return [self newCellWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

+ (id)newSubtitleCell:(NSString*)reuseIdentifier
{
	return [self newCellWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

//---

+ (id)instantiateCell:(UITableView*)tableView style:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	id instance = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	return instance ? instance : [self newCellWithStyle:style reuseIdentifier:reuseIdentifier];
}

+ (id)instantiateBasicCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier
{
	return [self instantiateCell:tableView style:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

+ (id)instantiateLeftDetailCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier
{
	return [self instantiateCell:tableView style:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

+ (id)instantiateRightDetailCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier
{
	return [self instantiateCell:tableView style:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

+ (id)instantiateSubtitleCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier
{
	return [self instantiateCell:tableView style:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (NSString *)title
{
	return self.textLabel.text;
}

- (void)setTitle:(NSString*)title
{
	self.textLabel.text = title;
}

- (void)setTitle:(NSString*)title detail:(NSString*)detail
{
	self.textLabel.text = title;
	self.detailTextLabel.text = detail;
}

- (void)setTitle:(NSString*)title subtitle:(NSString*)subtitle
{
	self.textLabel.text = title;
	self.detailTextLabel.text = subtitle;
}

- (NSString *)detail
{
	return self.detailTextLabel.text;
}

- (void)setDetail:(NSString*)detail
{
	self.detailTextLabel.text = detail;
}

- (void)setSubtitle:(NSString*)subtitle
{
	self.detailTextLabel.text = subtitle;
}

@end



@implementation S2TableViewCustomCell

+ (id)newCell;
{
	return [self newCellWithNibName:NSStringFromClass(self) reuseIdentifier:self.reuseIdentifier];
}

+ (id)newCellWithNibName:(NSString*)nibName;
{
	return [self newCellWithNibName:nibName reuseIdentifier:self.reuseIdentifier];
}

+ (id)newCellWithNibName:(NSString*)nibName reuseIdentifier:(NSString*)reuseIdentifier;
{
	S2AssertNonNil(nibName);

	UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
	
	if (!nib) {
		S2AssertFailed(@"S2TableViewCell: nib not found '%@'", nibName);
		return nil;
	}
	
	NSArray* views = [nib instantiateWithOwner:nil options:nil];
	
	for (id view in views) {
		// selfと同じ型のビューを列挙する
		if (S2ObjectIsKindOf(view, UITableViewCell)) {
			UITableViewCell* cell = (UITableViewCell*)view;

			if (!reuseIdentifier || [cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
				S2Assert(S2ObjectIsKindOf(cell, self), @"cell '%@' is not class '%@'.", self.reuseIdentifier, NSStringFromClass(self.class));

				return view;
			}
		}
	}
	
	S2AssertFailed(@"reuseIdentifier='%@' is not found in nib='%@'.", reuseIdentifier, nibName);
	return nil;
}

+ (NSString*)reuseIdentifier;
{
	return nil;
}

+ (id)dequeueCell:(UITableView*)tableView;
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
	
	if (cell) {
		S2Assert(S2ObjectIsKindOf(cell, self), @"cell '%@' is not class '%@'.", self.reuseIdentifier, NSStringFromClass(self.class));
	}
	
	return cell;
}

+ (id)instantiateCell:(UITableView*)tableView;
{
	return [self instantiateCell:tableView reuseIdentifier:self.reuseIdentifier];
}

+ (id)instantiateCell:(NSString*)nibName tableView:(UITableView*)tableView;
{
	return [self instantiateCell:nibName tableView:tableView reuseIdentifier:self.reuseIdentifier];
}

+ (id)instantiateCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
{
	return [self instantiateCell:NSStringFromClass(self) tableView:tableView reuseIdentifier:reuseIdentifier];
}

+ (id)instantiateCell:(NSString*)nibName tableView:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
{
	id instance = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	return instance ? instance : [self newCellWithNibName:nibName reuseIdentifier:reuseIdentifier];
}

@end



@implementation S2TableViewTitleCell

+ (NSString *)reuseIdentifier;
{
	return @"__TitleCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	[self.titleLabel sizeToFit];
}

@end



@implementation S2TableViewTitleDetailCell

+ (NSString *)reuseIdentifier;
{
	return @"__TitleDetailCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (NSString *)detail
{
	return self.detailLabel.text;
}

- (void)setDetail:(NSString *)detail
{
	self.detailLabel.text = detail;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail
{
	self.titleLabel.text = title;
	self.detailLabel.text = detail;
}

const int MARGIN = 4;

- (void)layoutSubviews
{
	[super layoutSubviews];

	// 詳細ラベルのサイズを確定する
	[self.detailLabel sizeToFitKeepRight];

	// 残りの領域にタイトルラベルを設定する
	CGRect frameRect = self.titleLabel.frame;
	frameRect.size.width = self.detailLabel.frame.origin.x - MARGIN - frameRect.origin.x;
	self.titleLabel.frame = frameRect;
}

@end



@implementation S2TableViewImageCell

+ (NSString *)reuseIdentifier;
{
	return @"__ImageCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (UIImage *)image
{
	return self.imageRightView.image;
}

- (void)setImage:(UIImage *)image;
{
	self.imageRightView.image = image;
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
	self.titleLabel.text = title;
	self.imageRightView.image = image;
}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//	
//	// 詳細ラベルのサイズを確定する
//	[self.detailLabel sizeToFitKeepRight];
//	
//	// 残りの領域にタイトルラベルを設定する
//	CGRect frameRect = self.titleLabel.frame;
//	frameRect.size.width = self.detailLabel.frame.origin.x - MARGIN - frameRect.origin.x;
//	self.titleLabel.frame = frameRect;
//}

@end



@implementation S2TableViewRowAddCell

+ (NSString *)reuseIdentifier;
{
	return @"__RowAddCell";
}

@end



@implementation S2TableViewTextEditCell

+ (NSString *)reuseIdentifier;
{
	return @"__TextEditCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.valueTextField.delegate = self;
	self.selectAllAtBeginEdit = NO;
}

// MEMO: タイトルラベルの全ての文字を表示することを優先してレイアウトしている
const int titleLabelMinWidth = 160;

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.titleLabel.width = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width;
	
	CGRect frame = self.valueTextField.frame;
	{
		int right = frame.origin.x + frame.size.width;
		frame.origin.x = self.titleLabel.right + MARGIN;
		if (frame.origin.x < titleLabelMinWidth) {
			frame.origin.x = titleLabelMinWidth;
		}
		frame.size.width = right - frame.origin.x;
		frame.origin.y = MARGIN;
		frame.size.height = self.height - MARGIN * 2;
	}
	self.valueTextField.frame = frame;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (self.selectAllAtBeginEdit)
		[textField selectAll:self];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	textField.text = self.defaultValue;
	if (self.selectAllAtBeginEdit)
		[textField selectAll:self];
	return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (self.returnPressed) {
		self.returnPressed(textField);
	}
	else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (self.valueChanged) {
		self.valueChanged(textField);
	}
}

@end



@implementation S2TableViewSwitchEditCell

+ (NSString *)reuseIdentifier;
{
	return @"__SwitchEditCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (IBAction)valueChanged:(id)sender
{
	if (self.valueChanged) {
		self.valueChanged(sender);
	}
}

@end



@implementation S2TableViewSegmentedEditCell

+ (NSString *)reuseIdentifier;
{
	return @"__SegmentedEditCell";
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (void)setValueNames:(NSArray*)valueNames;
{
	[self.valueSegmentedControl removeAllSegments];
	for (int index = 0; index < valueNames.count; ++index) {
		NSString* valueName = valueNames[index];
		[self.valueSegmentedControl insertSegmentWithTitle:valueName atIndex:index animated:NO];
	}
	[self.valueSegmentedControl sizeToFitKeepRight];
}

- (IBAction)valueChanged:(id)sender
{
	if (self.valueChanged) {
		self.valueChanged(sender);
	}
}

@end



