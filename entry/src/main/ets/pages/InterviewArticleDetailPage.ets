import router from '@ohos.router';
import { InterviewArticleModel, getCategoryDisplayName, getCategoryColor } from '../model/InterviewArticleModel';

interface RouterParams {
  article: InterviewArticleModel;
}

@Entry
@Component
struct InterviewArticleDetailPage {
  @State article: InterviewArticleModel | null = null;
  @State isLiked: boolean = false;
  @State isCollected: boolean = false;
  @State showShareDialog: boolean = false;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params && params.article) {
      this.article = params.article;
    }
  }

  formatReadTime(readTime: number): string {
    return `${readTime}分钟阅读`;
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = now.getTime() - date.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 0) {
      return '今天';
    } else if (diffDays === 1) {
      return '昨天';
    } else if (diffDays < 7) {
      return `${diffDays}天前`;
    } else {
      return dateString;
    }
  }

  formatCount(count: number): string {
    if (count >= 1000) {
      return `${(count / 1000).toFixed(1)}k`;
    }
    return count.toString();
  }

  onLikeClick() {
    this.isLiked = !this.isLiked;
    if (this.article) {
      this.article.likeCount += this.isLiked ? 1 : -1;
    }
  }

  onCollectClick() {
    this.isCollected = !this.isCollected;
    // 这里可以添加收藏逻辑
  }

  onShareClick() {
    this.showShareDialog = true;
  }

  @Builder
  buildHeader() {
    Row() {
      Button() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .fillColor('#333333')
      }
      .width(40)
      .height(40)
      .backgroundColor('#ffffff')
      .borderRadius(20)
      .onClick(() => {
        router.back();
      })
      
      Text('文章详情')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Blank().width(40)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  buildArticleHeader() {
    if (this.article) {
    
    Column() {
      // 标题
      Text(this.article.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .lineHeight(28)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })
      
      // 作者信息和元数据
      Row() {
        Row() {
          Image($r('app.media.icon_mine'))
            .width(32)
            .height(32)
            .borderRadius(16)
          
          Column() {
            Text(this.article.author)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            
            Row() {
              Text(this.formatDate(this.article.publishDate))
                .fontSize(12)
                .fontColor('#999999')
              
              Text('·')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ left: 4, right: 4 })
              
              Text(this.formatReadTime(this.article.readTime))
                .fontSize(12)
                .fontColor('#999999')
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 8 })
        }
        .layoutWeight(1)
        
      }
      .width('100%')
      .margin({ bottom: 16 })
      
      // 分类和统计信息
      Row() {
        Text(getCategoryDisplayName(this.article.category))
          .fontSize(12)
          .fontColor(getCategoryColor(this.article.category))
          .backgroundColor(getCategoryColor(this.article.category) + '20')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
        
        Blank()
        
        Row() {
          Image($r('app.media.icon_check'))
            .width(14)
            .height(14)
          
          Text(this.formatCount(this.article.viewCount))
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        
        Row() {
          Image($r('app.media.icon_like'))
            .width(14)
            .height(14)
          
          Text(this.formatCount(this.article.likeCount))
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .margin({ left: 16 })
      }
      .width('100%')
      
      // 封面图片
      if (this.article.coverImage) {
        Image(this.article.coverImage)
          .width('100%')
          .height(200)
          .borderRadius(12)
          .margin({ top: 16 })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    }
  }

  @Builder
  buildArticleContent() {
    if (this.article) {
      Column() {
        Text(this.article.content)
          .fontSize(16)
          .lineHeight(24)
          .fontColor('#333333')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
    }
  }

  @Builder
  buildTags() {
    if (this.article && this.article.tags && this.article.tags.length > 0) {
    
    Column() {
      Text('相关标签')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 12 })
      
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.article.tags, (tag: string) => {
          Text(`#${tag}`)
            .fontSize(14)
            .fontColor('#007AFF')
            .backgroundColor('#F0F8FF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .margin({ right: 8, bottom: 8 })
            .onClick(() => {
              // 点击标签搜索相关文章
            })
        })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .margin({ top: 8 })
    }
  }

  @Builder
  buildActionBar() {
    Row() {
      Row() {
        Image(this.isLiked ? $r('app.media.icon_like_full') : $r('app.media.icon_like'))
          .width(24)
          .height(24)
          .fillColor(this.isLiked ? '#FF4757' : '#999999')
        
        Text(this.isLiked ? '已赞' : '点赞')
          .fontSize(14)
          .fontColor(this.isLiked ? '#FF4757' : '#999999')
          .margin({ left: 4 })
      }
      .onClick(() => {
        this.onLikeClick()
      })
      
      Row() {
        Image(this.isCollected ? $r('app.media.star_icon') : $r('app.media.star_outline_icon'))
          .width(24)
          .height(24)
          .fillColor(this.isCollected ? '#FFA502' : '#999999')
        
        Text(this.isCollected ? '已收藏' : '收藏')
          .fontSize(14)
          .fontColor(this.isCollected ? '#FFA502' : '#999999')
          .margin({ left: 4 })
      }
      .margin({ left: 32 })
      .onClick(() => {
        this.onCollectClick()
      })
      
      Row() {
        Image($r('app.media.comment_icon'))
          .width(24)
          .height(24)
          .fillColor('#999999')
        
        Text('评论')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ left: 4 })
      }
      .margin({ left: 32 })
      .onClick(() => {
        // 评论功能
      })
      
      Blank()
      
      Row() {
        Image($r('app.media.share_icon'))
          .width(24)
          .height(24)
          .fillColor('#999999')
        
        Text('分享')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ left: 4 })
      }
      .onClick(() => {
        this.onShareClick()
      })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }

  @Builder
  buildRecommendedArticles() {
    Column() {
      Text('推荐阅读')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 12 })
      
      // 这里可以添加推荐文章列表
      Text('暂无推荐文章')
        .fontSize(14)
        .fontColor('#999999')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(32)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .margin({ top: 8 })
  }

  build() {
    Column() {
      this.buildHeader()
      
      if (this.article) {
        Scroll(this.scroller) {
          Column() {
            this.buildArticleHeader()
            this.buildArticleContent()
            this.buildTags()
            this.buildRecommendedArticles()
          }
        }
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')
        
      } else {
        Column() {
          Image($r('app.media.icon_empty'))
            .width(120)
            .height(120)
            .opacity(0.5)
          
          Text('文章不存在')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 16 })
          
          Button('返回')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#007AFF')
            .borderRadius(8)
            .padding({ left: 24, right: 24, top: 12, bottom: 12 })
            .margin({ top: 24 })
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
  }
}