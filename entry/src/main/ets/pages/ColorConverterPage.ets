import router from '@ohos.router'

interface RGBColor {
  r: number
  g: number
  b: number
}

interface HSLColor {
  h: number
  s: number
  l: number
}

@Entry
@Component
struct ColorConverterPage {
  @State hexColor: string = '#FF0000'
  @State rgbR: number = 255
  @State rgbG: number = 0
  @State rgbB: number = 0
  @State hslH: number = 0
  @State hslS: number = 100
  @State hslL: number = 50
  @State errorMessage: string = ''
  @State previewColor: string = '#FF0000'

  // HEX转RGB
  hexToRgb(hex: string): RGBColor | null {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null
  }

  // RGB转HEX
  rgbToHex(r: number, g: number, b: number): string {
    const toHex = (n: number) => {
      const hex = Math.round(Math.max(0, Math.min(255, n))).toString(16)
      return hex.length === 1 ? '0' + hex : hex
    }
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase()
  }

  // RGB转HSL
  rgbToHsl(r: number, g: number, b: number): HSLColor {
    r /= 255
    g /= 255
    b /= 255

    const max = Math.max(r, g, b)
    const min = Math.min(r, g, b)
    let h: number = 0
    let s: number = 0
    const l = (max + min) / 2

    if (max === min) {
      h = s = 0 // achromatic
    } else {
      const d = max - min
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min)

      switch (max) {
        case r: h = (g - b) / d + (g < b ? 6 : 0); break
        case g: h = (b - r) / d + 2; break
        case b: h = (r - g) / d + 4; break
      }
      h /= 6
    }

