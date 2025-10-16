import router from '@ohos.router'
import preferences from '@ohos.data.preferences'

interface WelcomeItem {
  image: Resource
  title: string
  description: string
}

@Entry
@Component
struct WelcomePage {
  @State currentIndex: number = 0
  private swiperController: SwiperController = new SwiperController()
  
  private welcomeItems: WelcomeItem[] = [
    {
      image: $r('app.media.welcome1'),
      title: 'ArkTS题库',
      description: '专业的ArkTS编程题库\n涵盖基础语法、组件开发、状态管理等核心知识点\n丰富的练习题目，助你精通鸿蒙开发'
    },
    {
      image: $r('app.media.welcome2'),
      title: '丰富且合理的学习路线',
      description: '科学规划学习路径，循序渐进\n从基础到进阶，让学习更有方向'
    },
    {
      image: $r('app.media.welcome3'),
      title: '丰富的大厂真题',
      description: '汇聚阿里、腾讯、字节等大厂面试真题\n深度解析，助你轻松应对面试挑战'
    },
    {
      image: $r('app.media.welcome4'),
      title: '面试宝典',
      description: '汇聚丰富的面试经验和技巧\n涵盖技术面试、行为面试、薪资谈判等各个环节\n助你在面试中脱颖而出'
    }
  ]

  async aboutToAppear() {
    // 检查是否是首次启动
    try {
      const context = getContext(this)
      const preferencesHelper = preferences.getPreferences(context, 'app_preferences')
      const isFirstLaunch = await (await preferencesHelper).get('isFirstLaunch', true) as boolean
      
      if (!isFirstLaunch) {
        // 不是首次启动，直接跳转到主页
        router.replaceUrl({
          url: 'pages/HomePage'
        })
      }
    } catch (error) {
      console.error('检查首次启动状态失败:', error)
    }
  }

  async setFirstLaunchComplete() {
    try {
      const context = getContext(this)
      const preferencesHelper = preferences.getPreferences(context, 'app_preferences')
      await (await preferencesHelper).put('isFirstLaunch', false)
      await (await preferencesHelper).flush()
    } catch (error) {
      console.error('设置首次启动状态失败:', error)
    }
  }

  async enterApp() {
    await this.setFirstLaunchComplete()
    router.replaceUrl({
      url: 'pages/HomePage'
    })
  }

  build() {
    Column() {
      // 轮播图
      Swiper(this.swiperController) {
        ForEach(this.welcomeItems, (item: WelcomeItem, index: number) => {
          Column() {
            // 图片
            Image(item.image)
              .width('90%')
              .height(400)
              .objectFit(ImageFit.Contain)
              .borderRadius(16)
              .margin({ top: 60, bottom: 20 })

            // 圆点指示器
            Row() {
              ForEach(this.welcomeItems, (item: WelcomeItem, dotIndex: number) => {
                Circle()
                  .width(8)
                  .height(8)
                  .fill(this.currentIndex === dotIndex ? '#007DFF' : '#E0E0E0')
                  .margin({ left: dotIndex === 0 ? 0 : 8 })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 30 })

            // 标题
            Text(item.title)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 16 })

            // 描述
            Text(item.description)
              .fontSize(16)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .lineHeight(24)
              .width('80%')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
      .layoutWeight(1)
      .indicator(false)
      .loop(false)
      .onChange((index: number) => {
        this.currentIndex = index
      })

      // 底部按钮区域
      Column() {
        if (this.currentIndex < this.welcomeItems.length - 1) {
          // 前三页显示跳过和下一步按钮
          Row() {
            Button('跳过')
              .fontSize(16)
              .fontColor('#999999')
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                this.enterApp()
              })

            Blank()

            Button('下一步')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .backgroundColor('#007DFF')
              .borderRadius(24)
              .padding({ left: 24, right: 24, top: 12, bottom: 12 })
              .onClick(() => {
                this.swiperController.showNext()
              })
          }
          .width('100%')
          .padding({ left: 32, right: 32 })
        } else {
          // 最后一页显示进入应用按钮
          Button('进入应用')
            .fontSize(18)
            .fontColor('#FFFFFF')
            .backgroundColor('#007DFF')
            .borderRadius(24)
            .width('80%')
            .height(48)
            .onClick(() => {
              this.enterApp()
            })
        }
      }
      .width('100%')
      .padding({ bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}