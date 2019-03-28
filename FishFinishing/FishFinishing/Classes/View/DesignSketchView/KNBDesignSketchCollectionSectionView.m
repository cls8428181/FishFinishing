//
//  KNBDesignSketchCollectionSectionView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/28.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchCollectionSectionView.h"
#import "XDSDropDownMenu.h"

@interface KNBDesignSketchCollectionSectionView ()<XDSDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (nonatomic, strong)  NSArray *buttonArray;
@property (nonatomic, strong)  NSArray *dropDownMenuArray;
@end

@implementation KNBDesignSketchCollectionSectionView{
    XDSDropDownMenu *styleDropDownMenu;
    XDSDropDownMenu *typeDropDownMenu;
    XDSDropDownMenu *areaDropDownMenu;
}
- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setArrays]; //配置buttonArray和dropDownMenuArray
//    [self setButtons];//设置按钮边框和圆角
}
#pragma mark - 配置buttonArray和dropDownMenuArray
- (void)setArrays{
    
    //将所有按钮加入buttonArray数组
    self.buttonArray = @[self.styleButton,self.typeButton,self.areaButton];
    
    //初始化所有DropDownMenu下拉菜单
    styleDropDownMenu = [[XDSDropDownMenu alloc] init];
    typeDropDownMenu = [[XDSDropDownMenu alloc] init];
    areaDropDownMenu = [[XDSDropDownMenu alloc] init];
    
    //将所有DropDownMenu加入dropDownMenuArray数组
    self.dropDownMenuArray = @[styleDropDownMenu,typeDropDownMenu,areaDropDownMenu];
    
    //将所有dropDownMenu的初始tag值设为1000
    for (__strong XDSDropDownMenu *nextDropDownMenu in self.dropDownMenuArray) {
        nextDropDownMenu.tag = 1000;
    }
}
#pragma mark - 风格按钮
- (IBAction)styleBtnClick:(UIButton *)sender {
//    NSArray *dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
//    styleDropDownMenu.delegate = self;//代理
//    [self setupDropDownMenu:styleDropDownMenu withTitleArray:dataArray andButton:sender andDirection:@"down"];
//    [self hideOtherDropDownMenu:styleDropDownMenu];
    if (self.optionCompleteBlock) {
        self.optionCompleteBlock(self, KNBOptionViewButtonType_Style);
    }
}
#pragma mark - 户型按钮
- (IBAction)typeBtnClick:(UIButton *)sender {
    NSArray *dataArray = @[@"1",@"2",@"3"];
    typeDropDownMenu.delegate = self;//代理
    [self setupDropDownMenu:typeDropDownMenu withTitleArray:dataArray andButton:sender andDirection:@"down"];
    [self hideOtherDropDownMenu:typeDropDownMenu];
    
}
#pragma mark - 面积按钮
- (IBAction)areaBtnClick:(UIButton *)sender {
    NSArray *dataArray = @[@"man",@"woman"];
    areaDropDownMenu.delegate = self;//代理
    [self setupDropDownMenu:areaDropDownMenu withTitleArray:dataArray andButton:sender andDirection:@"down"];
    [self hideOtherDropDownMenu:areaDropDownMenu];
    
}
#pragma mark - 设置dropDownMenu
/*
 判断是显示dropDownMenu还是收回dropDownMenu
 */
- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andButton:(UIButton *)button andDirection:(NSString *)direction{
    
    CGRect btnFrame = button.frame; //如果按钮在UIIiew上用这个
    if(dropDownMenu.tag == 1000){
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:button withButtonFrame:btnFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];
        //添加到主视图上
        [self addSubview:dropDownMenu];
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
    }else {
        [dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
        dropDownMenu.tag = 1000;
    }
}
#pragma mark - 隐藏其它DropDownMenu
/*
 在点击按钮的时候，隐藏其它打开的下拉菜单（dropDownMenu）
 */
- (void)hideOtherDropDownMenu:(XDSDropDownMenu *)dropDownMenu{
    
    for ( int i = 0; i < self.dropDownMenuArray.count; i++ ) {
        if( self.dropDownMenuArray[i] !=  dropDownMenu){
            XDSDropDownMenu *dropDownMenuNext = self.dropDownMenuArray[i];
            CGRect btnFrame = ((UIButton *)self.buttonArray[i]).frame;
            [dropDownMenuNext hideDropDownMenuWithBtnFrame:btnFrame];
            dropDownMenuNext.tag = 1000;
        }
    }
}
#pragma mark - 下拉菜单代理
/*
 在点击下拉菜单后，将其tag值重新设为1000
 */
- (void) setDropDownDelegate:(XDSDropDownMenu *)sender{
    sender.tag = 1000;
}
@end
