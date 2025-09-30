import router from '@ohos.router'
import { componentSnapshot, promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct QRCodePage {
  @State inputText: string = ''
  @State qrCodeData: string = ''
  @State errorMessage: string = ''
  @State qrSize: number = 200
  @State qrBackgroundColor: string = '#FFFFFF'
  @State qrForegroundColor: string = '#000000'

  // 安全控件按钮配置
  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }

  // 简单的二维码数据生成（模拟）
  generateQRCode() {
    try {
      if (!this.inputText.trim()) {
        this.errorMessage = '请输入要生成二维码的内容'
        this.qrCodeData = ''
        return
      }

      if (this.inputText.length > 500) {
        this.errorMessage = '内容过长，请控制在500字符以内'
        this.qrCodeData = ''
        return
      }

      // 这里使用简单的方式模拟二维码生成
      // 在实际应用中，需要使用专门的二维码生成库
      this.qrCodeData = this.inputText
      this.errorMessage = '二维码生成成功'
    } catch (error) {
      this.errorMessage = `生成失败: ${error.message}`
      this.qrCodeData = ''
    }
  }

  clearAll() {
    this.inputText = ''
    this.qrCodeData = ''
    this.errorMessage = ''
  }

  // 使用安全控件保存二维码到相册
  async saveQRCodeWithSecureButton() {
    try {
      if (!this.qrCodeData) {
        this.errorMessage = '请先生成二维码'
        return null
      }

      // 截取组件快照
      const pixelMap = await componentSnapshot.get('qrCodeComponent')
      
      // 创建图片打包器
      const imagePackerApi = image.createImagePacker()
      
      // 设置打包参数
      const packOpts: image.PackingOption = {
        format: 'image/png',
        quality: 100
      }
      
      // 直接从PixelMap打包图片
      const imageData = await imagePackerApi.packing(pixelMap, packOpts)
      
      // 创建临时文件
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext
      const cacheDir = context.cacheDir
      const fileName = `qrcode_${Date.now()}.png`
      const tempFilePath = `${cacheDir}/${fileName}`
      
      // 写入临时文件
      const file = await fileIo.open(tempFilePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY)
      await fileIo.write(file.fd, imageData)
      await fileIo.close(file.fd)
      
      // 返回文件URI供安全控件使用
      return `file://${tempFilePath}`
    } catch (error) {
      console.error('准备保存文件失败:', error)
      this.errorMessage = `准备保存失败: ${(error as BusinessError).message || '未知错误'}`
      return null
    }
  }

  // 预设内容快速生成
  setPresetContent(content: string) {
    this.inputText = content
    this.generateQRCode()
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

        Text('二维码生成工具')
          .fontSize(20)
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
        Column({ space: 20 }) {
          // 内容输入区域
          Column({ space: 12 }) {
            Row() {
              Text('输入内容')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            TextArea({ 
              placeholder: '请输入要生成二维码的内容...\n支持文本、网址、联系方式等',
              text: this.inputText
            })
              .width('100%')
              .height(120)
              .fontSize(14)
              .borderRadius(8)
              .border({ width: 1, color: '#E5E5E5' })
              .onChange((value: string) => {
                this.inputText = value
              })

            Text(`字符数: ${this.inputText.length}/500`)
              .fontSize(12)
              .fontColor(this.inputText.length > 500 ? '#DC3545' : '#999999')
              .alignSelf(ItemAlign.End)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 快速内容选择
          Column({ space: 12 }) {
            Row() {
              Text('快速内容')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Flex({ wrap: FlexWrap.Wrap }) {
              Button('网站链接')
                .fontSize(12)
                .height(32)
                .backgroundColor('#E3F2FD')
                .fontColor('#1976D2')
                .onClick(() => {
                  this.setPresetContent('https://www.example.com')
                })

              Button('WiFi信息')
                .fontSize(12)
                .height(32)
                .backgroundColor('#E8F5E8')
                .fontColor('#388E3C')
                .onClick(() => {
                  this.setPresetContent('WIFI:T:WPA;S:MyWiFi;P:password123;;')
                })

              Button('联系方式')
                .fontSize(12)
                .height(32)
                .backgroundColor('#FFF3E0')
                .fontColor('#F57C00')
                .onClick(() => {
                  this.setPresetContent('BEGIN:VCARD\nVERSION:3.0\nFN:张三\nTEL:13800138000\nEMAIL:zhangsan@example.com\nEND:VCARD')
                })

              Button('短信内容')
                .fontSize(12)
                .height(32)
                .backgroundColor('#FCE4EC')
                .fontColor('#C2185B')
                .onClick(() => {
                  this.setPresetContent('SMSTO:13800138000:Hello World!')
                })

              Button('邮箱地址')
                .fontSize(12)
                .height(32)
                .backgroundColor('#F3E5F5')
                .fontColor('#7B1FA2')
                .onClick(() => {
                  this.setPresetContent('mailto:example@email.com?subject=Hello&body=Message content')
                })

              Button('地理位置')
                .fontSize(12)
                .height(32)
                .backgroundColor('#E0F2F1')
                .fontColor('#00695C')
                .onClick(() => {
                  this.setPresetContent('geo:39.9042,116.4074')
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 二维码设置
          Column({ space: 12 }) {
            Row() {
              Text('二维码设置')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            // 尺寸设置
            Row() {
              Text('尺寸:')
                .fontSize(14)
                .fontColor('#666666')
                .width(60)

              Slider({
                value: this.qrSize,
                min: 100,
                max: 300,
                step: 10
              })
                .layoutWeight(1)
                .trackColor('#E5E5E5')
                .selectedColor('#007DFF')
                .onChange((value: number) => {
                  this.qrSize = value
                })

              Text(`${this.qrSize}px`)
                .fontSize(14)
                .fontColor('#666666')
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            // 颜色设置
            Row() {
              Column({ space: 8 }) {
                Text('前景色')
                  .fontSize(14)
                  .fontColor('#666666')
                
                Row({ space: 8 }) {
                  Column()
                    .width(30)
                    .height(30)
                    .backgroundColor(this.qrForegroundColor)
                    .borderRadius(4)
                    .border({ width: 1, color: '#E5E5E5' })
                  
                  TextInput({ text: this.qrForegroundColor })
                    .layoutWeight(1)
                    .height(30)
                    .fontSize(12)
                    .borderRadius(4)
                    .border({ width: 1, color: '#E5E5E5' })
                    .onChange((value: string) => {
                      this.qrForegroundColor = value
                    })
                }
                .width('100%')
              }
              .layoutWeight(1)

              Column({ space: 8 }) {
                Text('背景色')
                  .fontSize(14)
                  .fontColor('#666666')
                
                Row() {
                  Column()
                    .width(30)
                    .height(30)
                    .backgroundColor(this.qrBackgroundColor)
                    .borderRadius(4)
                    .border({ width: 1, color: '#E5E5E5' })
                  
                  TextInput({ text: this.qrBackgroundColor })
                    .layoutWeight(1)
                    .height(30)
                    .fontSize(12)
                    .borderRadius(4)
                    .border({ width: 1, color: '#E5E5E5' })
                    .onChange((value: string) => {
                      this.qrBackgroundColor = value
                    })
                }
                .width('100%')
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 操作按钮
          Row({ space: 12 }) {
            Button('生成二维码')
              .fontSize(14)
              .height(44)
              .layoutWeight(1)
              .backgroundColor('#007DFF')
              .fontColor(Color.White)
              .onClick(() => {
                this.generateQRCode()
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 二维码显示区域
          if (this.qrCodeData) {
            Column({ space: 12 }) {
              Row() {
                Text('生成的二维码')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)

              // 二维码显示区域（使用真正的QRCode组件）
              Column() {
                QRCode(this.qrCodeData)
                  .width(this.qrSize)
                  .height(this.qrSize)
                  .color(this.qrForegroundColor)
                  .backgroundColor(this.qrBackgroundColor)
                  .borderRadius(8)
                  .id('qrcode-component')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)

              // 操作按钮
              Row({ space: 12 }) {
                SaveButton(this.saveButtonOptions)
                  .height(36)
                  .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
                    if (result == SaveButtonOnClickResult.SUCCESS) {
                      try {
                        // 准备要保存的文件
                        const fileUri = await this.saveQRCodeWithSecureButton()
                        if (fileUri) {
                          let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
                          let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context)
                          let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest = 
                            photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, fileUri)
                          await phAccessHelper.applyChanges(assetChangeRequest)
                          this.errorMessage = '二维码已成功保存到相册'
                          console.info('createAsset successfully, uri: ' + assetChangeRequest.getAsset().uri)
                        }
                      } catch (err) {
                        const error = err as BusinessError
                        console.error(`create asset failed with error: ${error.code}, ${error.message}`)
                        this.errorMessage = `保存失败: ${error.message}`
                      }
                    } else {
                      console.error('SaveButtonOnClickResult create asset failed')
                      this.errorMessage = '用户取消了保存操作'
                    }
                  })
              }
              .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .alignItems(HorizontalAlign.Start)
          }

          // 使用说明
          Column({ space: 8 }) {
            Row() {
              Text('使用说明')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Column({ space: 4 }) {
              Text('• 支持文本、网址、WiFi信息、联系方式等内容')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 内容长度建议控制在500字符以内')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 可自定义二维码尺寸和颜色')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 生成后可保存或分享二维码图片')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 错误信息或状态显示
          if (this.errorMessage) {
            Row() {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor(this.errorMessage.includes('成功') ? '#28A745' : '#DC3545')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(this.errorMessage.includes('成功') ? '#D4EDDA' : '#F8D7DA')
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