import router from '@ohos.router'
import { util } from '@kit.ArkTS'
import { DatabaseManager, WrongQuestion } from '../common/DatabaseManager'
import { DifficultyColorStyle } from './DailyQuestionPage'
import { promptAction } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'

interface QuestionOptions {
  A: string
  B: string
  C: string
  D: string
}

interface DailyQuestion {
  id: number
  question: string
  options: QuestionOptions
  answer: string
  explanation: string
  category: string
  difficulty: string
}

interface UserStats {
  totalQuestions: number
  correctAnswers: number
  accuracy: number
  streakDays: number
  totalStudyTime: number
  level: number
  experience: number
}

interface CheckInInfo {
  lastCheckInDate: string
  consecutiveDays: number
  totalCheckInDays: number
  todayCheckedIn: boolean
}

interface AnswerRecord {
  questionId: number
  userAnswer: string
  correctAnswer: string
  isCorrect: boolean
  answerTime: number
  questionType: string
  category: string
  difficulty: string
  createdAt: string
}

interface CategoryStat {
  category: string
  total: number
  correct: number
  accuracy: number
}

interface DifficultyStatItem {
  total: number
  correct: number
  accuracy: number
}

interface DifficultyStats {
  easy: DifficultyStatItem
  medium: DifficultyStatItem
  hard: DifficultyStatItem
}

interface CategoryMapStat {
  total: number
  correct: number
}

interface DifficultyMapStat {
  total: number
  correct: number
}

interface Question {
  category: string
}

@Component
@Entry
export struct HomePage {
  @State currentDate: string = ''
  @State currentWeekday: string = ''
  @State dailyQuestion: DailyQuestion | null = null
  @State wrongQuestion: WrongQuestion | null = null
  @StorageProp('refreshHome') @Watch('onRefreshHome') refreshHomeNumber: number = 0;

  @State userStats: UserStats = {
    totalQuestions: 0,
    correctAnswers: 0,
    accuracy: 0,
    streakDays: 0,
    totalStudyTime: 0,
    level: 1,
    experience: 0
  }
  @State checkInInfo: CheckInInfo = {
    lastCheckInDate: '',
    consecutiveDays: 0,
    totalCheckInDays: 0,
    todayCheckedIn: false
  }

  @State categoryStats: CategoryStat[] = []
  @State difficultyStats: DifficultyStats = {
    easy: { total: 0, correct: 0, accuracy: 0 },
    medium: { total: 0, correct: 0, accuracy: 0 },
    hard: { total: 0, correct: 0, accuracy: 0 }
  }

  // 移除展开/折叠状态，保持展开
  
  // 热门功能配置 - 可以根据需要配置哪些功能显示热门标签
  private hotFunctions: Set<string> = new Set(['API查询', '知识库', '视频课程', '面试宝典', 'JSON工具', '颜色转换'])
  @State allCategories: string[] = []

  async aboutToAppear() {
    this.updateDateTime()
    await this.initDatabase()
    await this.initAchievements()
    // 检查数据库状态
    await DatabaseManager.getInstance().checkDatabaseStatus()
    await this.loadAllCategories()
    await this.loadDailyQuestion()
    await this.loadWrongQuestion()
    await this.loadUserStats()
    await this.loadStatistics()
    await this.loadCheckInInfo()
  }



  // 监听收藏状态刷新
  async onRefreshHome() {
    if (this.refreshHomeNumber > 0) {
      await this.loadUserStats()
      await this.loadStatistics()
      await this.loadAllCategories()
      await this.loadWrongQuestion()
      this.refreshHomeNumber = 0;
    }
  }

  async initDatabase() {
    try {
      const context = getContext(this)
      const dbManager = DatabaseManager.getInstance()
      await dbManager.initDatabase(context)
      console.info('数据库初始化成功')
    } catch (error) {
      console.error('数据库初始化失败:', error)
    }
  }

  async initAchievements() {
    try {
      const AchievementManagerModule = await import('../common/AchievementManager')
      const achievementManager = AchievementManagerModule.AchievementManager.getInstance()
      await achievementManager.initializeDefaultAchievements()
      await achievementManager.checkAndUpdateAchievements()
      console.info('成就系统初始化成功')
    } catch (error) {
      console.error('成就系统初始化失败:', error)
    }
  }

  async loadAllCategories() {
    try {
      const context = getContext(this)
      const fileData = await context.resourceManager.getRawFileContent('arkts.json')
      const decoder = new util.TextDecoder('utf-8')
      const jsonStr = decoder.decodeWithStream(new Uint8Array(fileData.buffer))
      const questions: Question[] = JSON.parse(jsonStr)
      
      // 提取所有分类
      const categorySet = new Set<string>()
      questions.forEach((q: Question) => categorySet.add(q.category))
      this.allCategories = Array.from(categorySet)
      
      console.info(`[HomePage] 动态加载了 ${this.allCategories.length} 个分类: ${JSON.stringify(this.allCategories)}`)
    } catch (error) {
      console.error('[HomePage] 加载分类失败:', error)
      // 如果加载失败，使用默认分类
      this.allCategories = [
        '基础知识',
        '语法基础', 
        '函数编程',
        '面向对象',
        '数据结构',
        '高级特性',
        '并发编程',
        '性能优化'
      ]
    }
  }

