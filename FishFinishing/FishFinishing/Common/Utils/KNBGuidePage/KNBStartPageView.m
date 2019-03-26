//
//  WStartPageView.m
//  Freedom
//
//  Created by 吴申超 on 15/12/21.
//  Copyright © 2015年 Freedom. All rights reserved.
//

#import "KNBStartPageView.h"


@interface KNBStartPageView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation KNBStartPageView

+ (KNBStartPageView *)creatStartPageView:(CGRect)frame {
    KNBStartPageView *view = [[[NSBundle mainBundle] loadNibNamed:@"KNBStartPageView" owner:self options:nil] lastObject];
    view.frame = frame;
    return view;
}

- (void)setPageDic:(NSDictionary *)pageDic {
    if (_pageDic != pageDic) {
        _pageDic = pageDic;
        self.iconImageView.image = [UIImage imageNamed:pageDic[@"icon"]];
    }
}

// 立即开启
- (IBAction)wCancel:(id)sender {
    if (self.index == 4) {
        if (_delegate && [_delegate respondsToSelector:@selector(wstartPageView:cancel:)]) {
            [_delegate wstartPageView:self cancel:sender];
        }
    }
}

- (NSString *)replaceStr:(NSString *)str {
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\\n"
                                 withString:@"\n"
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

// 设置文字样式
- (NSMutableAttributedString *)spliceContent:(NSString *)content {
    NSMutableAttributedString *muString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", content]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *att3 = @{NSParagraphStyleAttributeName : paragraphStyle,
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    [muString addAttributes:att3 range:NSMakeRange(0, muString.length)];
    return muString;
}

- (UIColor *)colorFromARGB:(int)argb {
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0];
}

- (long)argbFromHex:(NSString *)hex {
    const char *cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr + 1, NULL, 16);
    return x;
}

@end
