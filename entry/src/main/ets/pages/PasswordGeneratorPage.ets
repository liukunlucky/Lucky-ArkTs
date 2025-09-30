import router from '@ohos.router'
import pasteboard from '@ohos.pasteboard'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct PasswordGeneratorPage {
  @State generatedPassword: string = ''
  @State passwordLength: number = 12
  @State includeUppercase: boolean = true
  @State includeLowercase: boolean = true
  @State includeNumbers: boolean = true
  @State includeSymbols: boolean = false
  @State excludeSimilar: boolean = false
  @State passwordStrength: string = ''
  @State strengthColor: string = '#999999'
  @State passwordHistory: string[] = []

  // 字符集定义
  private uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  private lowercaseChars = 'abcdefghijklmnopqrstuvwxyz'
  private numberChars = '0123456789'
  private symbolChars = '!@#$%^&*()_+-=[]{}|;:,.<>?'
  private similarChars = 'il1Lo0O'

  // 生成密码
  generatePassword() {
    try {
      let charset = ''
      
      if (this.includeUppercase) charset += this.uppercaseChars
      if (this.includeLowercase) charset += this.lowercaseChars
      if (this.includeNumbers) charset += this.numberChars
      if (this.includeSymbols) charset += this.symbolChars

      if (charset === '') {
        this.generatedPassword = '请至少选择一种字符类型'
        return
      }

      // 排除相似字符
      if (this.excludeSimilar) {
        for (let char of this.similarChars) {
          charset = charset.replace(new RegExp(char, 'g'), '')
        }
      }

      let password = ''
      
      // 确保每种选中的字符类型至少包含一个字符
      if (this.includeUppercase && this.uppercaseChars.length > 0) {
        let chars = this.excludeSimilar ? 
          this.uppercaseChars.replace(/[il1Lo0O]/g, '') : this.uppercaseChars
        if (chars.length > 0) {
          password += chars.charAt(Math.floor(Math.random() * chars.length))
        }
      }
      
      if (this.includeLowercase && this.lowercaseChars.length > 0) {
        let chars = this.excludeSimilar ? 
          this.lowercaseChars.replace(/[il1Lo0O]/g, '') : this.lowercaseChars
        if (chars.length > 0) {
          password += chars.charAt(Math.floor(Math.random() * chars.length))
        }
      }
      
      if (this.includeNumbers && this.numberChars.length > 0) {
        let chars = this.excludeSimilar ? 
          this.numberChars.replace(/[il1Lo0O]/g, '') : this.numberChars
        if (chars.length > 0) {
          password += chars.charAt(Math.floor(Math.random() * chars.length))
        }
      }
      
      if (this.includeSymbols && this.symbolChars.length > 0) {
        password += this.symbolChars.charAt(Math.floor(Math.random() * this.symbolChars.length))
      }

      // 填充剩余长度
      for (let i = password.length; i < this.passwordLength; i++) {
        password += charset.charAt(Math.floor(Math.random() * charset.length))
      }

      // 打乱密码字符顺序
      password = password.split('').sort(() => Math.random() - 0.5).join('')

      this.generatedPassword = password
      this.calculateStrength(password)
      
      // 添加到历史记录
      if (this.passwordHistory.length >= 10) {
        this.passwordHistory.shift()
      }
      this.passwordHistory.push(password)
      
    } catch (error) {
      this.generatedPassword = `生成失败: ${error.message}`
    }
  }

  // 计算密码强度
  calculateStrength(password: string) {
    let score = 0
    
    // 长度评分
    if (password.length >= 8) score += 1
    if (password.length >= 12) score += 1
    if (password.length >= 16) score += 1
    
    // 字符类型评分
    if (/[a-z]/.test(password)) score += 1
    if (/[A-Z]/.test(password)) score += 1
    if (/[0-9]/.test(password)) score += 1
    if (/[^a-zA-Z0-9]/.test(password)) score += 1
    
    // 复杂度评分
    if (password.length >= 10 && /[a-z]/.test(password) && /[A-Z]/.test(password) && 
        /[0-9]/.test(password) && /[^a-zA-Z0-9]/.test(password)) {
      score += 1
    }

    if (score <= 2) {
      this.passwordStrength = '弱'
      this.strengthColor = '#DC3545'
    } else if (score <= 5) {
      this.passwordStrength = '中等'
      this.strengthColor = '#FFC107'
    } else {
      this.passwordStrength = '强'
      this.strengthColor = '#28A745'
    }
  }

  // 复制密码到剪贴板
  async copyPassword(password: string) {
    // 在实际应用中，这里应该调用系统剪贴板API
    // 这里只是模拟
    try {
      const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, password);
      const systemPasteboard = pasteboard.getSystemPasteboard();
      await systemPasteboard.setData(pasteData);
      // 显示成功提示
      promptAction.showToast({
        message: '代码已复制到剪贴板',
        duration: 2000
      });
      // 这里可以添加提示消息
      console.info('密码已复制到剪贴板');
    } catch (error) {
      console.error('复制失败:', error);
    }
    console.log('复制密码:', password)
  }

  // 清空历史记录
  clearHistory() {
    this.passwordHistory = []
  }

  build() {
    Column() {
      // 导航栏
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

        Text('密码生成工具')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column({ space: 20 }) {
          // 密码显示区域
          Column({ space: 12 }) {
            Row() {
              Text('生成的密码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              
              if (this.passwordStrength) {
                Text(`强度: ${this.passwordStrength}`)
                  .fontSize(12)
                  .fontColor(this.strengthColor)
                  .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                  .backgroundColor(this.strengthColor + '20')
                  .borderRadius(4)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)

            Row() {
              TextArea({ 
                text: this.generatedPassword,
                placeholder: '点击"生成密码"按钮生成新密码'
              })
                .layoutWeight(1)
                .height(80)
                .fontSize(14)
                .borderRadius(8)
                .border({ width: 1, color: '#E5E5E5' })
                .enabled(false)

              Button() {
                Image($r('sys.media.ohos_ic_public_copy'))
                  .width(20)
                  .height(20)
                  .fillColor(Color.White)
              }
              .width(40)
              .height(40)
              .backgroundColor('#007DFF')
              .borderRadius(8)
              .margin({ left: 8 })
              .onClick(() => {
                if (this.generatedPassword) {
                  this.copyPassword(this.generatedPassword)
                }
              })
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 密码设置
          Column({ space: 16 }) {
            Row() {
              Text('密码设置')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            // 密码长度
            Row() {
              Text('密码长度:')
                .fontSize(14)
                .fontColor('#666666')
                .width(80)

              Slider({
                value: this.passwordLength,
                min: 4,
                max: 50,
                step: 1
              })
                .layoutWeight(1)
                .trackColor('#E5E5E5')
                .selectedColor('#007DFF')
                .onChange((value: number) => {
                  this.passwordLength = value
                })

              Text(`${this.passwordLength}`)
                .fontSize(14)
                .fontColor('#666666')
                .width(40)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            // 字符类型选择
            Column({ space: 12 }) {
              Row() {
                Checkbox({ name: 'uppercase', group: 'charTypes' })
                  .select(this.includeUppercase)
                  .onChange((value: boolean) => {
                    this.includeUppercase = value
                  })

                Text('包含大写字母 (A-Z)')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)
                  .margin({ left: 8 })
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Row() {
                Checkbox({ name: 'lowercase', group: 'charTypes' })
                  .select(this.includeLowercase)
                  .onChange((value: boolean) => {
                    this.includeLowercase = value
                  })

                Text('包含小写字母 (a-z)')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)
                  .margin({ left: 8 })
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Row() {
                Checkbox({ name: 'numbers', group: 'charTypes' })
                  .select(this.includeNumbers)
                  .onChange((value: boolean) => {
                    this.includeNumbers = value
                  })

                Text('包含数字 (0-9)')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)
                  .margin({ left: 8 })
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Row() {
                Checkbox({ name: 'symbols', group: 'charTypes' })
                  .select(this.includeSymbols)
                  .onChange((value: boolean) => {
                    this.includeSymbols = value
                  })

                Text('包含特殊符号 (!@#$%^&*)')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)
                  .margin({ left: 8 })
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Row() {
                Checkbox({ name: 'excludeSimilar', group: 'options' })
                  .select(this.excludeSimilar)
                  .onChange((value: boolean) => {
                    this.excludeSimilar = value
                  })

                Text('排除相似字符 (il1Lo0O)')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)
                  .margin({ left: 8 })
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)
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
            Button('生成密码')
              .fontSize(14)
              .height(44)
              .layoutWeight(1)
              .backgroundColor('#007DFF')
              .fontColor(Color.White)
              .onClick(() => {
                this.generatePassword()
              })

            Button('重新生成')
              .fontSize(14)
              .width(100)
              .height(44)
              .backgroundColor('#28A745')
              .fontColor(Color.White)
              .onClick(() => {
                this.generatePassword()
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 快速设置
          Column({ space: 12 }) {
            Row() {
              Text('快速设置')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Flex({ wrap: FlexWrap.Wrap }) {
              Button('简单密码')
                .fontSize(12)
                .height(32)
                .backgroundColor('#E3F2FD')
                .fontColor('#1976D2')
                .onClick(() => {
                  this.passwordLength = 8
                  this.includeUppercase = true
                  this.includeLowercase = true
                  this.includeNumbers = true
                  this.includeSymbols = false
                  this.excludeSimilar = false
                })

              Button('标准密码')
                .fontSize(12)
                .height(32)
                .backgroundColor('#E8F5E8')
                .fontColor('#388E3C')
                .onClick(() => {
                  this.passwordLength = 12
                  this.includeUppercase = true
                  this.includeLowercase = true
                  this.includeNumbers = true
                  this.includeSymbols = true
                  this.excludeSimilar = false
                })

              Button('强密码')
                .fontSize(12)
                .height(32)
                .backgroundColor('#FFF3E0')
                .fontColor('#F57C00')
                .onClick(() => {
                  this.passwordLength = 16
                  this.includeUppercase = true
                  this.includeLowercase = true
                  this.includeNumbers = true
                  this.includeSymbols = true
                  this.excludeSimilar = true
                })

              Button('超强密码')
                .fontSize(12)
                .height(32)
                .backgroundColor('#FCE4EC')
                .fontColor('#C2185B')
                .onClick(() => {
                  this.passwordLength = 24
                  this.includeUppercase = true
                  this.includeLowercase = true
                  this.includeNumbers = true
                  this.includeSymbols = true
                  this.excludeSimilar = true
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 历史记录
          if (this.passwordHistory.length > 0) {
            Column({ space: 12 }) {
              Row() {
                Text('历史记录')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .layoutWeight(1)

                Button('清空')
                  .fontSize(12)
                  .width(60)
                  .height(28)
                  .backgroundColor('#F5F5F5')
                  .fontColor('#666666')
                  .onClick(() => {
                    this.clearHistory()
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)

              Column({ space: 8 }) {
                ForEach(this.passwordHistory.slice().reverse(), (password: string, index: number) => {
                  Row() {
                    Text(password)
                      .fontSize(12)
                      .fontColor('#333333')
                      .layoutWeight(1)
                      .fontFamily('monospace')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Button() {
                      Image($r('sys.media.ohos_ic_public_copy'))
                        .width(16)
                        .height(16)
                        .fillColor('#666666')
                    }
                    .width(32)
                    .height(32)
                    .backgroundColor('#F5F5F5')
                    .borderRadius(4)
                    .onClick(() => {
                      this.copyPassword(password)
                    })
                  }
                  .width('100%')
                  .padding(8)
                  .backgroundColor('#F8F9FA')
                  .borderRadius(6)
                  .alignItems(VerticalAlign.Center)
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

          // 安全提示
          Column({ space: 8 }) {
            Row() {
              Text('安全提示')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Column({ space: 4 }) {
              Text('• 建议密码长度至少12位，包含多种字符类型')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 不要在多个账户使用相同密码')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 定期更换重要账户密码')
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')
              
              Text('• 建议使用密码管理器保存密码')
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