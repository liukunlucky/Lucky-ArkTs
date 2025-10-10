import router from '@ohos.router'
import { util } from '@kit.ArkTS'

@Entry
@Component
struct UuidGeneratorPage {
  @State uuidV4List: string[] = []
  @State uuidV1: string = ''
  @State customUuid: string = ''
  @State generateCount: number = 1
  @State isGenerating: boolean = false

  aboutToAppear() {
    this.generateUUIDs()
  }

  // 生成UUID v4 (随机)
  generateUUIDv4(): string {
    const randomBytes = new Uint8Array(16)
    for (let i = 0; i < 16; i++) {
      randomBytes[i] = Math.floor(Math.random() * 256)
    }
    
    // 设置版本号 (4) 和变体位
    randomBytes[6] = (randomBytes[6] & 0x0f) | 0x40
    randomBytes[8] = (randomBytes[8] & 0x3f) | 0x80
    
    // 转换为UUID格式
    const hex = Array.from(randomBytes)
      .map(byte => byte.toString(16).padStart(2, '0'))
      .join('')
    
    return [
      hex.substring(0, 8),
      hex.substring(8, 12),
      hex.substring(12, 16),
      hex.substring(16, 20),
      hex.substring(20, 32)
    ].join('-')
  }

  // 生成UUID v1 (基于时间戳)
  generateUUIDv1(): string {
    const now = Date.now()
    const timeHex = now.toString(16).padStart(12, '0')
    
    // 生成随机的节点ID和时钟序列
    const nodeArray: string[] = []
    for (let i = 0; i < 6; i++) {
      nodeArray.push(Math.floor(Math.random() * 256).toString(16).padStart(2, '0'))
    }
    const nodeId = nodeArray.join('')
    
    const clockSeq = Math.floor(Math.random() * 16384).toString(16).padStart(4, '0')
    
    // 构造UUID v1格式
    const timeLow = timeHex.substring(4, 12)
    const timeMid = timeHex.substring(0, 4)
    const timeHigh = '1' + timeHex.substring(0, 3) // 版本号1
    
    return `${timeLow}-${timeMid}-${timeHigh}-${clockSeq}-${nodeId}`
  }

  // 生成自定义格式UUID
  generateCustomUUID(): string {
    const chars = '0123456789abcdef'
    let result = ''
    
    // 生成32个十六进制字符
    for (let i = 0; i < 32; i++) {
      result += chars.charAt(Math.floor(Math.random() * 16))
    }
    
    // 添加连字符
    return [
      result.substring(0, 8),
      result.substring(8, 12),
      result.substring(12, 16),
      result.substring(16, 20),
      result.substring(20, 32)
    ].join('-')
  }

  generateUUIDs() {
    this.isGenerating = true
    
    setTimeout(() => {
      // 生成UUID v4列表
      const uuidArray: string[] = []
      for (let i = 0; i < this.generateCount; i++) {
        uuidArray.push(this.generateUUIDv4())
      }
      this.uuidV4List = uuidArray
      
      // 生成UUID v1
      this.uuidV1 = this.generateUUIDv1()
      
      // 生成自定义UUID
      this.customUuid = this.generateCustomUUID()
      
      this.isGenerating = false
    }, 100)
  }

  copyToClipboard(text: string, type: string) {
    // 这里可以添加复制到剪贴板的功能
    console.info(`复制 ${type}: ${text}`)
  }

  copyAllUUIDs() {
    const allUuids = this.uuidV4List.join('\n')
    this.copyToClipboard(allUuids, '所有UUID')
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

        Text('UUID生成器')
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
          // 生成设置
          Column() {
            Text('生成设置')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 12 })

            Row() {
              Text('生成数量:')
                .fontSize(14)
                .fontColor('#666666')
              
              Blank()
              
              Row() {
                Button('-')
                  .fontSize(16)
                  .fontColor('#007AFF')
                  .backgroundColor(Color.Transparent)
                  .width(32)
                  .height(32)
                  .onClick(() => {
                    if (this.generateCount > 1) {
                      this.generateCount--
                    }
                  })
                
                Text(this.generateCount.toString())
                  .fontSize(16)
                  .fontColor('#333333')
                  .width(40)
                  .textAlign(TextAlign.Center)
                
                Button('+')
                  .fontSize(16)
                  .fontColor('#007AFF')
                  .backgroundColor(Color.Transparent)
                  .width(32)
                  .height(32)
                  .onClick(() => {
                    if (this.generateCount < 50) {
                      this.generateCount++
                    }
                  })
              }
            }
            .width('100%')
            .margin({ bottom: 16 })

            Button('重新生成')
              .width('100%')
              .height(44)
              .backgroundColor('#007AFF')
              .fontColor('#FFFFFF')
              .borderRadius(8)
              .enabled(!this.isGenerating)
              .onClick(() => {
                this.generateUUIDs()
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // UUID v4 (随机)
          Column() {
            Row() {
              Text('UUID v4 (随机)')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              
              Blank()
              
              if (this.uuidV4List.length > 1) {
                Button('复制全部')
                  .fontSize(12)
                  .fontColor('#007AFF')
                  .backgroundColor('#E3F2FD')
                  .height(28)
                  .padding({ left: 8, right: 8 })
                  .borderRadius(14)
                  .onClick(() => {
                    this.copyAllUUIDs()
                  })
              }
            }
            .width('100%')
            .margin({ bottom: 12 })

            if (this.isGenerating) {
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#007AFF')
                
                Text('生成中...')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ left: 8 })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding(20)
            } else {
              ForEach(this.uuidV4List, (uuid: string, index: number) => {
                this.UuidCard(uuid, `UUID v4 #${index + 1}`)
              })
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // UUID v1 (基于时间)
          Column() {
            Text('UUID v1 (基于时间)')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 12 })

            if (this.isGenerating) {
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#007AFF')
                
                Text('生成中...')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ left: 8 })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding(20)
            } else {
              this.UuidCard(this.uuidV1, 'UUID v1')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 自定义格式
          Column() {
            Text('自定义格式')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 12 })

            if (this.isGenerating) {
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#007AFF')
                
                Text('生成中...')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ left: 8 })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding(20)
            } else {
              this.UuidCard(this.customUuid, '自定义UUID')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 使用说明
          Column() {
            Text('UUID版本说明')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 12 })

            Column() {
              this.InfoItem('UUID v1', '基于时间戳和MAC地址，包含时间信息')
              this.InfoItem('UUID v4', '基于随机数生成，最常用的版本')
              this.InfoItem('自定义格式', '纯随机生成的UUID格式字符串')
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

  @Builder UuidCard(uuid: string, label: string) {
    Row() {
      Column() {
        Text(uuid)
          .fontSize(14)
          .fontColor('#333333')
          .fontFamily('monospace')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      
      Button('复制')
        .fontSize(12)
        .fontColor('#007AFF')
        .backgroundColor('#E3F2FD')
        .height(28)
        .padding({ left: 8, right: 8 })
        .borderRadius(14)
        .onClick(() => {
          this.copyToClipboard(uuid, label)
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(6)
    .margin({ bottom: 8 })
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