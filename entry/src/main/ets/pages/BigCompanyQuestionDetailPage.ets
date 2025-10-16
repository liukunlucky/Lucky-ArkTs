import router from '@ohos.router'
import { BigCompanyQuestion, BigCompanyQuestionService } from '../services/BigCompanyQuestionService'

@Entry
@Component
struct BigCompanyQuestionDetailPage {
  @State question: BigCompanyQuestion | null = null
  @State showAnswer: boolean = false
  @State isLiked: boolean = false
  @State isLoading: boolean = true

  async aboutToAppear() {
    const params = router.getParams() as Record<string, Object>
    if (params && params.question) {
      this.question = params.question as BigCompanyQuestion
      this.isLoading = false
      // 增加浏览量
      await BigCompanyQuestionService.incrementViewCount((params.question as BigCompanyQuestion).id)
    } else {
      // 如果没有传递参数，返回上一页
      router.back()
    }
  }

  async toggleLike() {
    if (this.question) {
      this.isLiked = !this.isLiked
      if (this.isLiked) {
        await BigCompanyQuestionService.incrementLikeCount(this.question.id)
        this.question.likeCount++
      } else {
        this.question.likeCount--
      }
    }
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
        
        Text('题目详情')
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

      if (this.isLoading || !this.question) {
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
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 题目信息卡片
            this.QuestionInfoCard()
            
            // 题目内容
            this.QuestionContent()
            
            // 答案区域
            this.AnswerSection()
            
            // 解析区域
            if (this.showAnswer) {
              this.AnalysisSection()
            }
          }
          .width('100%')
          .padding({ bottom: 20 })
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

  @Builder QuestionInfoCard() {
    Column() {
      // 标签行
      Row() {
        Text(this.question!.company)
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
        
        Text(this.question!.difficulty)
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getDifficultyColor(this.question!.difficulty))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
          .margin({ left: 8 })
        
        Text(this.question!.category)
          .fontSize(12)
          .fontColor('#666666')
          .backgroundColor('#F0F0F0')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
          .margin({ left: 8 })
        
        Blank()
        
        Text(`${this.question!.year}年`)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 题目标题
      Text(this.question!.title)
        .fontSize(20)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .margin({ bottom: 12 })

      // 题目描述
      Text(this.question!.description)
        .fontSize(16)
        .fontColor('#666666')
        .lineHeight(24)
        .width('100%')
        .margin({ bottom: 16 })

      // 统计信息
      Row() {
        Row() {
          Image($r('sys.media.ohos_ic_public_copy'))
            .width(16)
            .height(16)
            .fillColor('#999999')
          
          Text(`${this.question!.viewCount} 浏览`)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        
        Row() {
          Image($r('sys.media.ohos_ic_public_add'))
            .width(16)
            .height(16)
            .fillColor('#999999')
          
          Text(`${this.question!.likeCount} 点赞`)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .margin({ left: 20 })
        
        Blank()
      }
      .width('100%')

      // 标签
      if (this.question!.tags && this.question!.tags.length > 0) {
        Row() {
          ForEach(this.question!.tags, (tag: string) => {
            Text(`#${tag}`)
              .fontSize(12)
              .fontColor('#007DFF')
              .backgroundColor('#E6F3FF')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(12)
              .margin({ right: 8, top: 12 })
          })
        }
        .width('100%')

      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, left: 16, right: 16 })
  }

  @Builder QuestionContent() {
    Column() {
      Row() {
        Text('题目内容')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(this.question!.content)
        .fontSize(14)
        .fontColor('#333333')
        .lineHeight(22)
        .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, left: 16, right: 16 })
  }

  @Builder AnswerSection() {
    Column() {
      Row() {
        Text('参考答案')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        
        Blank()
        
        Button(this.showAnswer ? '隐藏答案' : '查看答案')
          .fontSize(12)
          .fontColor(this.showAnswer ? '#FF4757' : '#007DFF')
          .backgroundColor(this.showAnswer ? '#FFE6E6' : '#E6F3FF')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(16)
          .onClick(() => {
            this.showAnswer = !this.showAnswer
          })
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.showAnswer) {
        Text(this.question!.answer)
          .fontSize(14)
          .fontColor('#333333')
          .lineHeight(22)
          .width('100%')
          .padding(12)
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, left: 16, right: 16 })
  }

  @Builder AnalysisSection() {
    Column() {
      Row() {
        Text('题目解析')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(this.question!.analysis)
        .fontSize(14)
        .fontColor('#666666')
        .lineHeight(22)
        .width('100%')
        .padding(12)
        .backgroundColor('#F0F8FF')
        .borderRadius(8)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, left: 16, right: 16 })
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