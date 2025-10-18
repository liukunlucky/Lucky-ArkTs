/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { ColorPickerUtil } from '../utils/ColorPickerUtil'

interface ComponentProperty {
  name: string
  description: string
  type: string
  defaultValue: string
  options?: string[]
}

interface ComponentItem {
  id: string
  name: string
  description: string
  icon: string
  category: string
  properties?: ComponentProperty[]
}

interface SliderParams {
  min: number
  max: number
  step: number
}

interface ComponentParams {
  componentId: string
  componentName: string
}

interface TimeTable {
  title: string;
  projects: string[];
}

interface AlertDialogButton {
  value: string
  action: () => void
}

interface AlertDialogOptions {
  title: string
  message: string
  alignment: DialogAlignment
  primaryButton: AlertDialogButton
  secondaryButton?: AlertDialogButton
}

@Entry
@Component
struct ComponentPreviewPage {
  @State componentId: string = ''
  @State componentName: string = ''
  @State currentComponent: ComponentItem | null = null
  @State propertyValues: Record<string, string | number | boolean> = {}
  
  // List组件的示例数据
  @State listData: TimeTable[] = [
    {
      title: 'ONE',
      projects: ['item 1', 'item 2', 'item 3', 'item 4']
    },
    {
      title: 'TWO', 
      projects: ['item 5', 'item 6', 'item 7', 'item 8']
    },
    {
      title: 'THREE',
      projects: ['item 9', 'item 10', 'item 11', 'item 12']
    },
    {
      title: 'FOUR',
      projects: ['item 13', 'item 14', 'item 15', 'item 16']
    }
  ]
  
