import router from '@ohos.router'
import { DatabaseManager } from '../common/DatabaseManager'
import { util } from '@kit.ArkTS'
import promptAction from '@ohos.promptAction'

interface Question {
  id: number
  question: string
  category: string
  difficulty: string
  type: string
}

interface LearningModule {
  id: string
  title: string
  description: string
  category: string
  totalQuestions: number
  completedQuestions: number
  isUnlocked: boolean
  prerequisite?: string[]
}

interface ModuleProgress {
  completedQuestions: number
  totalQuestions: number
  isCompleted: boolean
}

interface UserProgress {
  basic: ModuleProgress
  intermediate: ModuleProgress
  advanced: ModuleProgress
  expert: ModuleProgress
}

@Entry
@Component
struct LearningPathPage {
  @State learningModules: LearningModule[] = []
  @State userProgress: UserProgress = {
    basic: { completedQuestions: 0, totalQuestions: 0, isCompleted: false },
    intermediate: { completedQuestions: 0, totalQuestions: 0, isCompleted: false },
    advanced: { completedQuestions: 0, totalQuestions: 0, isCompleted: false },
    expert: { completedQuestions: 0, totalQuestions: 0, isCompleted: false }
  }
  @State selectedModule: LearningModule | null = null
  @State showModuleDetail: boolean = false

  aboutToAppear() {
    this.initializeLearningPath()
  }

  async initializeLearningPath() {
    try {
      const dbManager = DatabaseManager.getInstance()
      const categories = await dbManager.getAllCategories()
      
      console.info(`学习路线页面 - 获取到分类: ${categories.join(', ')}`)
      
      // 根据真实分类创建学习模块
      this.learningModules = categories.map((category, index): LearningModule => {
        const module: LearningModule = {
          id: `module_${index}`,
          title: category,
          description: `学习${category}相关的知识点和题目`,
          category: category,
          totalQuestions: 0,
          completedQuestions: 0,
          isUnlocked: index === 0, // 第一个模块默认解锁
          prerequisite: index > 0 ? [`module_${index - 1}`] : undefined
        }
        return module
      })
      
      // 加载题目数量和用户进度
      await this.loadQuestionCounts()
      await this.loadUserProgress()
      
    } catch (error) {
      console.error('初始化学习路线失败:', error)
      // 如果获取失败，使用空数组
      this.learningModules = []
    }
  }

  async loadQuestionCounts() {
    try {
      const dbManager = DatabaseManager.getInstance()
      const categoryCountsMap = await dbManager.getCategoryQuestionCounts()
      
      console.info(`学习路线页面 - 获取分类题目数量`)
      
      // 更新模块的题目数量
      this.learningModules.forEach(module => {
        const count = categoryCountsMap.get(module.category) || 0
        module.totalQuestions = count
        console.info(`学习路线页面 - 模块 "${module.title}" (分类: ${module.category}) 题目数量: ${count}`)
      })
      
      // 触发状态更新
      this.learningModules = [...this.learningModules]
    } catch (error) {
      console.error('加载题目数量失败:', error)
    }
  }

  async loadUserProgress() {
    try {
      const dbManager = DatabaseManager.getInstance()
      
      // 加载每个模块的用户进度
      for (const module of this.learningModules) {
        try {
          // 获取该分类下用户答对的题目数量
          const correctAnswers = await dbManager.getCorrectAnswersByCategory(module.category)
          module.completedQuestions = correctAnswers
        } catch (error) {
          console.error(`加载模块 ${module.title} 进度失败:`, error)
          module.completedQuestions = 0
        }
      }
      
      // 触发状态更新
      this.learningModules = [...this.learningModules]
      
      // 更新模块解锁状态和完成情况
      this.updateModuleStatus()
    } catch (error) {
      console.error('加载学习进度失败:', error)
    }
  }

  updateModuleStatus() {
    // 根据用户进度更新模块状态
    for (let i = 0; i < this.learningModules.length; i++) {
      const module = this.learningModules[i]
      
      // 检查前置条件
      if (module.prerequisite) {
        const prerequisiteCompleted = module.prerequisite.every(prereq => {
          const prereqModule = this.learningModules.find(m => m.id === prereq)
          return prereqModule && prereqModule.completedQuestions >= prereqModule.totalQuestions * 0.8
        })
        module.isUnlocked = prerequisiteCompleted
      }
    }
    
    // 触发状态更新
    this.learningModules = [...this.learningModules]
  }

  build() {
    Column() {
      // 顶部导航栏
      this.HeaderSection()
      
      // 学习进度概览
      this.ProgressOverview()
      
      // 学习路径
      Scroll() {
        Column() {
          this.LearningPathContent()
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder HeaderSection() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24)
        .height(24)
        .fillColor('#333333')
        .onClick(() => {
          router.back()
        })
      
      Text('学习路线')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      
      // 占位，保持居中
      Column()
        .width(24)
        .height(24)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 2, color: '#1A000000', offsetX: 0, offsetY: 1 })
  }

