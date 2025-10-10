import { Question } from '../pages/QuestionBankPage';

@Component
export struct FlipCard {
  @Prop problem: Question;
  @State private isFlipped: boolean = false;
  @State private rotateAngle: number = 0;

  // 翻转卡片
  private flipCard(): void {
    this.isFlipped = !this.isFlipped;
    animateTo({
      duration: 600,
      curve: Curve.EaseInOut
    }, () => {
      this.rotateAngle = this.isFlipped ? 180 : 0;
    });
  }

  // 构建卡片正面（题目）
  @Builder
  private buildFrontSide(): void {
    Column({ space: 16 }) {
      // 题目标题
      Text(`${this.problem.id}`)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 题目描述
      if (this.problem.question) {
        Text(this.problem.question)
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Start)
          .maxLines(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)
      }

      // 翻转提示
      Row({ space: 8 }) {
        Text('点击查看答案')
          .fontSize(12)
          .fontColor('#1890ff')
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 构建卡片背面（答案解析）
  @Builder
  private buildBackSide(): void {
    Column({ space: 16 }) {
      // 答案标题
      Text('答案解析')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1890ff')
        .textAlign(TextAlign.Center)

      // 答案内容（使用解析内容）

      // 解析内容
      if (this.problem.explanation) {
        Column({ space: 8 }) {
          Text('详细解析：')
            .fontSize(12)
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)

          Text(this.problem.explanation)
            .fontSize(12)
            .fontColor('#666666')
            .textAlign(TextAlign.Start)
            .maxLines(6)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(18)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
      }

      // 翻转提示
      Row({ space: 8 }) {
        Text('点击返回题目')
          .fontSize(12)
          .fontColor('#1890ff')
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      if (this.rotateAngle < 90) {
        // 显示正面
        Column() {
          this.buildFrontSide()
        }
        .width('100%')
        .height(280)
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: '#1f000000',
          offsetX: 0,
          offsetY: 2
        })
        .border({
          width: 1,
          color: '#e0e0e0'
        })
        .rotate({
          y: 1,
          angle: this.rotateAngle
        })
        .onClick(() => {
          this.flipCard();
        })
      } else {
        // 显示背面
        Column() {
          this.buildBackSide()
        }
        .width('100%')
        .height(280)
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: '#1f000000',
          offsetX: 0,
          offsetY: 2
        })
        .border({
          width: 1,
          color: '#e0e0e0'
        })
        .rotate({
          y: 1,
          angle: this.rotateAngle - 180
        })
        .onClick(() => {
          this.flipCard();
        })
      }
    }
    .width('100%')
    .height(280)
  }
}