  // 组件列表数据（从WorkshopPage复制）
  private componentList: ComponentItem[] = [
    {
      id: 'text',
      name: 'Text 文本',
      description: '用于显示文本内容的基础组件',
      icon: 'text',
      category: '基础组件',
      properties: [
        {
          name: 'fontWeight',
          description: '字体粗细',
          type: 'FontWeight',
          defaultValue: 'FontWeight.Normal',
          options: ['FontWeight.Lighter', 'FontWeight.Normal', 'FontWeight.Regular', 'FontWeight.Medium', 'FontWeight.Bold', 'FontWeight.Bolder']
        },
        {
          name: 'fontSize',
          description: '字体大小',
          type: 'number | string | Resource',
          defaultValue: '16'
        },
        {
          name: 'fontColor',
          description: '字体颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.Black'
        },
        {
          name: 'opacity',
          description: '透明度',
          type: 'number',
          defaultValue: '1.0'
        },
        {
          name: 'letterSpacing',
          description: '字符间距',
          type: 'number | string',
          defaultValue: '0'
        },
        {
          name: 'textShadow',
          description: '文字阴影',
          type: 'ShadowOptions | Array<ShadowOptions>',
          defaultValue: 'undefined'
        }
      ]
    },
    {
      id: 'button',
      name: 'Button 按钮',
      description: '用户交互的按钮组件',
      icon: 'button',
      category: '基础组件',
      properties: [
        {
          name: 'buttonStyle',
          description: '按钮样式模式',
          type: 'ButtonStyleMode',
          defaultValue: 'ButtonStyleMode.EMPHASIZED',
          options: ['ButtonStyleMode.NORMAL', 'ButtonStyleMode.EMPHASIZED', 'ButtonStyleMode.TEXTUAL']
        },
        {
          name: 'buttonType',
          description: '按钮边缘形状',
          type: 'ButtonType',
          defaultValue: 'ButtonType.Capsule',
          options: ['ButtonType.Capsule', 'ButtonType.Normal']
        },
        {
          name: 'controlSize',
          description: '按钮尺寸',
          type: 'ControlSize',
          defaultValue: 'ControlSize.SMALL',
          options: ['ControlSize.SMALL', 'ControlSize.NORMAL']
        },
        {
          name: 'backgroundColor',
          description: '背景颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.Blue'
        }
      ]
    },
    {
      id: 'toggle',
      name: 'Toggle 开关',
      description: '开关切换组件',
      icon: 'toggle',
      category: '基础组件',
      properties: [
        {
          name: 'toggleType',
          description: '开关类型',
          type: 'ToggleType',
          defaultValue: 'ToggleType.Switch',
          options: ['ToggleType.Switch', 'ToggleType.Checkbox']
        },
        {
          name: 'isOn',
          description: '开关状态',
          type: 'boolean',
          defaultValue: 'false'
        },
        {
          name: 'backgroundColor',
          description: '背景颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.Gray'
        }
      ]
    },
    {
      id: 'stack',
      name: 'Stack 层叠',
      description: '子组件按照顺序依次入栈的布局容器',
      icon: 'stack',
      category: '布局组件',
      properties: [
        {
          name: 'alignContent',
          description: '对齐方式',
          type: 'Alignment',
          defaultValue: 'Alignment.Center',
          options: ['Alignment.Top', 'Alignment.TopStart', 'Alignment.TopEnd', 'Alignment.Start', 'Alignment.Center', 'Alignment.End', 'Alignment.BottomStart', 'Alignment.BottomEnd', 'Alignment.Bottom']
        }
      ]
    },
    {
      id: 'list',
      name: 'List 列表',
      description: '列表容器，用于展示一系列数据项',
      icon: 'list',
      category: '容器组件',
      properties: [
        {
          name: 'lanes',
          description: '列数',
          type: 'number',
          defaultValue: '1'
        },
        {
          name: 'space',
          description: '自定义间距',
          type: 'slider',
          defaultValue: '8'
        },
        {
          name: 'sticky',
          description: '是否吸顶',
          type: 'boolean',
          defaultValue: 'true'
        },
        {
          name: 'edgeEffect',
          description: '滑动效果',
          type: 'EdgeEffect',
          defaultValue: 'EdgeEffect.Spring',
          options: ['EdgeEffect.Spring', 'EdgeEffect.Fade', 'EdgeEffect.None']
        },
        {
          name: 'scrollBar',
          description: '滚动条状态',
          type: 'BarState',
          defaultValue: 'BarState.Auto',
          options: ['BarState.Auto', 'BarState.On', 'BarState.Off']
        }
      ]
    },
    {
      id: 'alertdialog',
      name: 'AlertDialog 警告弹窗',
      description: '警告对话框组件',
      icon: 'alert',
      category: '弹窗组件',
      properties: [
        {
          name: 'title',
          description: '弹窗标题',
          type: 'string',
          defaultValue: '提示'
        },
        {
          name: 'message',
          description: '弹窗内容',
          type: 'string',
          defaultValue: '这是一个警告弹窗'
        },
        {
          name: 'primaryButton',
          description: '确定按钮文本',
          type: 'string',
          defaultValue: '确定'
        },
        {
          name: 'secondaryButton',
          description: '取消按钮文本',
          type: 'string',
          defaultValue: '取消'
        },
        {
          name: 'showCancel',
          description: '显示取消按钮',
          type: 'boolean',
          defaultValue: 'true'
        },
        {
          name: 'alignment',
          description: '弹窗对齐方式',
          type: 'DialogAlignment',
          defaultValue: 'DialogAlignment.Center',
          options: ['DialogAlignment.Top', 'DialogAlignment.Center', 'DialogAlignment.Bottom', 'DialogAlignment.TopStart', 'DialogAlignment.TopEnd', 'DialogAlignment.CenterStart', 'DialogAlignment.CenterEnd', 'DialogAlignment.BottomStart', 'DialogAlignment.BottomEnd']
        }

      ]
    }
  ]
  
  aboutToAppear() {
    const params = router.getParams() as ComponentParams
    if (params) {
      this.componentId = params.componentId || ''
      this.componentName = params.componentName || ''
    }
    
    // 查找当前组件
    this.currentComponent = this.componentList.find(item => item.id === this.componentId) || null
    
    // 初始化属性值
    if (this.currentComponent) {
      this.propertyValues = {}
      this.currentComponent.properties?.forEach(prop => {
        this.propertyValues[prop.name] = this.parseDefaultValue(prop?.defaultValue || '', prop.type)
      })
    }
  }
  
  // 解析默认值
  private parseDefaultValue(defaultValue: string, type: string): string | number | boolean {
    switch (type) {
      case 'number':
        return Number(defaultValue) || 0
      case 'boolean':
        return defaultValue === 'true'
      case 'ResourceColor':
        return defaultValue
      case 'ButtonStyleMode':
      case 'ButtonType':
      case 'ControlSize':
      case 'ToggleType':
      case 'FontWeight':
      case 'Alignment':
      case 'DialogAlignment':
      case 'Length':
      case 'StickyStyle':
      case 'EdgeEffect':
      case 'BarState':
        // 枚举类型保持原始字符串值
        return defaultValue
      default:
        return defaultValue
    }
  }

