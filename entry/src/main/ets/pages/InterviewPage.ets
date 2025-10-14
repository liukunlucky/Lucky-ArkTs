import router from '@ohos.router';
import { InterviewArticleModel, InterviewArticleCategory, getCategoryDisplayName, getCategoryColor } from '../model/InterviewArticleModel';
import { InterviewArticleMockData } from '../mock/InterviewArticleMockData';

@Entry
@Component
struct InterviewPage {
  @State articles: InterviewArticleModel[] = [];
  @State filteredArticles: InterviewArticleModel[] = [];
  @State selectedCategory: InterviewArticleCategory | null = null;
  @State searchKeyword: string = '';
  @State currentTabIndex: number = 0;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.loadArticles();
  }

  loadArticles() {
    this.articles = InterviewArticleMockData.getAllArticles();
    this.filteredArticles = this.articles;
  }

  filterArticles() {
    let filtered = this.articles;

    // 按分类筛选
    if (this.selectedCategory !== null) {
      filtered = filtered.filter(article => article.category === this.selectedCategory);
    }

    // 按关键词搜索
    if (this.searchKeyword.trim() !== '') {
      filtered = InterviewArticleMockData.searchArticles(this.searchKeyword);
    }

    this.filteredArticles = filtered;
  }

  onCategorySelected(category: InterviewArticleCategory | null) {
    this.selectedCategory = category;
    this.filterArticles();
  }

  onSearchKeywordChanged(keyword: string) {
    this.searchKeyword = keyword;
    this.filterArticles();
  }

  onArticleClick(article: InterviewArticleModel) {
    // 增加浏览量
    InterviewArticleMockData.incrementViewCount(article.id);

    // 跳转到文章详情页
    router.pushUrl({
      url: 'pages/InterviewArticleDetailPage',
      params: {
        article: article
      }
    });
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

      Text('面试宝典')
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
  buildSearchAndFilter() {
    Column() {
      // 搜索框
      Row() {
        TextInput({ placeholder: '搜索面试文章...', text: this.searchKeyword })
          .layoutWeight(1)
          .placeholderColor('#D5DBDB')
          .height(40)
          .fontSize(14)
          .backgroundColor('#F8F8F8')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.onSearchKeywordChanged(value)
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 分类标签
      Scroll(this.scroller) {
        Row() {
          this.buildCategoryChip('全部', null)
          this.buildCategoryChip('面试技巧', InterviewArticleCategory.SKILLS)
          this.buildCategoryChip('算法面试', InterviewArticleCategory.ALGORITHM)
          this.buildCategoryChip('行为面试', InterviewArticleCategory.BEHAVIORAL)
          this.buildCategoryChip('系统设计', InterviewArticleCategory.SYSTEM_DESIGN)
          this.buildCategoryChip('薪资谈判', InterviewArticleCategory.SALARY_NEGOTIATION)
          this.buildCategoryChip('面试经验', InterviewArticleCategory.EXPERIENCE)
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .height(50)
    }
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildCategoryChip(text: string, category: InterviewArticleCategory | null) {
    Text(text)
      .fontSize(14)
      .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#666666')
      .backgroundColor(this.selectedCategory === category ? '#007AFF' : '#F0F0F0')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .borderRadius(16)
      .margin({ right: 8 })
      .onClick(() => {
        this.onCategorySelected(category)
      })
  }

  @Builder
  buildArticleList() {
    if (this.filteredArticles.length === 0) {
      Column() {
        Image($r('app.media.icon_empty'))
          .width(58)
          .height(42)
          .opacity(0.5)

        Text('暂无相关文章')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 16 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else {
      List() {
        ForEach(this.filteredArticles, (article: InterviewArticleModel) => {
          ListItem() {
            this.buildArticleItem(article)
          }
        })
      }
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8, bottom: 16 })
      .divider({ strokeWidth: 1, color: '#F0F0F0', startMargin: 16, endMargin: 16 })
    }
  }

  @Builder
  buildArticleItem(article: InterviewArticleModel) {
    Column() {
      Row() {
        Column() {
          Text(article.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .textAlign(TextAlign.Start)

          Text(article.summary)
            .fontSize(14)
            .fontColor('#666666')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        if (article.coverImage) {
          Image(article.coverImage)
            .width(80)
            .height(60)
            .borderRadius(8)
            .margin({ left: 12 })
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      Row() {
        Text(article.author)
          .fontSize(12)
          .fontColor('#999999')

        Text('·')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ left: 4, right: 4 })

        Text(this.formatDate(article.publishDate))
          .fontSize(12)
          .fontColor('#999999')

        Text('·')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ left: 4, right: 4 })

        Text(this.formatReadTime(article.readTime))
          .fontSize(12)
          .fontColor('#999999')

        Blank()

        Row() {
          Image($r('app.media.icon_check'))
            .width(12)
            .height(12)

          Text(this.formatCount(article.viewCount))
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }

        Row() {
          Image($r('app.media.icon_like'))
            .width(12)
            .height(12)

          Text(this.formatCount(article.likeCount))
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .margin({ left: 12 })
      }
      .width('100%')
      .margin({ top: 12 })

      // 分类标签
      Text(getCategoryDisplayName(article.category))
        .fontSize(10)
        .fontColor(getCategoryColor(article.category))
        .backgroundColor(getCategoryColor(article.category) + '20')
        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
        .borderRadius(4)
        .margin({ top: 8 })
        .alignSelf(ItemAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .onClick(() => {
      this.onArticleClick(article)
    })
  }



  build() {
    Column() {
      this.buildHeader()
      this.buildSearchAndFilter()
      this.buildArticleList()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}