  updateDateTime() {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    this.currentDate = `${year}年${month}月${day}日`
    
    const weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
    this.currentWeekday = weekdays[now.getDay()]
  }

  async loadDailyQuestion() {
    // 这里会从题库中随机选择一道题作为每日一题
    // 实际实现时会根据日期确保每天的题目固定
    try {
      const context = getContext(this)
      const fileData = await context.resourceManager.getRawFileContent('arkts.json')
      const decoder = new util.TextDecoder('utf-8')
      const jsonStr = decoder.decodeWithStream(new Uint8Array(fileData.buffer))
      const questions: DailyQuestion[] = JSON.parse(jsonStr)
      
      // 根据日期生成固定的随机数，确保每天题目一致
      const today = new Date().toDateString()
      const seed = this.hashCode(today)
      const randomIndex = Math.abs(seed) % questions.length
      this.dailyQuestion = questions[randomIndex]
    } catch (error) {
      console.error('加载每日一题失败:', error)
    }
  }

  async loadWrongQuestion() {
    // 从错题本中随机选择一道题作为错题复习
    try {
      const dbManager = DatabaseManager.getInstance()
      this.wrongQuestion = await dbManager.getRandomWrongQuestion()
      if (this.wrongQuestion) {
        console.info('加载错题复习成功:', this.wrongQuestion.questionId)
      } else {
        console.info('暂无错题可复习')
      }
    } catch (error) {
      console.error('加载错题复习失败:', error)
    }
  }

