import router from '@ohos.router';
import { FlipCard } from '../component/FlipCard';
import { util } from '@kit.ArkTS'
import { Question } from './QuestionBankPage';

@Entry
@Component
struct KnowledgeRecitePage {
  @State categories: string[] = []
  @State private selectedCategory: string = '';
  @State private currentIndex: number = 0;
  @State private isLoading: boolean = false;
  @State questions: Question[] = []
  @State totalQuestions: Question[] = []
  @State question: Question | null = null

  aboutToAppear(): void {
    this.loadCategories();
  }

  // 加载题目分类
  private async loadCategories(): Promise<void> {
    try {
      const context = getContext(this)
      const fileData = await context.resourceManager.getRawFileContent('arkts.json')
      const decoder = new util.TextDecoder('utf-8')
      const jsonStr = decoder.decodeWithStream(new Uint8Array(fileData.buffer))
      this.totalQuestions = JSON.parse(jsonStr)

      console.info(`题库页面 - 加载了 ${this.totalQuestions.length} 个题目`)
      console.info(`题库页面 - 当前选择的分类: ${this.selectedCategory}`)

      // 提取所有分类（去掉「全部」选项）
      const categorySet = new Set<string>()
      this.totalQuestions.forEach(q => {
        if (q.category && q.category.trim() !== '') {
          categorySet.add(q.category)
        }
      })
      this.categories = Array.from(categorySet)

      console.info(`题库页面 - 所有分类: ${JSON.stringify(this.categories)}`)
      if (this.categories.length > 0) {
        this.selectedCategory = this.categories[0];
        await this.loadProblems();
      }
      this.isLoading = false
    } catch (error) {
      console.error('Failed to load categories:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 加载指定分类的题目
  private async loadProblems(): Promise<void> {
    try {
      this.isLoading = true;
      
      // 按分类筛选题目
      if (this.selectedCategory && this.selectedCategory.trim() !== '') {
        this.questions = this.totalQuestions.filter(q => q.category === this.selectedCategory)
        console.info(`题库页面 - 按分类 "${this.selectedCategory}" 过滤后题目数量: ${this.questions.length}`)
      } else {
        // 如果没有选择分类，显示所有题目
        this.questions = this.totalQuestions
        console.info(`题库页面 - 显示所有题目数量: ${this.questions.length}`)
      }
      
      // 重置当前题目索引
      this.currentIndex = 0;
      this.question = null;
      
    } catch (error) {
      console.error('Failed to load problems:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 切换分类
  private async onCategoryChange(category: string): Promise<void> {
    if (this.selectedCategory === category) return;
    
    this.selectedCategory = category;
    await this.loadProblems();
  }

  // 上一题
  private previousProblem(): void {
    if (this.currentIndex > 0) {
      this.currentIndex--;
    }
  }

  // 下一题
  private nextProblem(): void {
    if (this.currentIndex < this.questions.length - 1) {
      this.currentIndex++;
    }
  }

  // 构建分类选择器
  @Builder
  private buildCategorySelector(): void {
    Column({ space: 16 }) {
      Text('选择题目分类')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')

      // 分类标签
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(this.categories, (category: string) => {
          Text(category)
            .fontSize(12)
            .fontColor(this.selectedCategory === category ? '#ffffff' : '#666666')
            .backgroundColor(this.selectedCategory === category ? '#1890ff' : '#f0f0f0')
            .padding({
              top: 6,
              bottom: 6,
              left: 12,
              right: 12
            })
            .borderRadius(6)
            .margin({
              right: 8,
              bottom: 8
            })
            .onClick(() => {
              this.onCategoryChange(category);
            })
        }, (category: string) => category)
      }
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(24)
    .backgroundColor('#ffffff')
    .borderRadius(12)
    .shadow({
      radius: 4,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  // 构建卡片区域
  @Builder
  private buildCardArea(): void {
    if (this.questions.length === 0) {
      Column({ space: 16 }) {
        Text('📚')
          .fontSize(48)
        
        Text('暂无题目')
          .fontSize(16)
          .fontColor('#666666')
        
        Text('请选择其他分类或稍后再试')
          .fontSize(14)
          .fontColor('#666666')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height(300)
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .shadow({
        radius: 4,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })
    } else {
      Column({ space: 16 }) {
        // 进度指示器
        Row({ space: 8 }) {
          Text(`${this.currentIndex + 1} / ${this.questions.length}`)
            .fontSize(14)
            .fontColor('#666666')
          
          Text(this.selectedCategory)
            .fontSize(14)
            .fontColor('#1890ff')
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')

        // 翻转卡片
        FlipCard({ problem: this.questions[this.currentIndex] })

        // 导航按钮
        Row({ space: 16 }) {
          Button('上一题')
            .fontSize(14)
            .fontColor(this.currentIndex > 0 ? '#ffffff' : '#666666')
            .backgroundColor(this.currentIndex > 0 ? '#1890ff' : '#FFFFFF')
            .borderRadius(8)
            .enabled(this.currentIndex > 0)
            .onClick(() => {
              this.previousProblem();
            })
            .layoutWeight(1)

          Button('下一题')
            .fontSize(14)
            .fontColor(this.currentIndex < this.questions.length - 1 ? '#ffffff' : '#666666')
            .backgroundColor(this.currentIndex < this.questions.length - 1 ? '#1890ff' : '#f5f5f5')
            .borderRadius(8)
            .enabled(this.currentIndex < this.questions.length - 1)
            .onClick(() => {
              this.nextProblem();
            })
            .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
    }
  }

  build() {
    Column() {
      // 顶部导航栏
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

        Text('知识背诵')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位符保持居中
        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')

      // 内容区域
      if (this.isLoading) {
        Column() {
          Column({ space: 16 }) {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#1890ff')

          Text('加载中...')
            .fontSize(14)
            .fontColor('#666666')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Scroll() {
          Column({ space: 24 }) {
            // 分类选择器
            this.buildCategorySelector()

            // 卡片区域
            this.buildCardArea()
          }
          .width('100%')
          .padding(24)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}