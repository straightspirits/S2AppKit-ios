//
//  S2CollapsibleTableView.h
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/12.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIKit.h"



@interface S2CollapsibleTableView : S2TableView

+ (id)new;

- (BOOL)sectionIsExpanding:(int)section;

- (void)expandSection:(int)section animated:(BOOL)animated;

- (void)shrinkSection:(int)section animated:(BOOL)animated;

@end



@protocol S2CollapsibleTableViewDelegate <UITableViewDelegate>

- (void)tableView:(S2CollapsibleTableView*)tableView didSelectSectionHeaderAtSection:(int)section;

@end