  hashCode(str: string): number {
    let hash = 0
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i)
      hash = ((hash << 5) - hash) + char
      hash = hash & hash // 转换为32位整数
    }
    return hash
  }

  async loadUserStats() {
    try {
      const dbManager = DatabaseManager.getInstance()
      const stats = await dbManager.getUserStats()
      this.userStats = {
        totalQuestions: stats.totalQuestions,
        correctAnswers: stats.correctAnswers,
        accuracy: stats.accuracy,
        streakDays: stats.streakDays,
        totalStudyTime: stats.totalStudyTime,
        level: stats.level,
        experience: stats.experience
      }
    } catch (error) {
      console.error('加载用户统计失败:', error)
    }
  }

  async loadCheckInInfo() {
    try {
      const context = getContext(this) as common.UIAbilityContext
      const prefs = await preferences.getPreferences(context, 'check_in_prefs')
      const lastCheckInDateStr: string = await prefs.get('lastCheckInDate', '') as string
      const consecutiveDays: number = await prefs.get('consecutiveDays', 0) as number
      const totalCheckInDays: number = await prefs.get('totalCheckInDays', 0) as number
      
      const today = new Date().toDateString()
      const todayCheckedIn = lastCheckInDateStr === today
      
      this.checkInInfo = {
        lastCheckInDate: lastCheckInDateStr,
        consecutiveDays: consecutiveDays,
        totalCheckInDays: totalCheckInDays,
        todayCheckedIn: todayCheckedIn
      }
    } catch (error) {
      console.error('加载签到信息失败:', error)
    }
  }

  async performCheckIn() {
    try {
      const today = new Date().toDateString()
      const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000).toDateString()
      
      if (this.checkInInfo.todayCheckedIn) {
        promptAction.showToast({ message: '今天已经签到过了！' })
        return
      }
      
      let newConsecutiveDays = 1
      if (this.checkInInfo.lastCheckInDate === yesterday) {
        // 连续签到
        newConsecutiveDays = this.checkInInfo.consecutiveDays + 1
      }
      
      const newTotalDays = this.checkInInfo.totalCheckInDays + 1
      
      // 计算经验奖励
      let expReward = 10 // 基础经验
      if (newConsecutiveDays >= 7) {
        expReward += 20 // 连续7天额外奖励
      }
      if (newConsecutiveDays >= 30) {
        expReward += 50 // 连续30天额外奖励
      }
      
      // 更新用户经验和等级
      const newExp = this.userStats.experience + expReward
      const newLevel = Math.floor(newExp / 100) + 1 // 每100经验升一级
      
      // 保存签到信息
      const context = getContext(this) as common.UIAbilityContext
      const prefs = await preferences.getPreferences(context, 'check_in_prefs')
      await prefs.put('lastCheckInDate', today)
      await prefs.put('consecutiveDays', newConsecutiveDays)
      await prefs.put('totalCheckInDays', newTotalDays)
      await prefs.flush()
      
      // 保存用户等级和经验到数据库
      const dbManager = DatabaseManager.getInstance()
      await dbManager.updateUserLevel(newLevel, newExp)
      
      // 更新状态
      this.checkInInfo = {
        lastCheckInDate: today,
        consecutiveDays: newConsecutiveDays,
        totalCheckInDays: newTotalDays,
        todayCheckedIn: true
      }
      
      this.userStats.level = newLevel
      this.userStats.experience = newExp
      
      promptAction.showToast({ 
        message: `签到成功！获得${expReward}经验，连续签到${newConsecutiveDays}天` 
      })
      
    } catch (error) {
      console.error('签到失败:', error)
      promptAction.showToast({ message: '签到失败，请重试' })
    }
  }

  // 显示反馈对话框
  showFeedbackDialog() {
    promptAction.showDialog({
      title: '反馈建议',
      message: '感谢您的反馈！请选择反馈类型：',
      buttons: [
        {
          text: '功能建议',
          color: '#007DFF'
        },
        {
          text: '问题反馈',
          color: '#007DFF'
        },
        {
          text: '取消',
          color: '#666666'
        }
      ]
    }).then((result) => {
      if (result.index === 0) {
        promptAction.showToast({ message: '功能建议已记录，感谢您的建议！' })
      } else if (result.index === 1) {
        promptAction.showToast({ message: '问题反馈已记录，我们会尽快处理！' })
      }
    }).catch((error: Error) => {
      console.error('显示反馈对话框失败:', error)
    })
  }

  async loadStatistics() {
    try {
      console.info('[HomePage] 开始加载统计数据...')
      
      const dbManager = DatabaseManager.getInstance()
      const answerRecords: AnswerRecord[] = await dbManager.getAnswerRecords()
      
      console.info(`[HomePage] 加载答题记录数量: ${answerRecords.length}`)
      
      if (answerRecords.length > 0) {
        console.info(`[HomePage] 示例记录:`, JSON.stringify(answerRecords[0]))
        console.info(`[HomePage] 前3条记录:`, JSON.stringify(answerRecords.slice(0, 3)))
      } else {
        console.info('[HomePage] 没有找到任何答题记录')
      }
      
      await this.calculateCategoryStats(answerRecords)
      
      console.info('[HomePage] 开始计算难度统计...')
      await this.calculateDifficultyStats(answerRecords)
      console.info(`[HomePage] 计算后的难度统计:`, JSON.stringify(this.difficultyStats))
      
      // 检查每个难度的具体数据
      console.info(`[HomePage] 简单难度: ${this.difficultyStats.easy.correct}/${this.difficultyStats.easy.total}`)
      console.info(`[HomePage] 中等难度: ${this.difficultyStats.medium.correct}/${this.difficultyStats.medium.total}`)
      console.info(`[HomePage] 困难难度: ${this.difficultyStats.hard.correct}/${this.difficultyStats.hard.total}`)
      
    } catch (error) {
      console.error('[HomePage] 加载统计数据失败:', error)
    }
  }

  async calculateCategoryStats(answerRecords: AnswerRecord[]) {
    console.info(`[calculateCategoryStats] 开始计算分类统计，答题记录数量: ${answerRecords.length}`)
    console.info(`[calculateCategoryStats] 动态分类数量: ${this.allCategories.length}, 分类: ${JSON.stringify(this.allCategories)}`)
    
    try {
      // 获取每个分类的总题目数量
      const dbManager = DatabaseManager.getInstance()
      const categoryQuestionCounts: Map<string, number> = await dbManager.getCategoryQuestionCounts()
      console.info(`[calculateCategoryStats] 获取到分类题目数量:`, categoryQuestionCounts)
      
      // 统计每个分类已回答的题目数量
      const answeredCountMap = new Map<string, number>()
      
      // 初始化所有分类的已回答数量为0
      this.allCategories.forEach(category => {
        answeredCountMap.set(category, 0)
      })
      
      // 统计已回答的题目数量（使用Set去重，避免重复计算同一题目）
      const answeredQuestionIds = new Set<number>()
      answerRecords.forEach((record, index) => {
        const category = record.category || '未分类'
        const questionId = record.questionId
        
        if (index < 5) { // 只打印前5条记录的详细信息
          console.info(`[calculateCategoryStats] 记录${index}: category=${category}, questionId=${questionId}`)
        }
        
        // 使用questionId去重，确保同一题目只计算一次
        const uniqueKey = `${category}_${questionId}`
        if (!answeredQuestionIds.has(questionId)) {
          answeredQuestionIds.add(questionId)
          const currentCount = answeredCountMap.get(category) || 0
          answeredCountMap.set(category, currentCount + 1)
        }
      })
      
      // 生成最终的分类统计数据
      this.categoryStats = this.allCategories.map(category => {
        const answeredCount = answeredCountMap.get(category) || 0
        const totalCount = categoryQuestionCounts.get(category) || 0
        
        const categoryStat: CategoryStat = {
          category: category,
          total: totalCount, // 这里的total表示该分类的总题目数量
          correct: answeredCount, // 这里的correct表示已回答的题目数量
          accuracy: totalCount > 0 ? Math.round((answeredCount / totalCount) * 100) : 0
        }
        
        console.info(`[calculateCategoryStats] ${category}: ${answeredCount}/${totalCount} (${categoryStat.accuracy}%)`)
        return categoryStat
      }).filter(stat => stat.total > 0) // 只显示有题目的分类
        .sort((a, b) => {
          // 先按总题目数量排序，再按分类名称排序
          if (b.total !== a.total) {
            return b.total - a.total
          }
          return a.category.localeCompare(b.category)
        })
        
    } catch (error) {
      console.error('[calculateCategoryStats] 计算分类统计失败:', error)
      this.categoryStats = []
    }
  }

  async calculateDifficultyStats(answerRecords: AnswerRecord[]) {
    console.info(`[calculateDifficultyStats] 开始处理 ${answerRecords.length} 条记录`)
    
    try {
      // 获取每个难度的总题目数量
      const dbManager = DatabaseManager.getInstance()
      const difficultyQuestionCounts: Map<string, number> = await dbManager.getDifficultyQuestionCounts()
      console.info(`[calculateDifficultyStats] 获取到难度题目数量:`, difficultyQuestionCounts)
      
      // 统计每个难度正确回答的题目数量（使用Set去重，避免重复计算同一题目）
      const correctAnswerCounts = new Map<string, number>()
      correctAnswerCounts.set('简单', 0)
      correctAnswerCounts.set('中等', 0)
      correctAnswerCounts.set('困难', 0)
      
      const answeredQuestionIds = new Set<number>()
      answerRecords.forEach((record, index) => {
        const difficulty = record.difficulty || '中等'
        const questionId = record.questionId
        
        if (index < 5) { // 只打印前5条记录的详细信息
          console.info(`[calculateDifficultyStats] 记录${index}: 难度=${difficulty}, questionId=${questionId}, 正确=${record.isCorrect}`)
        }
        
        // 只统计正确回答的题目，并使用questionId去重
        if (record.isCorrect && !answeredQuestionIds.has(questionId)) {
          answeredQuestionIds.add(questionId)
          const currentCount = correctAnswerCounts.get(difficulty) || 0
          correctAnswerCounts.set(difficulty, currentCount + 1)
        }
      })
      
      // 获取各难度的总题目数量和正确回答数量
      const easyTotal = difficultyQuestionCounts.get('简单') || 0
      const mediumTotal = difficultyQuestionCounts.get('中等') || 0
      const hardTotal = difficultyQuestionCounts.get('困难') || 0
      
      const easyCorrect = correctAnswerCounts.get('简单') || 0
      const mediumCorrect = correctAnswerCounts.get('中等') || 0
      const hardCorrect = correctAnswerCounts.get('困难') || 0
      
      console.info(`[calculateDifficultyStats] 最终统计 - 简单: ${easyCorrect}/${easyTotal}, 中等: ${mediumCorrect}/${mediumTotal}, 困难: ${hardCorrect}/${hardTotal}`)

      this.difficultyStats = {
        easy: {
          total: easyTotal, // 这里的total表示该难度的总题目数量
          correct: easyCorrect, // 这里的correct表示正确回答的题目数量
          accuracy: easyTotal > 0 ? Math.round((easyCorrect / easyTotal) * 100) : 0
        },
        medium: {
          total: mediumTotal, // 这里的total表示该难度的总题目数量
          correct: mediumCorrect, // 这里的correct表示正确回答的题目数量
          accuracy: mediumTotal > 0 ? Math.round((mediumCorrect / mediumTotal) * 100) : 0
        },
        hard: {
          total: hardTotal, // 这里的total表示该难度的总题目数量
          correct: hardCorrect, // 这里的correct表示正确回答的题目数量
          accuracy: hardTotal > 0 ? Math.round((hardCorrect / hardTotal) * 100) : 0
        }
      }
      
    } catch (error) {
      console.error('[calculateDifficultyStats] 计算难度统计失败:', error)
      this.difficultyStats = {
        easy: { total: 0, correct: 0, accuracy: 0 },
        medium: { total: 0, correct: 0, accuracy: 0 },
        hard: { total: 0, correct: 0, accuracy: 0 }
      }
    }
  }

  private navigateToSetting() {
    router.pushUrl({
      url: 'pages/ProfilePage'
    }).catch((_error: Error) => {
    });
  }

  build() {
    Scroll() {
      Column() {
        // 顶部问候语
        this.GreetingSection()
        
        // 签到卡片 - 移到问候语下面
        this.CheckInCard()
        
        // 功能图标区域
        this.FunctionIconsSection()
        
        // 每日一题卡片
        this.DailyQuestionCard()
        
        // 错题复习卡片
        this.WrongQuestionCard()
        
        // 数据统计区域
        this.StatsSection()
      }
      .width('100%')
      .padding({bottom: 20 })
    }
    .backgroundColor('#F5F5F5')
    .height('100%')
  }

  @Builder GreetingSection() {
    Row() {
      Column({ space: 8 }) {
        // App名称
        Text('ArkTs知识宝典')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontFamily('cjzj')
          .fontColor('#2C3E50')

        // 描述文字
        Text('ArkTs从入门到精通,陪您一路成长')
          .fontSize(16)
          .fontColor($r('app.color.secondary_text_color'))
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      Blank()

      // setting按钮
      Button() {
        Image($r('app.media.icon_settings'))
          .width(24)
          .height(24)
          .fillColor($r('app.color.primary_text_color'))
      }
      .width(40)
      .height(40)
      .backgroundColor('#F8F9FA')
      .borderRadius(20)
      .onClick((): void => this.navigateToSetting())
    }.width('100%')
    .backgroundColor($r('app.color.surface_color'))
    .margin({bottom: 16})
    .padding({ left: 20, right: 20, top: 20, bottom: 10 })

  }

  @Builder FunctionIconsSection() {
    Column() {
      Column() {
        // 练习&考核专区标题
        Row() {
          Text('练习&考核')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .padding(4)
        
        // 功能图标区域 - 使用Grid布局
        Grid() {
          GridItem() {
            this.FunctionIcon('题库中心', $r('app.media.ic_question_bank'), () => {
              router.pushUrl({ url: 'pages/QuestionBankPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('考核中心', $r('app.media.ic_exam'), () => {
              router.pushUrl({ url: 'pages/ExamPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('学习路线', $r('app.media.icon_learning_path'), () => {
              router.pushUrl({ url: 'pages/LearningPathPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('错题本', $r('app.media.ic_wrong_questions'), () => {
              router.pushUrl({ url: 'pages/WrongQuestionsPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('大厂真题', $r('sys.media.ohos_ic_public_copy'), () => {
              router.pushUrl({ url: 'pages/BigCompanyQuestionsPage' })
            })
          }
        }
        .columnsTemplate('1fr')
        .rowsGap(8)
        .columnsGap(0)
        .width('100%')
        .margin({ top: 8, bottom: 16 })

      }
      .padding(16)
      .margin({ bottom: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
      Column() {
        // 功能专区标题
        Row() {
          Text('功能专区')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .padding(4)
        
        // 功能图标区域 - 使用Grid布局
        Grid() {
          GridItem() {
            this.FunctionIcon('API查询', $r('app.media.icon_api'), () => {
              router.pushUrl({ url: 'pages/ApiQueryPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('知识库', $r('app.media.icon_article'), () => {
              router.pushUrl({ url: 'pages/ArticlePage' })
            })
          }
          // GridItem() {
          //   this.FunctionIcon('视频课程', $r('app.media.icon_video'), () => {
          //     router.pushUrl({ url: 'pages/VideoCoursePage' })
          //   })
          // }
          GridItem() {
            this.FunctionIcon('示例代码', $r('app.media.icon_code'), () => {
              router.pushUrl({ url: 'pages/SampleCodePage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的收藏', $r('app.media.ic_favorite'), () => {
              router.pushUrl({ url: 'pages/FavoritesPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的统计', $r('app.media.ic_statistics'), () => {
              router.pushUrl({ url: 'pages/StatisticsPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('知识背诵', $r('app.media.icon_fun_beisong'), () => {
              router.pushUrl({ url: 'pages/KnowledgeRecitePage' })
            })
          }
          GridItem() {
            this.FunctionIcon('代码生成器', $r('app.media.icon_generate'), () => {
              router.pushUrl({ url: 'pages/CodeGeneratorPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的成就', $r('app.media.ic_achievement'), () => {
              router.pushUrl({ url: 'pages/AchievementPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的目标', $r('app.media.icon_traget'), () => {
              router.pushUrl({ url: 'pages/GoalsPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的日记', $r('app.media.ic_diary'), () => {
              router.pushUrl({ url: 'pages/DiaryPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的offer', $r('app.media.icon_fun_offer'), () => {
              router.pushUrl({ url: 'pages/MyOfferPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('我的面试', $r('app.media.icon_fun_mianshi'), () => {
              router.pushUrl({ url: 'pages/MyInterviewPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('面试宝典', $r('app.media.icon_mianshi'), () => {
              router.pushUrl({ url: 'pages/InterviewPage' })
            })
          }
        }
        .columnsTemplate('1fr')
        .rowsGap(8)
        .columnsGap(0)
        .width('100%')
        .margin({ top: 8, bottom: 16 })

      }
      .padding(16)
      .margin({ bottom: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)

      Column() {
        // 工具专区标题
        Row() {
          Text('工具专区')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .padding(4)
        
        // 工具图标区域 - 使用Grid布局
        Grid() {
          GridItem() {
            this.FunctionIcon('JSON工具', $r('app.media.icon_json'), () => {
              router.pushUrl({ url: 'pages/JsonFormatterPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('颜色转换', $r('app.media.icon_color_trans'), () => {
              router.pushUrl({ url: 'pages/ColorConverterPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('Base64', $r('app.media.icon_base64'), () => {
              router.pushUrl({ url: 'pages/Base64ToolPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('URL编码', $r('app.media.icon_url'), () => {
              router.pushUrl({ url: 'pages/UrlToolPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('正则测试', $r('app.media.icon_regax'), () => {
              router.pushUrl({ url: 'pages/RegexTestPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('时间戳', $r('app.media.icon_timestamp'), () => {
              router.pushUrl({ url: 'pages/TimestampToolPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('二维码', $r('app.media.icon_qrcode'), () => {
              router.pushUrl({ url: 'pages/QRCodePage' })
            })
          }
          GridItem() {
            this.FunctionIcon('密码生成', $r('app.media.icon_pass'), () => {
              router.pushUrl({ url: 'pages/PasswordGeneratorPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('offer对比', $r('app.media.icon_vs'), () => {
              router.pushUrl({ url: 'pages/OfferComparisonPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('Hash工具', $r('app.media.icon_code'), () => {
              router.pushUrl({ url: 'pages/HashToolPage' })
            })
          }
          GridItem() {
            this.FunctionIcon('UUID生成', $r('app.media.icon_uuid'), () => {
              router.pushUrl({ url: 'pages/UuidGeneratorPage' })
            })
          }
        }
        .columnsTemplate('1fr')
        .rowsGap(8)
        .columnsGap(0)
        .width('100%')
        .margin({ top: 8, bottom: 16 })

      }
      .padding(16)
      .margin({ bottom: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
    }.padding({left: 16, right: 16}).margin({top: 16})

  }

  @Builder FunctionIcon(title: string, icon: Resource, onClick: () => void) {
    Row() {
      Stack() {
        Image(icon)
          .width(48)
          .height(48)
          .fillColor('#007DFF')
        
        // 热门标签 - 显示在右上角
        if (this.hotFunctions.has(title)) {
          Image($r('app.media.icon_hot'))
            .width(28)
            .height(14)
            .position({ x: 50, y: 0 })
        }
      }
      .width(72)
      .height(72)
      .margin({right: 12})

      Text(title)
        .fontSize(14)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .flexGrow(1)
    }
    .width('100%')
    .height(72)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .backgroundColor('#F8F9FA')
    .borderRadius(12)
    .onClick(onClick)
  }

  @Builder DailyQuestionCard() {
    Column() {
      Row() {
        Text('每日随机一题')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        
        Blank()
        
        Text('去答题')
          .fontSize(14)
          .fontColor('#FFFFFF')

      }
      .width('100%')
      .margin({ bottom: 16 })

      if (this.dailyQuestion) {
        Column() {
          Row() {
            Text(this.dailyQuestion.question)
              .fontSize(16)
              .fontColor('#333333')
              .maxLines(3)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }.width('100%')

          Row() {
            this.InfoChip(this.dailyQuestion?.difficulty || '', this.getDifficultyColor().bg, this.getDifficultyColor().text)
            Blank()
            this.InfoChip(this.dailyQuestion?.category || '', '#E3F2FD', '#1976D2')
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/DailyQuestionPage',
            params: { question: this.dailyQuestion }
          })
        })
      }
    }
    .padding(16)
    .linearGradient({
      angle: 180,
      colors: [['#CCFF6B35', 0.0], ['#CCFF8A65', 1.0]]
    })
    .borderRadius(12)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .margin({ left: 16, right: 16, bottom: 32 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/DailyQuestionPage',
        params: { question: this.dailyQuestion }
      })
    })
  }

  @Builder InfoChip(value: string, bgColor: string, textColor: string) {
    Text(`${value}`)
      .fontSize(12)
      .fontColor(textColor)
      .backgroundColor(bgColor)
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .borderRadius(8)
      .margin({ right: 8 })
  }

  @Builder CheckInCard() {
    Column() {
      Row() {
        Text('每日签到')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        
        Blank()
        
        Text(this.checkInInfo.todayCheckedIn ? '已签到' : '签到')
          .fontSize(14)
          .fontColor('#FFFFFF')
          .opacity(this.checkInInfo.todayCheckedIn ? 0.7 : 1.0)
      }
      .width('100%')
      .margin({ bottom: 16 })

      Column() {
        Row() {
          Column() {
            Text(`${this.checkInInfo.consecutiveDays}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF6B35')
            Text('连续签到天数')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Center)

          Blank()

          Column() {
            Text(`${this.checkInInfo.totalCheckInDays}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#4CAF50')
            Text('累计签到天数')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Center)

          Blank()

          Column() {
            Text(`LV.${this.userStats.level}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2196F3')
            Text(`${this.userStats.experience}经验`)
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .padding(16)

        if (!this.checkInInfo.todayCheckedIn) {
          Button('立即签到')
            .width('100%')
            .height(40)
            .backgroundColor('#FF6B35')
            .fontColor('#FFFFFF')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .borderRadius(8)
            .margin({ top: 16 })
            .onClick(() => {
              this.performCheckIn()
            })
        } else {
          Row() {
            Image($r('sys.media.ohos_ic_public_ok'))
              .width(20)
              .height(20)
              .fillColor('#4CAF50')
            Text('今日已签到')
              .fontSize(16)
              .fontColor('#4CAF50')
              .fontWeight(FontWeight.Bold)
              .margin({ left: 8 })
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor('#E8F5E8')
          .borderRadius(8)
          .margin({ top: 16 })
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    }
    .padding(16)
    .linearGradient({
      angle: 180,
      colors: [['#CC4CAF50', 0.0], ['#CC81C784', 1.0]]
    })
    .borderRadius(12)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .margin({ left: 16, right: 16, bottom: 16 })
  }

  @Builder WrongQuestionCard() {
    Column() {
      Row() {
        Text('错题复习')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        
        Blank()
        
        Text(this.wrongQuestion ? '去复习' : '')
          .fontSize(14)
          .fontColor('#FFFFFF')
      }
      .width('100%')
      .margin({ bottom: 16 })

      if (this.wrongQuestion) {
        // 有错题时显示题目内容
        Column() {
          Row() {
            Text(this.wrongQuestion.question)
              .fontSize(16)
              .fontColor('#333333')
              .maxLines(3)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }.width('100%')

          Row() {
            this.InfoChip(this.wrongQuestion.difficulty, this.getWrongQuestionDifficultyColor().bg, this.getWrongQuestionDifficultyColor().text)
            Blank()
            this.InfoChip(this.wrongQuestion.category, '#FFE0E0', '#D32F2F')
            this.InfoChip(`错误${this.wrongQuestion.wrongCount}次`, '#FFF3E0', '#F57C00')
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/WrongQuestionsPage',
            params: { wrongQuestion: this.wrongQuestion }
          })
        })
      } else {
        // 无错题时显示空态
        Column() {
          Image($r('app.media.icon_empty'))
            .width(58)
            .height(42)
            .margin({ bottom: 16 })
          
          Text('暂无错题')
            .fontSize(16)
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
          
          Text('继续努力，保持正确率！')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width('100%')
        .padding(32)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
        .alignItems(HorizontalAlign.Center)
      }
    }
    .padding(16)
    .linearGradient({
      angle: 180,
      colors: [['#CC0DA1AE', 0.0], ['#CC54918C', 1.0]]
    })
    .borderRadius(12)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .margin({ left: 16, right: 16, bottom: 32 })
    .onClick(() => {
      if (this.wrongQuestion) {
        router.pushUrl({
          url: 'pages/WrongQuestionsPage',
          params: { wrongQuestion: this.wrongQuestion }
        })
      } else {
        // 无错题时点击跳转到题库页面
        router.pushUrl({ url: 'pages/QuestionBankPage' })
      }
    })
  }

  @Builder StatsSection() {
    Column() {
      Row() {
        Text('数据概览')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
        Blank()

        Text('查看详情')
          .fontSize(14)
          .fontColor('#FFFFFF')

      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 16 })

      Row() {
        this.StatCardTotalQuestion('已答题目', '#4CAF50')
        this.StatCardAccuracy('正确率', '#2196F3')
        this.StatCardStreakDay('连续天数', '#FF9800')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 24 })

      // 分类统计
      this.CategoryStatsSection()
      
      // 难度统计
      this.DifficultyStatsSection()
    }
    .padding(16)
    .linearGradient({
      angle: 180,
      colors: [['#CC4D86DB', 0.0], ['#CC246AD2', 1.0]]
    })
    .borderRadius(12)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .margin({ left: 16, right: 16, bottom: 32 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder StatCardTotalQuestion(title: string, color: string) {
    Column() {
      Text((this.userStats.totalQuestions || 0).toString())
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 4 })
    }
    .width('30%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder StatCardAccuracy(title: string, color: string) {
    Column() {
      Text((`${(this.userStats.accuracy || 0).toFixed(1)}%`))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 4 })
    }
    .width('30%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder StatCardStreakDay(title: string, color: string) {
    Column() {
      Text(( this.userStats.streakDays || 0).toString())
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 4 })
    }
    .width('30%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder StatCard(title: string, value: string | number, color: string) {
    Column() {
      Text(value.toString())
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
      
      Text(title)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 4 })
    }
    .width('30%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder CategoryStatsSection() {
    Column() {
      Text('分类统计')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .margin({ bottom: 12 })

      if (this.categoryStats.length > 0) {
        ForEach(this.categoryStats, (stat: CategoryStat) => {
          Row() {
            Text(stat.category)
              .fontSize(14)
              .fontColor('#333333')
              .width(70)
            
            Column() {
              Row() {
                Row()
                  .width(`${stat.accuracy}%`)
                  .height(6)
                  .backgroundColor('#4CAF50')
                  .borderRadius(3)
              }
              .width('100%')
              .height(6)
              .backgroundColor('#E0E0E0')
              .borderRadius(3)
              
              Row() {
                Text(`${stat.correct}/${stat.total}`)
                  .fontSize(12)
                  .fontColor('#666666')
                
                Blank()
                
                Text(`${stat.accuracy}%`)
                  .fontSize(12)
                  .fontColor('#4CAF50')
                  .fontWeight(FontWeight.Medium)
              }
              .width('100%')
              .margin({ top: 4 })
            }
            .layoutWeight(1)
            .margin({ left: 12 })
          }
          .width('100%')
          .margin({ bottom: 8 })
        })
      } else {
        Text('暂无数据')
          .fontSize(14)
          .fontColor('#999999')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(16)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 16 })
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder DifficultyStatsSection() {
    Column() {
      Text('难度正确率统计')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .margin({ bottom: 12 })

      Row() {
        this.DifficultyItemEasy()
        this.DifficultyItemMedium()
        this.DifficultyItemHard()
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 16 })
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/StatisticsPage' })
    })
  }

  @Builder DifficultyItemEasy() {
    Column() {
      Text('简单')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 6 })
      
      Text((this.difficultyStats.easy.accuracy || 0).toString() + '%')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#4CAF50')
        .margin({ bottom: 4 })
      
      Text((this.difficultyStats.easy.correct || 0).toString() + '/' + (this.difficultyStats.easy.total || 0).toString())
        .fontSize(10)
        .fontColor('#999999')
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder DifficultyItemMedium() {
    Column() {
      Text('中等')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 6 })
      
      Text((this.difficultyStats.medium.accuracy || 0).toString() + '%')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FF9800')
        .margin({ bottom: 4 })
      
      Text((this.difficultyStats.medium.correct || 0).toString() + '/' + (this.difficultyStats.medium.total || 0).toString())
        .fontSize(10)
        .fontColor('#999999')
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder DifficultyItemHard() {
    Column() {
      Text('困难')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 6 })
      
      Text((this.difficultyStats.hard.accuracy || 0).toString() + '%')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F44336')
        .margin({ bottom: 4 })
      
      Text((this.difficultyStats.hard.correct || 0).toString() + '/' + (this.difficultyStats.hard.total || 0).toString())
        .fontSize(10)
        .fontColor('#999999')
    }
    .alignItems(HorizontalAlign.Center)
  }

  getDifficultyColor(): DifficultyColorStyle {
    switch (this.dailyQuestion?.difficulty) {
      case '简单':
        const easyStyle: DifficultyColorStyle = { bg: '#E8F5E8', text: '#4CAF50' }
        return easyStyle
      case '中等':
        const mediumStyle: DifficultyColorStyle = { bg: '#FFF3E0', text: '#FF9800' }
        return mediumStyle
      case '困难':
        const hardStyle: DifficultyColorStyle = { bg: '#FFEBEE', text: '#F44336' }
        return hardStyle
      default:
        const defaultStyle: DifficultyColorStyle = { bg: '#F5F5F5', text: '#666666' }
        return defaultStyle
    }
  }

  getWrongQuestionDifficultyColor(): DifficultyColorStyle {
    switch (this.wrongQuestion?.difficulty) {
      case '简单':
        const easyStyle: DifficultyColorStyle = { bg: '#E8F5E8', text: '#4CAF50' }
        return easyStyle
      case '中等':
        const mediumStyle: DifficultyColorStyle = { bg: '#FFF3E0', text: '#FF9800' }
        return mediumStyle
      case '困难':
        const hardStyle: DifficultyColorStyle = { bg: '#FFEBEE', text: '#F44336' }
        return hardStyle
      default:
        const defaultStyle: DifficultyColorStyle = { bg: '#F5F5F5', text: '#666666' }
        return defaultStyle
    }
  }
}