    return {
      h: Math.round(h * 360),
      s: Math.round(s * 100),
      l: Math.round(l * 100)
    }
  }

  // HSL转RGB
  hslToRgb(h: number, s: number, l: number): RGBColor {
    h /= 360
    s /= 100
    l /= 100

    const hue2rgb = (p: number, q: number, t: number) => {
      if (t < 0) t += 1
      if (t > 1) t -= 1
      if (t < 1/6) return p + (q - p) * 6 * t
      if (t < 1/2) return q
      if (t < 2/3) return p + (q - p) * (2/3 - t) * 6
      return p
    }

    let r: number, g: number, b: number

    if (s === 0) {
      r = g = b = l // achromatic
    } else {
      const q = l < 0.5 ? l * (1 + s) : l + s - l * s
      const p = 2 * l - q
      r = hue2rgb(p, q, h + 1/3)
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, h - 1/3)
    }

    return {
      r: Math.round(r * 255),
      g: Math.round(g * 255),
      b: Math.round(b * 255)
    }
  }

  updateFromHex() {
    try {
      const rgb = this.hexToRgb(this.hexColor)
      if (rgb) {
        this.rgbR = rgb.r
        this.rgbG = rgb.g
        this.rgbB = rgb.b
        
        const hsl = this.rgbToHsl(rgb.r, rgb.g, rgb.b)
        this.hslH = hsl.h
        this.hslS = hsl.s
        this.hslL = hsl.l
        
        this.previewColor = this.hexColor
        this.errorMessage = ''
      } else {
        this.errorMessage = '无效的HEX颜色代码'
      }
    } catch (error) {
      this.errorMessage = `转换错误: ${error.message}`
    }
  }

  updateFromRgb() {
    try {
      this.hexColor = this.rgbToHex(this.rgbR, this.rgbG, this.rgbB)
      
      const hsl = this.rgbToHsl(this.rgbR, this.rgbG, this.rgbB)
      this.hslH = hsl.h
      this.hslS = hsl.s
      this.hslL = hsl.l
      
      this.previewColor = this.hexColor
      this.errorMessage = ''
    } catch (error) {
      this.errorMessage = `转换错误: ${error.message}`
    }
  }

  updateFromHsl() {
    try {
      const rgb = this.hslToRgb(this.hslH, this.hslS, this.hslL)
      this.rgbR = rgb.r
      this.rgbG = rgb.g
      this.rgbB = rgb.b
      
      this.hexColor = this.rgbToHex(rgb.r, rgb.g, rgb.b)
      this.previewColor = this.hexColor
      this.errorMessage = ''
    } catch (error) {
      this.errorMessage = `转换错误: ${error.message}`
    }
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


        Text('颜色代码转换工具')
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
          // 颜色预览区域
          Column({ space: 12 }) {
            Text('颜色预览')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Row() {
              Column()
                .width(120)
                .height(120)
                .backgroundColor(this.previewColor)
                .borderRadius(12)
                .border({ width: 2, color: '#E5E5E5' })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)

            Text(this.previewColor)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Center)

          // HEX颜色输入
          Column({ space: 12 }) {
            Row() {
              Text('HEX 颜色代码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row({ space: 12 }) {
              TextInput({ placeholder: '#FF0000', text: this.hexColor })
                .layoutWeight(1)
                .height(48)
                .fontSize(14)
                .borderRadius(8)
                .border({ width: 1, color: '#E5E5E5' })
                .onChange((value: string) => {
                  this.hexColor = value.toUpperCase()
                })

              Button('转换')
                .width(60)
                .height(48)
                .fontSize(14)
                .backgroundColor('#007DFF')
                .fontColor(Color.White)
                .onClick(() => {
                  this.updateFromHex()
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // RGB颜色输入
          Column({ space: 12 }) {
            Row() {
              Text('RGB 颜色值')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row({ space: 8 }) {
              Column({ space: 4 }) {
                Text('R')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-255', text: this.rgbR.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.rgbR = Math.max(0, Math.min(255, num))
                  })
              }

              Column({ space: 4 }) {
                Text('G')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-255', text: this.rgbG.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.rgbG = Math.max(0, Math.min(255, num))
                  })
              }

              Column({ space: 4 }) {
                Text('B')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-255', text: this.rgbB.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.rgbB = Math.max(0, Math.min(255, num))
                  })
              }

              Button('转换')
                .width(60)
                .height(40)
                .fontSize(14)
                .backgroundColor('#28A745')
                .fontColor(Color.White)
                .onClick(() => {
                  this.updateFromRgb()
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Text(`rgb(${this.rgbR}, ${this.rgbG}, ${this.rgbB})`)
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // HSL颜色输入
          Column({ space: 12 }) {
            Row() {
              Text('HSL 颜色值')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row({ space: 8 }) {
              Column({ space: 4 }) {
                Text('H')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-360', text: this.hslH.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.hslH = Math.max(0, Math.min(360, num))
                  })
              }

              Column({ space: 4 }) {
                Text('S%')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-100', text: this.hslS.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.hslS = Math.max(0, Math.min(100, num))
                  })
              }

              Column({ space: 4 }) {
                Text('L%')
                  .fontSize(12)
                  .fontColor('#666666')
                TextInput({ placeholder: '0-100', text: this.hslL.toString() })
                  .width(60)
                  .height(40)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .borderRadius(6)
                  .border({ width: 1, color: '#E5E5E5' })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value) || 0
                    this.hslL = Math.max(0, Math.min(100, num))
                  })
              }

              Button('转换')
                .width(60)
                .height(40)
                .fontSize(14)
                .backgroundColor('#FFC107')
                .fontColor(Color.White)
                .onClick(() => {
                  this.updateFromHsl()
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Text(`hsl(${this.hslH}, ${this.hslS}%, ${this.hslL}%)`)
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 常用颜色快速选择
          Column({ space: 12 }) {
            Row() {
              Text('常用颜色')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Grid() {
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#FF0000')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#FF0000'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#00FF00')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#00FF00'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#0000FF')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#0000FF'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#FFFF00')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#FFFF00'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#FF00FF')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#FF00FF'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#00FFFF')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#00FFFF'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#000000')
                  .borderRadius(8)
                  .onClick(() => {
                    this.hexColor = '#000000'
                    this.updateFromHex()
                  })
              }
              GridItem() {
                Column()
                  .width(40)
                  .height(40)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(8)
                  .border({ width: 1, color: '#E5E5E5' })
                  .onClick(() => {
                    this.hexColor = '#FFFFFF'
                    this.updateFromHex()
                  })
              }
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
            .rowsGap(8)
            .columnsGap(8)
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 错误信息显示
          if (this.errorMessage) {
            Row() {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor('#DC3545')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#F8D7DA')
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