  @Builder ProgressOverview() {
    Column() {
      Text('学习进度')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .margin({ bottom: 16 })

      Row() {
        Column() {
          Text('已完成模块')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 4 })
          
          Text(this.getCompletedModulesCount().toString())
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#4CAF50')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text('总模块数')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 4 })
          
          Text(this.learningModules.length.toString())
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text('完成率')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 4 })
          
          Text(`${this.getCompletionRate()}%`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF9800')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin(16)
  }

  @Builder LearningPathContent() {
    Column() {
      ForEach(this.learningModules, (module: LearningModule, index: number) => {
        this.ModuleCard(module, index)
      })
    }
    .width('100%')
  }

  @Builder ModuleCard(module: LearningModule, index: number) {
    Column() {
      Row() {
        // 模块图标
        Column() {
          Image(this.getModuleIcon(module.category))
            .width(40)
            .height(40)
            .fillColor(module.isUnlocked ? '#007AFF' : '#CCCCCC')
        }
        .width(60)
        .height(60)
        .backgroundColor(module.isUnlocked ? '#E3F2FD' : '#F5F5F5')
        .borderRadius(30)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // 模块信息
        Column() {
          Text(module.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(module.isUnlocked ? '#333333' : '#999999')
            .width('100%')
            .margin({ bottom: 4 })

          Text(module.description)
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 8 })

          // 进度条
          if (module.isUnlocked) {
            this.ProgressBar(module.completedQuestions, module.totalQuestions)
          } else {
            Text('需要完成前置模块')
              .fontSize(12)
              .fontColor('#999999')
              .backgroundColor('#F0F0F0')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(8)
          }
        }
        .layoutWeight(1)
        .margin({ left: 16 })
        .alignItems(HorizontalAlign.Start)

        // 状态图标
        if (module.isUnlocked) {
          if (this.isModuleCompleted(module)) {
            Image($r('app.media.ic_check_circle'))
              .width(24)
              .height(24)
              .fillColor('#4CAF50')
          } else {
            Image($r('app.media.ic_arrow_right'))
              .width(24)
              .height(24)
              .fillColor('#007AFF')
          }
        } else {
          Image($r('app.media.ic_lock'))
            .width(24)
            .height(24)
            .fillColor('#CCCCCC')
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 连接线（除了最后一个模块）
      if (index < this.learningModules.length - 1) {
        Column()
          .width(2)
          .height(20)
          .backgroundColor('#E0E0E0')
          .margin({ left: 30, top: 8, bottom: 8 })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .onClick(() => {
      if (module.isUnlocked) {
        this.enterModule(module)
      } else {
        // 显示toast提示
        promptAction.showToast({
          message: '请先完成前置模块的学习',
          duration: 2000
        })
      }
    })
    .opacity(module.isUnlocked ? 1.0 : 0.6)
  }

  @Builder ProgressBar(completed: number, total: number) {
    Column() {
      Row() {
        Text(`${completed}/${total} 题`)
          .fontSize(12)
          .fontColor('#666666')
        
        Blank()
        
        Text(`${total > 0 ? Math.round((completed / total) * 100) : 0}%`)
          .fontSize(12)
          .fontColor('#007AFF')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .margin({ bottom: 4 })

      Stack({ alignContent: Alignment.Start }) {
        // 背景条
        Row()
          .width('100%')
          .height(6)
          .backgroundColor('#E0E0E0')
          .borderRadius(3)

        // 进度条
        Row()
          .width(`${total > 0 ? (completed / total) * 100 : 0}%`)
          .height(6)
          .backgroundColor('#007AFF')
          .borderRadius(3)
      }
      .width('100%')
    }
    .width('100%')
  }

  getModuleIcon(category: string): Resource {
    switch (category) {
      case '基础语法':
        return $r('app.media.ic_code')
      case '控制结构':
        return $r('app.media.ic_flow')
      case '函数':
        return $r('app.media.ic_function')
      case '类':
        return $r('app.media.ic_class')
      case '泛型':
        return $r('app.media.ic_generic')
      case '高级特性':
        return $r('app.media.ic_advanced')
      default:
        return $r('app.media.ic_book')
    }
  }

  getCompletedModulesCount(): number {
    return this.learningModules.filter(module => this.isModuleCompleted(module)).length
  }

  getCompletionRate(): number {
    const completedCount = this.getCompletedModulesCount()
    return this.learningModules.length > 0 ? Math.round((completedCount / this.learningModules.length) * 100) : 0
  }

  isModuleCompleted(module: LearningModule): boolean {
    return module.totalQuestions > 0 && module.completedQuestions >= module.totalQuestions * 0.8
  }

  enterModule(module: LearningModule) {
    // 进入模块练习
    router.pushUrl({
      url: 'pages/QuestionBankPage',
      params: {
        category: module.category,
        moduleId: module.id,
        moduleTitle: module.title
      }
    })
  }
}