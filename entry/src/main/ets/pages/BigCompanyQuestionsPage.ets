import router from '@ohos.router'
import { BigCompanyQuestion, BigCompanyQuestionService } from '../services/BigCompanyQuestionService'

@Entry
@Component
struct BigCompanyQuestionsPage {
  @State questions: BigCompanyQuestion[] = []
  @State selectedCompany: string = '全部'
  @State selectedDifficulty: string = '全部'
  @State selectedCategory: string = '全部'
  @State isLoading: boolean = true
  
  private companies: string[] = ['全部', '阿里巴巴', '腾讯', '字节跳动', '美团', '百度', '京东', '滴滴', '小米']
  private difficulties: string[] = ['全部', '简单', '中等', '困难']
  private categories: string[] = ['全部', 'JavaScript', 'Vue', 'React', 'Node.js', '算法', '网络', '浏览器']

  async aboutToAppear() {
    await this.loadQuestions()
  }

  async loadQuestions() {
    try {
      this.isLoading = true
      this.questions = await BigCompanyQuestionService.getQuestions()
      this.filterQuestions()
    } catch (error) {
      console.error('加载大厂真题失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  async filterQuestions() {
    const allQuestions = await BigCompanyQuestionService.getQuestions()
    let filteredQuestions = allQuestions
    
    if (this.selectedCompany !== '全部') {
      filteredQuestions = filteredQuestions.filter(q => q.company === this.selectedCompany)
    }
    
    if (this.selectedDifficulty !== '全部') {
      filteredQuestions = filteredQuestions.filter(q => q.difficulty === this.selectedDifficulty)
    }
    
    if (this.selectedCategory !== '全部') {
      filteredQuestions = filteredQuestions.filter(q => q.category === this.selectedCategory)
    }
    
    this.questions = filteredQuestions
  }

  async onFilterChange() {
    await this.filterQuestions()
  }

  navigateToQuestionDetail(question: BigCompanyQuestion) {
    router.pushUrl({
      url: 'pages/BigCompanyQuestionDetailPage',
      params: { question: question }
    })
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .fillColor('#333333')
          .onClick(() => {
            router.back()
          })
        
        Text('大厂真题')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        
        Blank().width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      if (this.isLoading) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#007DFF')
          
          Text('加载中...')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 筛选区域
            this.FilterSection()
            
            // 题目列表
            this.QuestionList()
          }
          .width('100%')
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .padding({bottom: 50})
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder FilterSection() {
    Column() {
      // 公司筛选
      Row() {
        Text('公司:')
          .fontSize(14)
          .fontColor('#333333')
          .width(50)
        
        Scroll() {
          Row() {
            ForEach(this.companies, (company: string) => {
              Text(company)
                .fontSize(12)
                .fontColor(this.selectedCompany === company ? '#FFFFFF' : '#666666')
                .backgroundColor(this.selectedCompany === company ? '#007DFF' : '#F0F0F0')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .borderRadius(16)
                .margin({ right: 8 })
                .onClick(() => {
                  this.selectedCompany = company
                  this.onFilterChange()
                })
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .flexGrow(1)
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 难度筛选
      Row() {
        Text('难度:')
          .fontSize(14)
          .fontColor('#333333')
          .width(50)
        
        Row() {
          ForEach(this.difficulties, (difficulty: string) => {
            Text(difficulty)
              .fontSize(12)
              .fontColor(this.selectedDifficulty === difficulty ? '#FFFFFF' : '#666666')
              .backgroundColor(this.selectedDifficulty === difficulty ? '#007DFF' : '#F0F0F0')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .borderRadius(16)
              .margin({ right: 8 })
              .onClick(() => {
                this.selectedDifficulty = difficulty
                this.onFilterChange()
              })
          })
        }
        .flexGrow(1)
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 分类筛选
      Row() {
        Text('分类:')
          .fontSize(14)
          .fontColor('#333333')
          .width(50)
        
        Scroll() {
          Row() {
            ForEach(this.categories, (category: string) => {
              Text(category)
                .fontSize(12)
                .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#666666')
                .backgroundColor(this.selectedCategory === category ? '#007DFF' : '#F0F0F0')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .borderRadius(16)
                .margin({ right: 8 })
                .onClick(() => {
                  this.selectedCategory = category
                  this.onFilterChange()
                })
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .flexGrow(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .margin({ bottom: 8 })
  }

  @Builder QuestionList() {
    Column() {
      if (this.questions.length === 0) {
        Column() {
          Image($r('sys.media.ohos_ic_public_cancel'))
            .width(80)
            .height(80)
            .fillColor('#CCCCCC')
          
          Text('暂无题目')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 16 })
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      } else {
        ForEach(this.questions, (question: BigCompanyQuestion, index: number) => {
          this.QuestionItem(question, index)
        })
      }
    }
    .width('100%')
  }

  @Builder QuestionItem(question: BigCompanyQuestion, index: number) {
    Column() {
      Row() {
        // 公司标签
        Text(question.company)
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
        
        // 难度标签
        Text(question.difficulty)
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getDifficultyColor(question.difficulty))
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })
        
        // 分类标签
        Text(question.category)
          .fontSize(10)
          .fontColor('#666666')
          .backgroundColor('#F0F0F0')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })
        
        Blank()
        
        // 年份
        Text(question.year.toString())
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 题目标题
      Text(question.title)
        .fontSize(16)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ bottom: 8 })

      // 题目描述
      Text(question.description)
        .fontSize(14)
        .fontColor('#666666')
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ bottom: 12 })

      // 底部信息
      Row() {
        Text(`${question.viewCount} 浏览`)
          .fontSize(12)
          .fontColor('#999999')
        
        Text(`${question.likeCount} 点赞`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ left: 16 })
        
        Blank()
        
        Text('查看详情')
          .fontSize(12)
          .fontColor('#007DFF')
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8, left: 16, right: 16 })
    .onClick(() => {
      this.navigateToQuestionDetail(question)
    })
  }

  getDifficultyColor(difficulty: string): string {
    switch (difficulty) {
      case '简单':
        return '#52C41A'
      case '中等':
        return '#FA8C16'
      case '困难':
        return '#F5222D'
      default:
        return '#666666'
    }
  }
}