  // 枚举值转换方法
  private getButtonStyleMode(value: string): ButtonStyleMode {
    switch (value) {
      case 'ButtonStyleMode.EMPHASIZED':
        return ButtonStyleMode.EMPHASIZED
      case 'ButtonStyleMode.TEXTUAL':
        return ButtonStyleMode.TEXTUAL
      default:
        return ButtonStyleMode.NORMAL
    }
  }

  @Builder
  itemHead(text: string) {
    Text(text)
      .textAlign(TextAlign.Center)
      .fontSize(16)
      .backgroundColor('#007DFF')
      .fontColor('#FFFFFF')
      .width('100%')
      .height(32)
      .margin({ bottom: 8 })
      .borderRadius(4)
  }

  private getButtonType(value: string): ButtonType {
    switch (value) {
      case 'ButtonType.Capsule':
        return ButtonType.Capsule
      case 'ButtonType.Circle':
        return ButtonType.Circle
      default:
        return ButtonType.Normal
    }
  }

  private getControlSize(value: string): ControlSize {
    switch (value) {
      case 'ControlSize.SMALL':
        return ControlSize.SMALL
      default:
        return ControlSize.NORMAL
    }
  }

  private getToggleType(value: string): ToggleType {
    switch (value) {
      case 'ToggleType.Checkbox':
        return ToggleType.Checkbox
      case 'ToggleType.Button':
        return ToggleType.Button
      default:
        return ToggleType.Switch
    }
  }

