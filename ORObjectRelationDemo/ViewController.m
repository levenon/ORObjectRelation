//
//  ViewController.m
//  ORObjectRelationDemo
//
//  Created by xulinfeng on 2017/1/17.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "ViewController.h"
#import "ORBadgeValueManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIBarButtonItem *rootBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *homeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *messagesBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *randomBarButtonItem;

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    
    self.navigationItem.leftBarButtonItems = @[[self rootBarButtonItem], [self homeBarButtonItem], [self messagesBarButtonItem]];
    self.navigationItem.rightBarButtonItem = [self randomBarButtonItem];
    
    self.tableView.rowHeight = 44;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    ORBadgeValueManager *manager = [ORBadgeValueManager sharedManager];
    NSError *error = nil;
    [self registerObserveRelation:[manager rootObjectRelation] countPicker:^(id relation, NSUInteger count) {
        self.rootBarButtonItem.title = @(count).stringValue;
    } error:&error];
    
    [self registerObserveRelation:[manager messageObjectRelation] countPicker:^(id relation, NSUInteger count) {
        self.messagesBarButtonItem.title = @(count).stringValue;
    } error:&error];
    
    [self registerObserveRelation:[manager homeObjectRelation] countPicker:^(id relation, NSUInteger count) {
        self.homeBarButtonItem.title = @(count).stringValue;
    } error:&error];
}

- (UIBarButtonItem *)rootBarButtonItem{
    if (!_rootBarButtonItem) {
        _rootBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRoot:)];
    }
    return _rootBarButtonItem;
}

- (UIBarButtonItem *)homeBarButtonItem{
    if (!_homeBarButtonItem) {
        _homeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickHome:)];
    }
    return _homeBarButtonItem;
}

- (UIBarButtonItem *)messagesBarButtonItem{
    if (!_messagesBarButtonItem) {
        _messagesBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickMessages:)];
    }
    return _messagesBarButtonItem;
}

- (UIBarButtonItem *)randomBarButtonItem{
    if (!_randomBarButtonItem) {
        _randomBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"random" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRandom:)];
    }
    return _randomBarButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    } else {
        [cell clearAllRegisteredRelations];
    }
    NSString *key = @(indexPath.row).stringValue;
    
    cell.textLabel.text = key;
    
    ORCountObjectRelation *relation = [[ORBadgeValueManager sharedManager] normalMessageObjectRelationWithChatID:key];
    NSError *error = nil;
    [cell registerObserveRelation:relation countPicker:^(id relation, NSUInteger count) {
        cell.detailTextLabel.text = @(count).stringValue;
    } error:&error];
    
    return cell;
}

#pragma mark - actions

- (IBAction)didClickRoot:(id)sender{
    
    ORBadgeValueManager *manager = [ORBadgeValueManager sharedManager];
    
    [[manager rootObjectRelation] clean];
}

- (IBAction)didClickHome:(id)sender{
    
    ORBadgeValueManager *manager = [ORBadgeValueManager sharedManager];
    
    [[manager homeObjectRelation] clean];
}

- (IBAction)didClickMessages:(id)sender{
    
    ORBadgeValueManager *manager = [ORBadgeValueManager sharedManager];
    
    [[manager messageObjectRelation] clean];
}

- (IBAction)didClickRandom:(id)sender{
    
    ORBadgeValueManager *manager = [ORBadgeValueManager sharedManager];
    
    NSString *key = @(arc4random() % 10).stringValue;
    
    ORCountObjectRelation *relation = [manager normalMessageObjectRelationWithChatID:key];
    
    relation.count++;
    
    ORCountObjectRelation *homeRelation = [manager homeObjectRelation];
    
    homeRelation.count += (arc4random() % 10);
}

@end
