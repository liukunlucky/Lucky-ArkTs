import router from '@ohos.router'
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { util } from '@kit.ArkTS'

@Entry
@Component
struct HashToolPage {
  @State inputText: string = ''
  @State md5Result: string = ''
  @State sha1Result: string = ''
  @State sha256Result: string = ''
  @State sha512Result: string = ''
  @State isCalculating: boolean = false

  aboutToAppear() {
    // 设置示例文本
    this.inputText = 'Hello, World!'
    // 移除自动计算，改为手动触发
  }

  async calculateHash(algorithm: string, data: string): Promise<string> {
    try {
      const mdGenerator = cryptoFramework.createMd(algorithm)
      const encoder = new util.TextEncoder()
      const encodedData = encoder.encodeInto(data)
      const dataBlob: cryptoFramework.DataBlob = { data: encodedData }
      
      await mdGenerator.update(dataBlob)
      const hashResult = await mdGenerator.digest()
      
      // 转换为十六进制字符串
      const uint8Array = new Uint8Array(hashResult.data)
      return Array.from(uint8Array)
        .map(byte => byte.toString(16).padStart(2, '0'))
        .join('')
    } catch (error) {
      console.error(`${algorithm} 计算失败:`, error)
      return '计算失败'
    }
  }

  async calculateAllHashes() {
    if (!this.inputText.trim()) {
      this.clearResults()
      return
    }

    this.isCalculating = true
    
    try {
      // 并行计算所有哈希值
      const results = await Promise.all([
        this.calculateHash('MD5', this.inputText),
        this.calculateHash('SHA1', this.inputText),
        this.calculateHash('SHA256', this.inputText),
        this.calculateHash('SHA512', this.inputText)
      ])

      this.md5Result = results[0]
      this.sha1Result = results[1]
      this.sha256Result = results[2]
      this.sha512Result = results[3]
    } catch (error) {
      console.error('哈希计算失败:', error)
    } finally {
      this.isCalculating = false
    }
  }

  clearResults() {
    this.md5Result = ''
    this.sha1Result = ''
    this.sha256Result = ''
    this.sha512Result = ''
  }

  clearInput() {
    this.inputText = ''
    this.clearResults()
  }

  copyToClipboard(text: string, algorithm: string) {
    // 这里可以添加复制到剪贴板的功能
    console.info(`复制 ${algorithm}: ${text}`)
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
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.back();
        })

        Text('Hash工具')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位，保持标题居中
        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 输入区域
          Column() {
            Row() {
              Text('输入文本')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              
              Blank()
              
              Button('清空')
                .fontSize(14)
                .fontColor('#007AFF')
                .backgroundColor(Color.Transparent)
                .border({ width: 1, color: '#007AFF', radius: 16 })
                .height(32)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.clearInput()
                })
            }
            .width('100%')
            .margin({ bottom: 12 })

            TextArea({
              text: this.inputText,
              placeholder: '请输入要计算哈希值的文本...'
            })
              .width('100%')
              .height(120)
              .fontSize(14)
              .backgroundColor('#F8F9FA')
              .borderRadius(8)
              .padding(12)
              .onChange((value: string) => {
                this.inputText = value
              })

            // 生成哈希按钮
            Row() {
              Button('生成哈希值')
                .fontSize(16)
                .fontColor('#FFFFFF')
                .backgroundColor('#007AFF')
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .enabled(!this.isCalculating && this.inputText.trim().length > 0)
                .onClick(() => {
                  this.calculateAllHashes()
                })

              Button('清空结果')
                .fontSize(16)
                .fontColor('#007AFF')
                .backgroundColor('#F8F9FA')
                .border({ width: 1, color: '#007AFF', radius: 8 })
                .height(44)
                .margin({ left: 12 })
                .onClick(() => {
                  this.clearResults()
                })
            }
            .width('100%')
            .margin({ top: 16 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 结果显示区域
          if (this.isCalculating) {
            Column() {
              LoadingProgress()
                .width(40)
                .height(40)
                .color('#007AFF')
              
              Text('计算中...')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ top: 8 })
            }
            .width('100%')
            .height(100)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ bottom: 16 })
          } else {
            // MD5 结果
            this.HashResultCard('MD5', this.md5Result)
            
            // SHA1 结果
            this.HashResultCard('SHA1', this.sha1Result)
            
            // SHA256 结果
            this.HashResultCard('SHA256', this.sha256Result)
            
            // SHA512 结果
            this.HashResultCard('SHA512', this.sha512Result)
          }

          // 使用说明
          Column() {
            Text('使用说明')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 12 })

            Column() {
              this.InfoItem('MD5', '128位哈希值，常用于文件校验')
              this.InfoItem('SHA1', '160位哈希值，比MD5更安全')
              this.InfoItem('SHA256', '256位哈希值，SHA-2系列，高安全性')
              this.InfoItem('SHA512', '512位哈希值，SHA-2系列，最高安全性')
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })
        }
        .padding(16)
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder HashResultCard(algorithm: string, result: string) {
    Column() {
      Row() {
        Text(algorithm)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
        
        Blank()
        
        if (result) {
          Button('复制')
            .fontSize(12)
            .fontColor('#007AFF')
            .backgroundColor('#E3F2FD')
            .height(28)
            .padding({ left: 8, right: 8 })
            .borderRadius(14)
            .onClick(() => {
              this.copyToClipboard(result, algorithm)
            })
        }
      }
      .width('100%')
      .margin({ bottom: 8 })

      if (result) {
        Text(result)
          .fontSize(12)
          .fontColor('#666666')
          .fontFamily('monospace')
          .width('100%')
          .backgroundColor('#F8F9FA')
          .padding(12)
          .borderRadius(6)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(3)
      } else {
        Text('点击"生成哈希值"按钮开始计算')
          .fontSize(14)
          .fontColor('#999999')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(20)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }

  @Builder InfoItem(title: string, description: string) {
    Row() {
      Text('•')
        .fontSize(14)
        .fontColor('#007AFF')
        .margin({ right: 8 })
      
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .margin({ right: 8 })
      
      Text(description)
        .fontSize(14)
        .fontColor('#666666')
        .layoutWeight(1)
    }
    .width('100%')
    .margin({ bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }
}