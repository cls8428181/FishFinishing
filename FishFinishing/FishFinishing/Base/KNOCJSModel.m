//
//  KNOCJSModel.m
//  Concubine
//
//  Created by 吴申超 on 16/8/25.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNOCJSModel.h"


@implementation KNOCJSModel

- (void)viewDetailMyTeam {
    if (self.myTeamBlock) {
        self.myTeamBlock();
    }
}

- (void)viewDetailGoodsId:(NSString *)goodsId actionType:(NSString *)actionType {
    if (self.goodsIdBlock) {
        self.goodsIdBlock(goodsId, actionType);
    }
}

- (void)viewDetailPersonalTailor {
    if (self.popControllerBlock) {
        self.popControllerBlock(NO);
    }
}

- (void)viewDetailDelayPopView {
    if (self.popControllerBlock) {
        self.popControllerBlock(YES);
    }
}

- (void)viewDetailClose {
    if (self.popControllerBlock) {
        self.popControllerBlock(NO);
    }
}

- (void)viewOnBackPressed {
    if (self.webViewPopBlock) {
        self.webViewPopBlock();
    }
}

- (void)viewDetailShare:(NSString *)title describe:(NSString *)describe url:(NSString *)url {
    if (self.webViewShareBlock) {
        self.webViewShareBlock(title, describe, url);
    }
}

- (void)gotoArticleDetails:(NSInteger)articleId{
    if (self.gotoArticleDetailBlock) {
        self.gotoArticleDetailBlock(articleId);
    }
}


@end
