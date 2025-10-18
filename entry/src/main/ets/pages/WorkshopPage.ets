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

interface ComponentProperty {
  name: string
  description: string
  type: string
  defaultValue?: string
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

@Entry
@Component
struct WorkshopPage {
  @State componentList: ComponentItem[] = [
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
        },
        {
          name: 'enabled',
          description: '是否启用',
          type: 'boolean',
          defaultValue: 'true'
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
          options: ['ToggleType.Switch', 'ToggleType.Checkbox', 'ToggleType.Button']
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
        },
        {
          name: 'selectedColor',
          description: '选中时的颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.Blue'
        },
        {
          name: 'switchPointColor',
          description: '开关滑块颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.White'
        }
      ]
    },
    {
      id: 'stack',
      name: 'Stack 层叠布局',
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
        },
        {
          name: 'width',
          description: '宽度',
          type: 'Length',
          defaultValue: 'auto'
        },
        {
          name: 'height',
          description: '高度',
          type: 'Length',
          defaultValue: 'auto'
        },
        {
          name: 'backgroundColor',
          description: '背景颜色',
          type: 'ResourceColor',
          defaultValue: 'Color.Transparent'
        },
        {
          name: 'padding',
          description: '内边距',
          type: 'Padding | Length',
          defaultValue: '0'
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
          name: 'listDirection',
          description: '列表方向',
          type: 'Axis',
          defaultValue: 'Axis.Vertical',
          options: ['Axis.Vertical', 'Axis.Horizontal']
        },
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
      category: '弹窗组件'
    }
  ]

  @State selectedCategory: string = '全部'
  @State categories: string[] = ['全部', '基础组件', '布局组件', '容器组件', '弹窗组件']
  @State filteredComponents: ComponentItem[] = []

  aboutToAppear() {
    this.updateFilteredComponents()
  }

  updateFilteredComponents() {
    if (this.selectedCategory === '全部') {
      this.filteredComponents = this.componentList
    } else {
      this.filteredComponents = this.componentList.filter(item => item.category === this.selectedCategory)
    }
  }

  getIconResource(iconName: string): Resource {
    switch (iconName) {
      case 'text':
        return $r('app.media.text')
      case 'toggle':
        return $r('app.media.toggle')
      case 'button':
        return $r('app.media.button')
      case 'list':
        return $r('app.media.list')
      case 'alert':
        return $r('app.media.alert_dialog')
      case 'stack':
        return $r('app.media.stack')
      default:
        return $r('app.media.text')
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

        Text('ArkTS代码工坊')
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

      // 分类筛选
      Row() {
        ForEach(this.categories, (category: string) => {
          Text(category)
            .fontSize(14)
            .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#6B7280')
            .backgroundColor(this.selectedCategory === category ? '#6366F1' : 'transparent')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .borderRadius(20)
            .border({
              width: 1,
              color: this.selectedCategory === category ? '#6366F1' : '#E5E7EB'
            })
            .onClick(() => {
              this.selectedCategory = category
              this.updateFilteredComponents()
            })
        })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F9FAFB')

      // 组件列表
      List({ space: 12 }) {
        ForEach(this.filteredComponents, (item: ComponentItem) => {
          ListItem() {
            this.ComponentCard(item)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8, bottom: 16 })
      .backgroundColor('#F9FAFB')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F9FAFB')
  }

  @Builder ComponentCard(item: ComponentItem) {
    Row() {
      // 图标
      Column() {
        Image(this.getIconResource(item.icon))
          .width(32)
          .height(32)
          .fillColor('#6366F1')
      }
      .width(56)
      .height(56)
      .backgroundColor('#EEF2FF')
      .borderRadius(12)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 内容
      Column() {
        Row() {
          Text(item.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Blank()

          Text(item.category)
            .fontSize(12)
            .fontColor('#6366F1')
            .backgroundColor('#EEF2FF')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(8)
        }
        .width('100%')

        Text(item.description)
          .fontSize(14)
          .fontColor('#6B7280')
          .margin({ top: 4 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .margin({ left: 16 })
      .alignItems(HorizontalAlign.Start)

      // 箭头
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(20)
        .height(20)
        .fillColor('#9CA3AF')
        .margin({ left: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      // 导航到组件预览页面
      router.pushUrl({
        url: 'pages/ComponentPreviewPage',
        params: {
          componentId: item.id,
          componentName: item.name
        }
      }).catch((error: Error) => {
        console.error('导航到组件预览页面失败:', error)
      })
    })
  }
}