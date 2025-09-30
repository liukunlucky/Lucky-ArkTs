import router from '@ohos.router'

@Entry
@Component
struct RegexTestPage {
  @State regexPattern: string = ''
  @State testText: string = ''
  @State matchResults: string[] = []
  @State isValid: boolean = true
  @State errorMessage: string = ''
  @State flags: string = 'g'
  @State replaceText: string = ''
  @State replaceResult: string = ''

  testRegex() {
    try {
      if (!this.regexPattern.trim()) {
        this.errorMessage = '请输入正则表达式'
        this.isValid = false
        return
      }

      if (!this.testText.trim()) {
        this.errorMessage = '请输入测试文本'
        this.isValid = false
        return
      }

      const regex = new RegExp(this.regexPattern, this.flags)
      const matches = this.testText.match(regex)
      
      if (matches) {
        this.matchResults = matches
        this.errorMessage = `找到 ${matches.length} 个匹配项`
        this.isValid = true
      } else {
        this.matchResults = []
        this.errorMessage = '没有找到匹配项'
        this.isValid = true
      }
    } catch (error) {
      this.errorMessage = `正则表达式错误: ${error.message}`
      this.isValid = false
      this.matchResults = []
    }
  }

  replaceWithRegex() {
    try {
      if (!this.regexPattern.trim()) {
        this.errorMessage = '请输入正则表达式'
        this.isValid = false
        return
      }

      if (!this.testText.trim()) {
        this.errorMessage = '请输入测试文本'
        this.isValid = false
        return
      }

      const regex = new RegExp(this.regexPattern, this.flags)
      this.replaceResult = this.testText.replace(regex, this.replaceText)
      this.errorMessage = '替换完成'
      this.isValid = true
    } catch (error) {
      this.errorMessage = `正则表达式错误: ${error.message}`
      this.isValid = false
      this.replaceResult = ''
    }
  }

  clearAll() {
    this.regexPattern = ''
    this.testText = ''
    this.matchResults = []
    this.replaceText = ''
    this.replaceResult = ''
    this.errorMessage = ''
    this.isValid = true
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Button('返回')
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back()
          })

        Blank()


        Text('正则表达式测试工具')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Blank()

        Button('清空')
          .fontSize(16)
          .fontColor('#FF3B30')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.clearAll()
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column({ space: 16 }) {
          // 正则表达式输入区域
          Column({ space: 8 }) {
            Row() {
              Text('正则表达式')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            TextInput({ placeholder: '请输入正则表达式，例如：\\d+' })
              .width('100%')
              .height(48)
              .fontSize(14)
              .borderRadius(8)
              .border({ width: 1, color: '#E5E5E5' })
              .onChange((value: string) => {
                this.regexPattern = value
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 标志位设置
          Column({ space: 8 }) {
            Row() {
              Text('标志位')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row({ space: 12 }) {
              Button('g')
                .fontSize(12)
                .backgroundColor(this.flags.includes('g') ? '#007DFF' : '#ffffff')
                .fontColor(this.flags.includes('g') ? Color.White : '#666666')
                .onClick(() => {
                  if (this.flags.includes('g')) {
                    this.flags = this.flags.replace('g', '')
                  } else {
                    this.flags += 'g'
                  }
                })

              Button('i')
                .fontSize(12)
                .backgroundColor(this.flags.includes('i') ? '#007DFF' : '#ffffff')
                .fontColor(this.flags.includes('i') ? Color.White : '#666666')
                .onClick(() => {
                  if (this.flags.includes('i')) {
                    this.flags = this.flags.replace('i', '')
                  } else {
                    this.flags += 'i'
                  }
                })

              Button('m')
                .fontSize(12)
                .backgroundColor(this.flags.includes('m') ? '#007DFF' : '#ffffff')
                .fontColor(this.flags.includes('m') ? Color.White : '#666666')
                .onClick(() => {
                  if (this.flags.includes('m')) {
                    this.flags = this.flags.replace('m', '')
                  } else {
                    this.flags += 'm'
                  }
                })

              Text('g:全局匹配 i:忽略大小写 m:多行模式')
                .fontSize(12)
                .fontColor('#999999')
                .layoutWeight(1)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 测试文本输入区域
          Column({ space: 8 }) {
            Row() {
              Text('测试文本')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            TextArea({ placeholder: '请输入要测试的文本内容...' })
              .width('100%')
              .height(120)
              .fontSize(14)
              .borderRadius(8)
              .border({ width: 1, color: '#E5E5E5' })
              .onChange((value: string) => {
                this.testText = value
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 操作按钮
          Row({ space: 12 }) {
            Button('测试匹配')
              .fontSize(14)
              .height(36)
              .backgroundColor('#007DFF')
              .fontColor(Color.White)
              .onClick(() => {
                this.testRegex()
              })

          }
          .width('100%')
          .justifyContent(FlexAlign.Start)

          // 匹配结果显示
          if (this.matchResults.length > 0) {
            Column({ space: 8 }) {
              Row() {
                Text('匹配结果')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)

              Column({ space: 4 }) {
                ForEach(this.matchResults, (match: string, index: number) => {
                  Row() {
                    Text(`${index + 1}. ${match}`)
                      .fontSize(14)
                      .fontColor('#333333')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width('100%')
                  .height(32)
                  .padding({ left: 12, right: 12 })
                  .backgroundColor('#F8F9FA')
                  .borderRadius(6)
                  .alignItems(VerticalAlign.Center)
                }, (match: string, index: number) => `${index}_${match}`)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }

          // 替换功能
          Column({ space: 8 }) {
            Row() {
              Text('替换功能')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            TextInput({ placeholder: '替换为...' })
              .width('100%')
              .height(48)
              .fontSize(14)
              .borderRadius(8)
              .border({ width: 1, color: '#E5E5E5' })
              .onChange((value: string) => {
                this.replaceText = value
              })

            Button('执行替换')
              .fontSize(14)
              .height(36)
              .backgroundColor('#28A745')
              .fontColor(Color.White)
              .onClick(() => {
                this.replaceWithRegex()
              })

            if (this.replaceResult) {
              Column({ space: 8 }) {
                Row() {
                  Text('替换结果')
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)

                TextArea({ text: this.replaceResult })
                  .width('100%')
                  .height(100)
                  .fontSize(14)
                  .borderRadius(8)
                  .border({ width: 1, color: '#E5E5E5' })
                  .enabled(false)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 错误信息或状态显示
          if (this.errorMessage) {
            Row() {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor(this.isValid ? '#28A745' : '#DC3545')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(this.isValid ? '#D4EDDA' : '#F8D7DA')
            .borderRadius(8)
            .justifyContent(FlexAlign.Start)
          }
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}