  private getFontWeight(value: string): FontWeight {
    switch (value) {
      case 'FontWeight.Lighter':
        return FontWeight.Lighter
      case 'FontWeight.Regular':
        return FontWeight.Regular
      case 'FontWeight.Medium':
        return FontWeight.Medium
      case 'FontWeight.Bold':
        return FontWeight.Bold
      case 'FontWeight.Bolder':
        return FontWeight.Bolder
      default:
        return FontWeight.Normal
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button() {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(24)
            .height(24)
            .fillColor('#000000')
        }
        .width(40)
        .height(40)
        .backgroundColor('transparent')
        .onClick(() => {
          router.back()
        })

        Text(this.componentName)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .margin({ left: 16 })

        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 预览区域
          Column() {
            Text('预览区域')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            // 预览容器
            Column() {
              this.renderComponent()
            }
            .width('100%')
            .height(200)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .border({ width: 1, color: '#E5E7EB' })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F9FAFB')

          // 属性调整区域
          Column() {
            Text('属性调整')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            this.renderAttributePanel()
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          // 代码预览区域
          Column() {
            Text('代码预览')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            Column() {
              Text(this.generateCode())
                .fontSize(12)
                .fontFamily('monospace')
                .fontColor('#374151')
                .backgroundColor('#F3F4F6')
                .padding(12)
                .borderRadius(8)
                .width('100%')
            }
            .width('100%')
            .backgroundColor('#F9FAFB')
            .borderRadius(8)
            .padding(8)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder renderComponent() {
    if (this.componentId === 'text') {
      Text('Hello ArkTS')
        .fontSize(Number(this.propertyValues['fontSize']) || 16)
        .fontWeight(this.getFontWeight(this.propertyValues['fontWeight'] as string))
        .fontColor(String(this.propertyValues['fontColor']) || 'Color.Black')
        .opacity(Number(this.propertyValues['opacity']) || 1.0)
        .letterSpacing(Number(this.propertyValues['letterSpacing']) || 0)
        .textShadow({
          radius: Number(this.propertyValues['textShadow']) || 0,
          color: Color.Gray,
          offsetX: 1,
          offsetY: 1
        })
    } else if (this.componentId === 'button') {
      Button('点击按钮')
        .buttonStyle(this.getButtonStyleMode(this.propertyValues['buttonStyle'] as string))
        .type(this.getButtonType(this.propertyValues['buttonType'] as string))
        .controlSize(this.getControlSize(this.propertyValues['controlSize'] as string))
        .backgroundColor(String(this.propertyValues['backgroundColor']) || 'Color.Blue')
        .fontColor(this.getButtonStyleMode(this.propertyValues['buttonStyle'] as string) === ButtonStyleMode.TEXTUAL ? '#007DFF' : '#FFFFFF')
        .enabled(Boolean(this.propertyValues['enabled']) !== false)
        .onClick(() => {
          promptAction.showToast({ message: '按钮被点击了！' })
        })
    } else if (this.componentId === 'toggle') {
      Toggle({ 
        type: this.getToggleType(this.propertyValues['toggleType'] as string), 
        isOn: Boolean(this.propertyValues['isOn']) || false 
      })
        .backgroundColor(String(this.propertyValues['backgroundColor']) || 'Color.Gray')
        .selectedColor(String(this.propertyValues['selectedColor']) || 'Color.Blue')
        .switchPointColor(String(this.propertyValues['switchPointColor']) || 'Color.White')
        .onChange((isOn: boolean) => {
          this.propertyValues['isOn'] = isOn
          promptAction.showToast({ message: `开关状态: ${isOn ? '开' : '关'}` })
        })
    } else if (this.componentId === 'stack') {
      Stack({ alignContent: this.getAlignmentValue(String(this.propertyValues['alignContent'])) || Alignment.Center }) {
        // 背景区域 - 显示整个Stack的可用空间
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#F8F9FA')
          .border({ width: 1, color: '#DEE2E6', style: BorderStyle.Solid })
        
        // 前景内容 - 小的彩色方块，用于显示对齐效果
        Column() {
          Text('内容')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .textAlign(TextAlign.Center)
        }
        .width(60)
        .height(40)
        .backgroundColor('#007DFF')
        .borderRadius(4)
        .justifyContent(FlexAlign.Center)
      }
      .width(String(this.propertyValues['width']) || '280px')
      .height(String(this.propertyValues['height']) || '200px')
      .backgroundColor('#FFFFFF')
      .border({ width: 2, color: '#007DFF', style: BorderStyle.Dashed })
      .borderRadius(8)
    } else if (this.componentId === 'list') {
      List({ 
        space: Number(this.propertyValues['space']) || 8
      }) {
        ForEach(this.listData, (item: TimeTable) => {
          ListItemGroup({ 
            header: this.itemHead(item.title) 
          }) {
            ForEach(item.projects, (project: string) => {
              ListItem() {
                Column() {
                  Text(project)
                    .fontSize(14)
                    .fontColor('#333333')
                    .textAlign(TextAlign.Center)
                }
                .width('100%')
                .height('100%')
                .borderRadius(8)
                .border({ width: 1.5, color: '#E5E7EB' })
                .backgroundColor('#FFFFFF')
                .justifyContent(FlexAlign.Center)
              }
              .width('100%')
              .height(60)
              .aspectRatio(1.5)
            }, (project: string) => project)
          }
        }, (item: TimeTable) => item.title)
      }
      .width('100%')
      .height(300)
      .backgroundColor('#F5F5F5')
      .lanes(Number(this.propertyValues['lanes']) || 1)
      .listDirection(this.propertyValues['listDirection'] as Axis || Axis.Vertical)
      .sticky((this.propertyValues['sticky'] !== undefined ? Boolean(this.propertyValues['sticky']) : true) ? StickyStyle.Header : StickyStyle.None)
      .edgeEffect(this.propertyValues['edgeEffect'] as EdgeEffect || EdgeEffect.Spring)
      .scrollBar(this.propertyValues['scrollBar'] as BarState || BarState.Auto)
    } else if (this.componentId === 'alertdialog') {
      Button('显示弹窗')
        .width(120)
        .height(40)
        .backgroundColor('#007DFF')
        .fontColor('#FFFFFF')
        .borderRadius(8)
        .onClick(() => {
          const showCancel = this.propertyValues['showCancel'] !== undefined ? Boolean(this.propertyValues['showCancel']) : true
          const title = String(this.propertyValues['title']) || '提示'
          const message = String(this.propertyValues['message']) || '这是一个警告弹窗'
          const alignment = this.getDialogAlignmentValue(String(this.propertyValues['alignment']))
          const primaryButtonText = String(this.propertyValues['primaryButton']) || '确定'
          const secondaryButtonText = String(this.propertyValues['secondaryButton']) || '取消'
          
          if (showCancel) {
            AlertDialog.show({
              title: title,
              message: message,
              alignment: alignment,
              primaryButton: {
                value: primaryButtonText,
                action: () => {
                  console.log('点击了确定按钮')
                }
              },
              secondaryButton: {
                value: secondaryButtonText,
                action: () => {
                  console.log('点击了取消按钮')
                }
              }
            })
          } else {
            AlertDialog.show({
              title: title,
              message: message,
              alignment: alignment,
              primaryButton: {
                value: primaryButtonText,
                action: () => {
                  console.log('点击了确定按钮')
                }
              }
            })
          }
        })
    }
  }

  @Builder
  renderAttributePanel() {
    if (this.currentComponent && this.currentComponent.properties) {
      Column({ space: 16 }) {
        ForEach(this.currentComponent.properties, (property: ComponentProperty) => {
          this.renderPropertyControl(property)
        })
      }
      .width('100%')
      .padding(16)
    }
  }
  
  @Builder
  renderPropertyControl(property: ComponentProperty) {
    Column({ space: 8 }) {
      // 属性标题
      Row() {
        Text(property.description)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
        Blank()
        Text(`${this.propertyValues[property.name] || property.defaultValue}`)
          .fontSize(12)
          .fontColor('#6B7280')
      }
      .width('100%')
      
      // 属性控件
      if (property.type === 'number' || property.type === 'slider' || property.name === 'letterSpacing' || property.name === 'textShadow' || property.name === 'fontSize' || property.name === 'opacity') {
        this.renderSlider(property)
      } else if (property.type === 'ResourceColor') {
        this.renderColorSlider(property)
      } else if (property.type === 'boolean') {
        this.renderToggle(property)
      } else if (property.options && property.options.length > 0) {
        this.renderSelect(property)
      } else {
        this.renderTextInput(property)
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F9FAFB')
    .borderRadius(8)
  }
  
  // 获取滑块参数的辅助方法
  private getSliderParams(propertyName: string): SliderParams {
    switch (propertyName) {
      case 'fontSize':
        return { min: 8, max: 48, step: 1 }
      case 'opacity':
        return { min: 0, max: 1, step: 0.1 }
      case 'letterSpacing':
        return { min: -5, max: 10, step: 0.5 }
      case 'textShadow':
        return { min: 0, max: 20, step: 1 }
      case 'width':
      case 'height':
        return { min: 50, max: 400, step: 10 }
      case 'padding':
        return { min: 0, max: 50, step: 2 }
      case 'space':
        return { min: 0, max: 30, step: 2 }
      case 'lanes':
        return { min: 1, max: 5, step: 1 }
      default:
        return { min: 0, max: 100, step: 1 }
    }
  }

  @Builder
  renderSlider(property: ComponentProperty) {
    Slider({
      value: Number(this.propertyValues[property.name]) || Number(property.defaultValue) || this.getSliderParams(property.name).min,
      min: this.getSliderParams(property.name).min,
      max: this.getSliderParams(property.name).max,
      step: this.getSliderParams(property.name).step,
      style: SliderStyle.OutSet
    })
      .width('100%')
      .trackColor('#E5E7EB')
      .selectedColor('#3B82F6')
      .blockColor('#FFFFFF')
      .onChange((value: number) => {
        this.propertyValues[property.name] = value
      })
  }
  
  @Builder
  renderColorSlider(property: ComponentProperty) {
    Column() {
      Text(property.description)
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 8 })
      
      Text(String(this.propertyValues[property.name]) || property.defaultValue)
        .fontSize(12)
        .fontColor('#999999')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 8 })
        
      Slider({
        value: ColorPickerUtil.getColorFromRgb(ColorPickerUtil.hexToRgba(String(this.propertyValues[property.name]) || property.defaultValue)),
        min: 0,
        max: 100,
        step: 1,
        style: SliderStyle.InSet
      })
        .width('100%')
        .selectedColor(Color.Transparent)
        .trackColor(new LinearGradient([
          { color: ColorPickerUtil.setRgba(255, 0, 0, 1.00), offset: 0 },
          { color: ColorPickerUtil.setRgba(255, 255, 0, 1.00), offset: ColorPickerUtil.SEGMENT_1 },
          { color: ColorPickerUtil.setRgba(0, 255, 0, 1.00), offset: ColorPickerUtil.SEGMENT_2 },
          { color: ColorPickerUtil.setRgba(0, 255, 255, 1.00), offset: ColorPickerUtil.SEGMENT_3 },
          { color: ColorPickerUtil.setRgba(0, 0, 255, 1.00), offset: ColorPickerUtil.SEGMENT_4 },
          { color: ColorPickerUtil.setRgba(255, 0, 255, 1.00), offset: ColorPickerUtil.SEGMENT_5 },
          { color: ColorPickerUtil.setRgba(255, 0, 0, 1.00), offset: ColorPickerUtil.SEGMENT_6 },
        ]))
        .blockBorderColor(Color.White)
        .blockBorderWidth(2)
        .blockSize({ width: 20, height: 20 })
        .blockColor(Color.Transparent)
        .trackThickness(16)
        .onChange((value: number) => {
          const rgbaColor = ColorPickerUtil.getBlockColor(value);
          this.propertyValues[property.name] = ColorPickerUtil.rgbaToHex(rgbaColor);
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
  
  @Builder
  renderToggle(property: ComponentProperty) {
    Toggle({ 
      type: ToggleType.Switch, 
      isOn: this.propertyValues[property.name] !== undefined ? Boolean(this.propertyValues[property.name]) : property.defaultValue === 'true'
    })
      .selectedColor('#3B82F6')
      .onChange((isOn: boolean) => {
        this.propertyValues[property.name] = isOn
      })
  }
  
  @Builder
  renderSelect(property: ComponentProperty) {
    Column({ space: 4 }) {
      ForEach(property.options || [], (option: string, index: number) => {
        Row() {
          Radio({ value: option, group: property.name })
            .checked(this.propertyValues[property.name] === option || 
                    (this.propertyValues[property.name] === undefined && option === property.defaultValue))
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.propertyValues[property.name] = option
              }
            })
          Text(option.replace(/^[A-Za-z]+\./, ''))
            .fontSize(12)
            .fontColor('#374151')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(32)
      })
    }
  }
  
  @Builder
  renderTextInput(property: ComponentProperty) {
    TextInput({ 
      placeholder: property.defaultValue,
      text: String(this.propertyValues[property.name]) || property.defaultValue 
    })
      .width('100%')
      .height(36)
      .fontSize(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(4)
      .onChange((value: string) => {
          this.propertyValues[property.name] = value
        })
  }

  private getAlignmentValue(alignmentStr: string): Alignment {
    switch (alignmentStr) {
      case 'Alignment.Top':
        return Alignment.Top
      case 'Alignment.TopStart':
        return Alignment.TopStart
      case 'Alignment.TopEnd':
        return Alignment.TopEnd
      case 'Alignment.Start':
        return Alignment.Start
      case 'Alignment.Center':
        return Alignment.Center
      case 'Alignment.End':
        return Alignment.End
      case 'Alignment.BottomStart':
        return Alignment.BottomStart
      case 'Alignment.Bottom':
        return Alignment.Bottom
      case 'Alignment.BottomEnd':
        return Alignment.BottomEnd
      default:
        return Alignment.Center
    }
  }

  private getDialogAlignmentValue(alignmentStr: string): DialogAlignment {
    switch (alignmentStr) {
      case 'DialogAlignment.Top':
        return DialogAlignment.Top
      case 'DialogAlignment.Center':
        return DialogAlignment.Center
      case 'DialogAlignment.Bottom':
        return DialogAlignment.Bottom
      case 'DialogAlignment.TopStart':
        return DialogAlignment.TopStart
      case 'DialogAlignment.TopEnd':
        return DialogAlignment.TopEnd
      case 'DialogAlignment.CenterStart':
        return DialogAlignment.CenterStart
      case 'DialogAlignment.CenterEnd':
        return DialogAlignment.CenterEnd
      case 'DialogAlignment.BottomStart':
        return DialogAlignment.BottomStart
      case 'DialogAlignment.BottomEnd':
        return DialogAlignment.BottomEnd
      default:
        return DialogAlignment.Center
    }
  }

  private generateCode(): string {
    if (!this.currentComponent) return '// 暂无代码预览'
    
    let code = ''
    const safePropertyValues = this.propertyValues || {}
    
    switch (this.componentId) {
      case 'text':
        code = `Text('${safePropertyValues['text'] || '文本内容'}')`
        break
      case 'button':
        code = `Button('${safePropertyValues['text'] || '按钮'}')`
        break
      case 'toggle':
        const toggleType = safePropertyValues['toggleType'] || 'Switch'
        const isOn = safePropertyValues['isOn'] || false
        code = `Toggle({ type: ToggleType.${toggleType}, isOn: ${isOn} })`
        break
      case 'stack':
        const alignContent = String(safePropertyValues['alignContent']) || 'Alignment.Center'
        code = `Stack({ alignContent: ${alignContent} }) {
  // 背景区域 - 显示整个Stack的可用空间
  Column()
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
    .border({ width: 1, color: '#DEE2E6', style: BorderStyle.Solid })
  
  // 前景内容 - 小的彩色方块，用于显示对齐效果
  Column() {
    Text('内容')
      .fontSize(12)
      .fontColor('#FFFFFF')
      .textAlign(TextAlign.Center)
  }
  .width(60)
  .height(40)
  .backgroundColor('#007DFF')
  .borderRadius(4)
  .justifyContent(FlexAlign.Center)
}
.width('280px')
.height('200px')
.backgroundColor('#FFFFFF')
.border({ width: 2, color: '#007DFF', style: BorderStyle.Dashed })
.borderRadius(8)`
        break
      case 'list':
        const lanes = Number(safePropertyValues['lanes']) || 1
        const space = Number(safePropertyValues['space']) || 8
        const sticky = safePropertyValues['sticky'] !== undefined ? Boolean(safePropertyValues['sticky']) : true
        const edgeEffect = String(safePropertyValues['edgeEffect']) || 'EdgeEffect.Spring'
        const listDirection = String(safePropertyValues['listDirection']) || 'Axis.Vertical'
        const scrollBar = String(safePropertyValues['scrollBar']) || 'BarState.Auto'
        
        code = `interface TimeTable {
  title: string;
  projects: string[];
}

@State listData: TimeTable[] = [
  {
    title: 'ONE',
    projects: ['item 1', 'item 2', 'item 3', 'item 4']
  },
  {
    title: 'TWO', 
    projects: ['item 5', 'item 6', 'item 7', 'item 8']
  },
  {
    title: 'THREE',
    projects: ['item 9', 'item 10', 'item 11', 'item 12']
  },
  {
    title: 'FOUR',
    projects: ['item 13', 'item 14', 'item 15', 'item 16']
  }
]

@Builder
itemHead(text: string) {
  Text(text)
    .textAlign(TextAlign.Center)
    .fontSize(16)
    .backgroundColor('#007DFF')
    .fontColor('#FFFFFF')
    .width('100%')
    .height(32)
    .margin({ bottom: 8 })
    .borderRadius(4)
}

List({ space: ${space} }) {
  ForEach(this.listData, (item: TimeTable) => {
    ListItemGroup({ 
      header: this.itemHead(item.title) 
    }) {
      ForEach(item.projects, (project: string) => {
        ListItem() {
          Column() {
            Text(project)
              .fontSize(14)
              .fontColor('#333333')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('100%')
          .borderRadius(8)
          .border({ width: 1.5, color: '#E5E7EB' })
          .backgroundColor('#FFFFFF')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height(60)
        .aspectRatio(1.5)
      }, (project: string) => project)
    }
  }, (item: TimeTable) => item.title)
}
.width('100%')
.height(300)
.backgroundColor('#F5F5F5')
.lanes(${lanes})
.listDirection(${listDirection})
.sticky(${sticky ? 'StickyStyle.Header' : 'StickyStyle.None'})
.edgeEffect(${edgeEffect})
.scrollBar(${scrollBar})`
        break
      case 'alertdialog':
        const showCancel = this.propertyValues['showCancel'] !== undefined ? Boolean(this.propertyValues['showCancel']) : true
        const title = String(this.propertyValues['title']) || '提示'
        const message = String(this.propertyValues['message']) || '这是一个警告弹窗'
        const primaryButton = String(this.propertyValues['primaryButton']) || '确定'
        const secondaryButton = String(this.propertyValues['secondaryButton']) || '取消'
        const alignment = String(this.propertyValues['alignment']) || 'DialogAlignment.Center'
        
        let dialogCode = `Button('显示弹窗')
  .onClick(() => {
    AlertDialog.show({
      title: '${title}',
      message: '${message}',
      alignment: ${alignment},
      primaryButton: {
        value: '${primaryButton}',
        action: () => {
          console.log('点击了确定')
        }
      }`
        
        if (showCancel) {
          dialogCode += `,
      secondaryButton: {
        value: '${secondaryButton}',
        action: () => {
          console.log('点击了取消')
        }
      }`
        }
        
        dialogCode += `
    })
  })`
        code = dialogCode
        break
      default:
        return '// 暂无代码预览'
    }
    
    return code
  }
}