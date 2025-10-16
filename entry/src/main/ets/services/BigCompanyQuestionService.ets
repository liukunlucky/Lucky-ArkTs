export interface BigCompanyQuestion {
  id: string
  title: string
  description: string
  company: string
  difficulty: string
  category: string
  year: number
  content: string
  answer: string
  analysis: string
  viewCount: number
  likeCount: number
  tags: string[]
}

export class BigCompanyQuestionService {
  private static mockQuestions: BigCompanyQuestion[] = [
    {
      id: '1',
      title: 'JavaScript闭包的理解和应用',
      description: '请详细解释JavaScript中闭包的概念，并举例说明闭包的实际应用场景。',
      company: '阿里巴巴',
      difficulty: '中等',
      category: 'JavaScript',
      year: 2024,
      content: `请回答以下问题：
1. 什么是闭包？
2. 闭包的形成条件是什么？
3. 闭包有哪些实际应用场景？
4. 闭包可能带来的问题有哪些？`,
      answer: `1. 闭包是指有权访问另一个函数作用域中变量的函数。
2. 形成条件：函数嵌套、内部函数引用外部函数变量、外部函数返回内部函数。
3. 应用场景：模块化、防抖节流、回调函数、数据私有化等。
4. 可能问题：内存泄漏、性能影响。`,
      analysis: '闭包是JavaScript的重要概念，理解闭包对于掌握JavaScript至关重要。',
      viewCount: 1250,
      likeCount: 89,
      tags: ['闭包', '作用域', '内存管理']
    },
    {
      id: '2',
      title: 'Vue3 Composition API vs Options API',
      description: '比较Vue3中Composition API和Options API的优缺点，什么场景下使用哪种API更合适？',
      company: '字节跳动',
      difficulty: '中等',
      category: 'Vue',
      year: 2024,
      content: `请从以下几个方面比较两种API：
1. 代码组织方式
2. 逻辑复用性
3. TypeScript支持
4. 学习成本
5. 适用场景`,
      answer: `Composition API优势：更好的逻辑复用、更好的TypeScript支持、更灵活的代码组织。
Options API优势：更简单的学习曲线、更清晰的选项分离。
适用场景：复杂组件用Composition API，简单组件可用Options API。`,
      analysis: 'Vue3提供了两种API风格，开发者需要根据项目需求选择合适的API。',
      viewCount: 980,
      likeCount: 67,
      tags: ['Vue3', 'Composition API', 'Options API']
    },
    {
      id: '3',
      title: 'React Hooks使用规则和最佳实践',
      description: 'React Hooks有哪些使用规则？在实际开发中有哪些最佳实践？',
      company: '腾讯',
      difficulty: '中等',
      category: 'React',
      year: 2024,
      content: `请回答：
1. React Hooks的使用规则
2. 常用Hooks的使用场景
3. 自定义Hooks的设计原则
4. Hooks的性能优化技巧`,
      answer: `使用规则：只在顶层调用、只在React函数中调用。
常用场景：useState管理状态、useEffect处理副作用、useMemo优化性能。
设计原则：单一职责、可复用、易测试。
性能优化：合理使用useMemo、useCallback、React.memo。`,
      analysis: 'Hooks是React的核心特性，掌握其使用规则和最佳实践非常重要。',
      viewCount: 1420,
      likeCount: 102,
      tags: ['React', 'Hooks', '性能优化']
    },
    {
      id: '4',
      title: 'Node.js事件循环机制',
      description: '详细解释Node.js的事件循环机制，包括各个阶段的执行顺序。',
      company: '美团',
      difficulty: '困难',
      category: 'Node.js',
      year: 2024,
      content: `请详细说明：
1. 事件循环的六个阶段
2. 微任务和宏任务的执行顺序
3. process.nextTick的特殊性
4. 实际代码执行顺序分析`,
      answer: `六个阶段：timers、pending callbacks、idle/prepare、poll、check、close callbacks。
执行顺序：每个阶段执行完后检查微任务队列。
process.nextTick优先级最高，在每个阶段开始前执行。`,
      analysis: '事件循环是Node.js的核心机制，理解它对于编写高性能Node.js应用至关重要。',
      viewCount: 890,
      likeCount: 78,
      tags: ['Node.js', '事件循环', '异步编程']
    },
    {
      id: '5',
      title: '算法：二叉树的最大深度',
      description: '给定一个二叉树，找出其最大深度。请用递归和迭代两种方法实现。',
      company: '百度',
      difficulty: '简单',
      category: '算法',
      year: 2024,
      content: `题目要求：
1. 实现递归解法
2. 实现迭代解法（使用队列）
3. 分析时间复杂度和空间复杂度
4. 考虑边界情况`,
      answer: `递归解法：return root ? 1 + Math.max(maxDepth(root.left), maxDepth(root.right)) : 0
迭代解法：使用层序遍历，记录层数
时间复杂度：O(n)，空间复杂度：递归O(h)，迭代O(w)`,
      analysis: '二叉树深度是经典算法题，考查对树结构和递归的理解。',
      viewCount: 1680,
      likeCount: 134,
      tags: ['算法', '二叉树', '递归', 'BFS']
    },
    {
      id: '6',
      title: 'HTTP缓存策略详解',
      description: '详细说明HTTP缓存的工作原理，包括强缓存和协商缓存的区别。',
      company: '京东',
      difficulty: '中等',
      category: '网络',
      year: 2024,
      content: `请说明：
1. 强缓存的实现方式
2. 协商缓存的实现方式
3. 缓存的优先级
4. 实际应用场景`,
      answer: `强缓存：Expires、Cache-Control，直接从缓存读取。
协商缓存：Last-Modified/If-Modified-Since、ETag/If-None-Match，需要服务器验证。
优先级：Cache-Control > Expires，ETag > Last-Modified。`,
      analysis: 'HTTP缓存是前端性能优化的重要手段，理解缓存机制有助于提升用户体验。',
      viewCount: 1120,
      likeCount: 95,
      tags: ['HTTP', '缓存', '性能优化']
    },
    {
      id: '7',
      title: '浏览器渲染原理和性能优化',
      description: '详细说明浏览器的渲染过程，以及如何进行性能优化。',
      company: '滴滴',
      difficulty: '困难',
      category: '浏览器',
      year: 2024,
      content: `请详细说明：
1. 浏览器渲染的完整流程
2. 重排和重绘的区别
3. 如何避免强制同步布局
4. 性能优化的具体策略`,
      answer: `渲染流程：解析HTML/CSS → 构建DOM/CSSOM → 布局 → 绘制 → 合成。
重排影响布局，重绘只影响外观。
避免强制同步布局：批量DOM操作、使用transform代替改变位置。
优化策略：减少DOM操作、使用CSS3动画、开启硬件加速。`,
      analysis: '浏览器渲染原理是前端开发的基础知识，掌握它有助于写出高性能的代码。',
      viewCount: 1350,
      likeCount: 118,
      tags: ['浏览器', '渲染原理', '性能优化']
    },
    {
      id: '8',
      title: 'JavaScript异步编程演进',
      description: '从回调函数到Promise再到async/await，JavaScript异步编程是如何演进的？',
      company: '小米',
      difficulty: '中等',
      category: 'JavaScript',
      year: 2023,
      content: `请说明：
1. 回调函数的问题
2. Promise的优势和使用
3. async/await的特点
4. 三种方式的对比`,
      answer: `回调函数问题：回调地狱、错误处理困难。
Promise优势：链式调用、更好的错误处理。
async/await特点：同步写法、更好的可读性。
对比：可读性和错误处理逐步改善。`,
      analysis: 'JavaScript异步编程的演进体现了语言的不断完善和开发体验的提升。',
      viewCount: 1580,
      likeCount: 142,
      tags: ['JavaScript', '异步编程', 'Promise', 'async/await']
    },
    {
      id: '9',
      title: 'Vue响应式原理深入理解',
      description: 'Vue2和Vue3的响应式原理有什么区别？各自的优缺点是什么？',
      company: '阿里巴巴',
      difficulty: '困难',
      category: 'Vue',
      year: 2023,
      content: `请对比说明：
1. Vue2的Object.defineProperty实现
2. Vue3的Proxy实现
3. 两种方式的性能对比
4. 各自的局限性`,
      answer: `Vue2使用Object.defineProperty，只能监听已存在属性，需要递归遍历。
Vue3使用Proxy，可以监听整个对象，支持动态属性。
性能：Vue3初始化更快，Vue2运行时更优。
局限性：Vue2不支持数组索引，Vue3兼容性稍差。`,
      analysis: 'Vue响应式原理的演进体现了技术的不断进步和对性能的持续优化。',
      viewCount: 2100,
      likeCount: 189,
      tags: ['Vue', '响应式', 'Proxy', 'Object.defineProperty']
    },
    {
      id: '10',
      title: 'TypeScript高级类型应用',
      description: '在实际项目中如何使用TypeScript的高级类型来提升代码质量？',
      company: '字节跳动',
      difficulty: '困难',
      category: 'TypeScript',
      year: 2024,
      content: `请说明以下高级类型的使用：
1. 条件类型（Conditional Types）
2. 映射类型（Mapped Types）
3. 模板字面量类型
4. 工具类型的实际应用`,
      answer: `条件类型：T extends U ? X : Y，用于类型推断。
映射类型：{ [K in keyof T]: T[K] }，用于类型转换。
模板字面量：\`\${string}-\${number}\`，用于字符串类型约束。
工具类型：Partial、Required、Pick等，简化类型操作。`,
      analysis: 'TypeScript高级类型是构建类型安全应用的重要工具，掌握它们能显著提升开发效率。',
      viewCount: 1890,
      likeCount: 156,
      tags: ['TypeScript', '高级类型', '类型推断', '工具类型']
    },
    {
      id: '11',
      title: 'Webpack打包优化策略',
      description: '在大型项目中，如何优化Webpack的打包性能和产物大小？',
      company: '腾讯',
      difficulty: '困难',
      category: '工程化',
      year: 2024,
      content: `请从以下方面说明优化策略：
1. 构建速度优化
2. 产物体积优化
3. 缓存策略
4. 代码分割`,
      answer: `构建速度：使用cache、thread-loader、esbuild-loader等。
体积优化：Tree Shaking、压缩、externals、按需加载。
缓存策略：contenthash、splitChunks、持久化缓存。
代码分割：动态import、vendor分离、公共模块提取。`,
      analysis: 'Webpack优化是前端工程化的重要环节，直接影响开发体验和用户体验。',
      viewCount: 1650,
      likeCount: 128,
      tags: ['Webpack', '打包优化', '性能优化', '工程化']
    },
    {
      id: '12',
      title: 'CSS-in-JS vs CSS Modules',
      description: '比较CSS-in-JS和CSS Modules两种CSS解决方案的优缺点。',
      company: '美团',
      difficulty: '中等',
      category: 'CSS',
      year: 2024,
      content: `请对比分析：
1. 样式隔离机制
2. 运行时性能
3. 开发体验
4. 适用场景`,
      answer: `样式隔离：CSS-in-JS运行时生成，CSS Modules编译时处理。
性能：CSS Modules更优，CSS-in-JS有运行时开销。
开发体验：CSS-in-JS更灵活，CSS Modules更简单。
适用场景：动态样式用CSS-in-JS，静态样式用CSS Modules。`,
      analysis: '选择合适的CSS解决方案需要考虑项目需求、团队技能和性能要求。',
      viewCount: 1320,
      likeCount: 98,
      tags: ['CSS', 'CSS-in-JS', 'CSS Modules', '样式隔离']
    },
    {
      id: '13',
      title: 'Redis缓存设计模式',
      description: '在高并发场景下，如何设计Redis缓存策略来提升系统性能？',
      company: '百度',
      difficulty: '困难',
      category: '后端',
      year: 2024,
      content: `请说明以下缓存模式：
1. Cache-Aside模式
2. Write-Through模式
3. Write-Behind模式
4. 缓存雪崩和穿透的解决方案`,
      answer: `Cache-Aside：应用负责缓存管理，最常用。
Write-Through：写入时同步更新缓存和数据库。
Write-Behind：异步写入数据库，性能最好。
解决方案：布隆过滤器防穿透，随机TTL防雪崩。`,
      analysis: 'Redis缓存设计是高性能系统架构的关键组成部分，需要根据业务特点选择合适的模式。',
      viewCount: 1780,
      likeCount: 145,
      tags: ['Redis', '缓存', '高并发', '系统设计']
    },
    {
      id: '14',
      title: 'MySQL索引优化实战',
      description: '在实际项目中如何设计和优化MySQL索引来提升查询性能？',
      company: '京东',
      difficulty: '困难',
      category: '数据库',
      year: 2024,
      content: `请说明：
1. 索引的类型和选择
2. 复合索引的设计原则
3. 索引失效的常见场景
4. 查询优化的实践技巧`,
      answer: `索引类型：B+树、哈希、全文索引，根据查询模式选择。
复合索引：最左前缀原则，区分度高的字段在前。
失效场景：函数操作、类型转换、模糊查询前缀通配符。
优化技巧：EXPLAIN分析、避免SELECT *、合理使用LIMIT。`,
      analysis: 'MySQL索引优化是数据库性能调优的核心，需要结合具体业务场景进行设计。',
      viewCount: 1950,
      likeCount: 167,
      tags: ['MySQL', '索引优化', '数据库', '性能调优']
    },
    {
      id: '15',
      title: '微前端架构设计与实践',
      description: '如何设计一个可扩展的微前端架构？有哪些技术方案可以选择？',
      company: '滴滴',
      difficulty: '困难',
      category: '架构',
      year: 2024,
      content: `请说明：
1. 微前端的核心概念
2. 主流技术方案对比
3. 应用间通信机制
4. 部署和发布策略`,
      answer: `核心概念：独立开发、独立部署、技术栈无关。
技术方案：single-spa、qiankun、Module Federation等。
通信机制：全局状态、事件总线、URL参数。
部署策略：独立部署、版本管理、灰度发布。`,
      analysis: '微前端架构适合大型团队和复杂业务场景，需要权衡收益和复杂度。',
      viewCount: 2200,
      likeCount: 198,
      tags: ['微前端', '架构设计', 'qiankun', 'Module Federation']
    },
    {
      id: '16',
      title: 'Docker容器化最佳实践',
      description: '在生产环境中使用Docker有哪些最佳实践？如何优化镜像大小和安全性？',
      company: '小米',
      difficulty: '中等',
      category: 'DevOps',
      year: 2024,
      content: `请说明：
1. Dockerfile编写最佳实践
2. 镜像大小优化技巧
3. 容器安全策略
4. 多阶段构建的应用`,
      answer: `Dockerfile：使用.dockerignore、合并RUN命令、选择合适基础镜像。
大小优化：多阶段构建、删除不必要文件、使用Alpine镜像。
安全策略：非root用户、最小权限、定期更新基础镜像。
多阶段构建：分离构建和运行环境，减少最终镜像大小。`,
      analysis: 'Docker容器化是现代应用部署的标准方式，掌握最佳实践能提升部署效率和安全性。',
      viewCount: 1450,
      likeCount: 112,
      tags: ['Docker', '容器化', 'DevOps', '镜像优化']
    },
    {
      id: '17',
      title: 'GraphQL vs REST API设计',
      description: '在什么场景下选择GraphQL？它相比REST API有哪些优势和劣势？',
      company: '字节跳动',
      difficulty: '中等',
      category: 'API设计',
      year: 2023,
      content: `请对比分析：
1. 数据获取方式的差异
2. 缓存策略的不同
3. 学习成本和复杂度
4. 适用场景分析`,
      answer: `数据获取：GraphQL按需获取，REST固定结构。
缓存策略：REST更容易缓存，GraphQL需要复杂缓存策略。
学习成本：GraphQL学习曲线更陡峭。
适用场景：复杂查询用GraphQL，简单CRUD用REST。`,
      analysis: 'API设计需要根据业务需求、团队能力和系统复杂度来选择合适的方案。',
      viewCount: 1680,
      likeCount: 134,
      tags: ['GraphQL', 'REST', 'API设计', '数据获取']
    },
    {
      id: '18',
      title: 'Kubernetes集群管理实践',
      description: '如何在生产环境中管理Kubernetes集群？有哪些监控和故障排查的方法？',
      company: '阿里巴巴',
      difficulty: '困难',
      category: 'DevOps',
      year: 2024,
      content: `请说明：
1. 集群资源管理策略
2. 服务发现和负载均衡
3. 监控和日志收集
4. 故障排查流程`,
      answer: `资源管理：Namespace隔离、ResourceQuota限制、HPA自动扩缩容。
服务发现：Service、Ingress、DNS解析。
监控日志：Prometheus+Grafana、ELK Stack、Jaeger链路追踪。
故障排查：kubectl命令、事件查看、日志分析。`,
      analysis: 'Kubernetes是容器编排的事实标准，掌握其管理实践对于云原生应用至关重要。',
      viewCount: 1820,
      likeCount: 149,
      tags: ['Kubernetes', '集群管理', '监控', '故障排查']
    },
    {
      id: '19',
      title: '前端安全防护策略',
      description: '前端应用面临哪些安全威胁？如何实施有效的安全防护措施？',
      company: '腾讯',
      difficulty: '中等',
      category: '安全',
      year: 2024,
      content: `请说明以下安全问题的防护：
1. XSS攻击防护
2. CSRF攻击防护
3. 点击劫持防护
4. 敏感信息保护`,
      answer: `XSS防护：输入验证、输出编码、CSP策略。
CSRF防护：Token验证、SameSite Cookie、Referer检查。
点击劫持：X-Frame-Options、CSP frame-ancestors。
信息保护：HTTPS传输、敏感数据加密、安全存储。`,
      analysis: '前端安全是Web应用的重要组成部分，需要从多个维度建立防护体系。',
      viewCount: 1590,
      likeCount: 126,
      tags: ['前端安全', 'XSS', 'CSRF', '安全防护']
    },
    {
      id: '20',
      title: '算法：LRU缓存实现',
      description: '设计并实现一个LRU（最近最少使用）缓存，支持get和put操作。',
      company: '美团',
      difficulty: '中等',
      category: '算法',
      year: 2024,
      content: `要求：
1. get(key)：获取key对应的value
2. put(key, value)：插入或更新key-value对
3. 当缓存达到容量时，删除最久未使用的项
4. 时间复杂度要求：O(1)`,
      answer: `使用哈希表+双向链表实现：
- 哈希表：快速定位节点
- 双向链表：维护使用顺序
- 头部：最近使用，尾部：最久未使用
- get时移动到头部，put时插入头部，超容量时删除尾部`,
      analysis: 'LRU缓存是经典的数据结构设计题，考查对哈希表和链表的综合运用。',
      viewCount: 2150,
      likeCount: 187,
      tags: ['算法', 'LRU', '哈希表', '链表']
    },
    {
      id: '21',
      title: 'Spring Boot微服务架构',
      description: '如何使用Spring Boot构建微服务架构？服务间通信如何设计？',
      company: '京东',
      difficulty: '困难',
      category: '后端',
      year: 2024,
      content: `请说明：
1. 微服务拆分原则
2. 服务注册与发现
3. 配置管理策略
4. 分布式事务处理`,
      answer: `拆分原则：业务边界清晰、数据独立、团队自治。
注册发现：Eureka、Consul、Nacos等注册中心。
配置管理：Spring Cloud Config、Apollo配置中心。
分布式事务：Saga模式、TCC模式、消息最终一致性。`,
      analysis: 'Spring Boot微服务架构是Java后端的主流方案，需要考虑服务治理的各个方面。',
      viewCount: 1920,
      likeCount: 158,
      tags: ['Spring Boot', '微服务', '服务治理', '分布式']
    },
    {
      id: '22',
      title: 'Flutter跨平台开发实践',
      description: 'Flutter在跨平台开发中有哪些优势？如何处理平台差异性？',
      company: '滴滴',
      difficulty: '中等',
      category: '移动开发',
      year: 2024,
      content: `请说明：
1. Flutter的渲染机制
2. 状态管理方案选择
3. 原生功能调用
4. 性能优化技巧`,
      answer: `渲染机制：Skia引擎直接渲染，性能接近原生。
状态管理：Provider、Bloc、Riverpod等，根据复杂度选择。
原生调用：Platform Channel、Method Channel、Event Channel。
性能优化：Widget复用、异步操作、图片优化、包大小控制。`,
      analysis: 'Flutter是Google推出的跨平台框架，在移动开发领域越来越受欢迎。',
      viewCount: 1750,
      likeCount: 142,
      tags: ['Flutter', '跨平台', '移动开发', '状态管理']
    },
    {
      id: '23',
      title: 'Python异步编程深入',
      description: 'Python中的异步编程是如何工作的？asyncio库的核心概念有哪些？',
      company: '百度',
      difficulty: '困难',
      category: 'Python',
      year: 2024,
      content: `请详细说明：
1. 事件循环的工作原理
2. 协程、任务、Future的关系
3. 异步上下文管理器
4. 异步生成器的使用`,
      answer: `事件循环：单线程调度协程执行，处理I/O事件。
关系：协程是可暂停函数，任务是协程的封装，Future是结果容器。
上下文管理器：async with语法，支持异步资源管理。
异步生成器：async def + yield，支持异步迭代。`,
      analysis: 'Python异步编程是处理高并发I/O的重要技术，理解其原理有助于编写高效代码。',
      viewCount: 1680,
      likeCount: 135,
      tags: ['Python', '异步编程', 'asyncio', '协程']
    },
    {
      id: '24',
      title: 'Go语言并发编程模式',
      description: 'Go语言的并发模型有什么特点？常用的并发编程模式有哪些？',
      company: '字节跳动',
      difficulty: '困难',
      category: 'Go',
      year: 2024,
      content: `请说明：
1. Goroutine和Channel的设计理念
2. Select语句的使用场景
3. 常见并发模式
4. 内存模型和同步原语`,
      answer: `设计理念：CSP模型，通过通信共享内存而非共享内存通信。
Select场景：多路复用、超时控制、非阻塞操作。
并发模式：Worker Pool、Pipeline、Fan-in/Fan-out。
同步原语：Mutex、RWMutex、WaitGroup、Once、Cond。`,
      analysis: 'Go语言的并发模型是其核心特性，掌握并发编程模式对于Go开发至关重要。',
      viewCount: 1890,
      likeCount: 156,
      tags: ['Go', '并发编程', 'Goroutine', 'Channel']
    },
    {
      id: '25',
      title: '算法：动态规划经典问题',
      description: '背包问题、最长公共子序列、股票买卖等动态规划问题的解题思路。',
      company: '阿里巴巴',
      difficulty: '困难',
      category: '算法',
      year: 2023,
      content: `请分析以下问题的DP解法：
1. 0-1背包问题
2. 最长公共子序列
3. 买卖股票的最佳时机
4. 状态转移方程的设计思路`,
      answer: `0-1背包：dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])
LCS：dp[i][j] = dp[i-1][j-1] + 1 (if s1[i]==s2[j]) else max(dp[i-1][j], dp[i][j-1])
股票：dp[i][0/1] 表示第i天不持有/持有股票的最大利润
设计思路：定义状态、找出转移关系、确定边界条件。`,
      analysis: '动态规划是算法面试的重点，掌握经典问题的解法有助于举一反三。',
      viewCount: 2300,
      likeCount: 205,
      tags: ['算法', '动态规划', '背包问题', 'LCS']
    },
    {
      id: '26',
      title: 'Rust内存安全机制',
      description: 'Rust如何在编译时保证内存安全？所有权系统是如何工作的？',
      company: '字节跳动',
      difficulty: '困难',
      category: 'Rust',
      year: 2024,
      content: `请详细说明：
1. 所有权（Ownership）规则
2. 借用（Borrowing）和引用
3. 生命周期（Lifetime）概念
4. 智能指针的使用`,
      answer: `所有权规则：每个值有唯一所有者、离开作用域自动释放、移动语义。
借用：不可变借用&T、可变借用&mut T，借用检查器确保安全。
生命周期：确保引用有效性，避免悬垂指针。
智能指针：Box<T>、Rc<T>、Arc<T>、RefCell<T>等。`,
      analysis: 'Rust的内存安全机制是其核心特性，理解所有权系统对于Rust开发至关重要。',
      viewCount: 1420,
      likeCount: 118,
      tags: ['Rust', '内存安全', '所有权', '借用检查']
    },
    {
      id: '27',
      title: 'WebAssembly性能优化',
      description: 'WebAssembly在什么场景下能带来性能提升？如何优化WASM应用？',
      company: '谷歌',
      difficulty: '困难',
      category: 'WebAssembly',
      year: 2024,
      content: `请说明：
1. WASM的性能优势
2. 适用场景分析
3. 与JavaScript的交互
4. 优化策略和工具`,
      answer: `性能优势：接近原生速度、预编译、类型安全。
适用场景：计算密集型任务、游戏、图像处理、加密算法。
JS交互：通过导入导出函数、共享内存、类型转换。
优化策略：减少JS-WASM调用、批量数据传输、使用SIMD指令。`,
      analysis: 'WebAssembly为Web平台带来了新的性能可能性，在特定场景下能显著提升应用性能。',
      viewCount: 1680,
      likeCount: 142,
      tags: ['WebAssembly', '性能优化', 'WASM', '计算密集型']
    },
    {
      id: '28',
      title: 'Serverless架构设计',
      description: 'Serverless架构有哪些优势和挑战？如何设计一个高效的Serverless应用？',
      company: '亚马逊',
      difficulty: '中等',
      category: '云计算',
      year: 2024,
      content: `请说明：
1. Serverless的核心概念
2. 冷启动问题及解决方案
3. 状态管理策略
4. 成本优化技巧`,
      answer: `核心概念：按需执行、自动扩缩容、无服务器管理。
冷启动：预热函数、连接池复用、选择合适运行时。
状态管理：外部存储、缓存层、事件驱动架构。
成本优化：合理设置内存、优化执行时间、使用预留容量。`,
      analysis: 'Serverless架构改变了应用部署和运维模式，适合事件驱动和间歇性工作负载。',
      viewCount: 1550,
      likeCount: 125,
      tags: ['Serverless', '云计算', 'FaaS', '成本优化']
    },
    {
      id: '29',
      title: '区块链智能合约开发',
      description: '如何开发安全可靠的智能合约？常见的安全漏洞有哪些？',
      company: '蚂蚁金服',
      difficulty: '困难',
      category: '区块链',
      year: 2024,
      content: `请说明：
1. 智能合约的基本概念
2. Solidity语言特性
3. 常见安全漏洞
4. 最佳开发实践`,
      answer: `基本概念：自执行合约、不可篡改、去中心化执行。
Solidity特性：静态类型、继承、库、事件机制。
安全漏洞：重入攻击、整数溢出、权限控制、随机数预测。
最佳实践：代码审计、测试覆盖、Gas优化、升级模式。`,
      analysis: '智能合约开发需要特别注意安全性，一旦部署就难以修改，安全漏洞可能造成重大损失。',
      viewCount: 1380,
      likeCount: 108,
      tags: ['区块链', '智能合约', 'Solidity', '安全']
    },
    {
      id: '30',
      title: 'AI大模型应用开发',
      description: '如何基于大语言模型开发AI应用？Prompt工程有哪些技巧？',
      company: 'OpenAI',
      difficulty: '中等',
      category: '人工智能',
      year: 2024,
      content: `请说明：
1. 大模型API的使用
2. Prompt工程技巧
3. 上下文管理策略
4. 成本控制方法`,
      answer: `API使用：理解参数设置、流式响应、错误处理。
Prompt技巧：明确指令、提供示例、角色设定、思维链。
上下文管理：滑动窗口、关键信息提取、会话状态保持。
成本控制：Token优化、缓存策略、模型选择、批量处理。`,
      analysis: '大模型应用开发是当前AI领域的热点，掌握Prompt工程和成本优化是关键技能。',
      viewCount: 2450,
      likeCount: 218,
      tags: ['AI', '大模型', 'Prompt工程', 'GPT']
    },
    {
      id: '31',
      title: 'Edge Computing边缘计算',
      description: '边缘计算在什么场景下有优势？如何设计边缘计算架构？',
      company: '华为',
      difficulty: '中等',
      category: '边缘计算',
      year: 2024,
      content: `请说明：
1. 边缘计算的核心价值
2. 与云计算的区别
3. 典型应用场景
4. 技术挑战和解决方案`,
      answer: `核心价值：低延迟、带宽节省、数据隐私、离线能力。
区别：计算位置、延迟特性、资源规模、管理复杂度。
应用场景：IoT、自动驾驶、AR/VR、工业4.0。
技术挑战：资源受限、网络不稳定、安全管理、设备异构。`,
      analysis: '边缘计算是5G和IoT时代的重要技术趋势，能够解决云计算在特定场景下的局限性。',
      viewCount: 1620,
      likeCount: 135,
      tags: ['边缘计算', 'IoT', '5G', '低延迟']
    },
    {
      id: '32',
      title: 'GraphQL订阅实时通信',
      description: 'GraphQL Subscription如何实现实时数据推送？与WebSocket有什么区别？',
      company: 'Facebook',
      difficulty: '中等',
      category: 'GraphQL',
      year: 2024,
      content: `请说明：
1. GraphQL Subscription原理
2. 实现方式对比
3. 与WebSocket的区别
4. 性能优化策略`,
      answer: `原理：基于发布订阅模式，服务器主动推送数据变更。
实现方式：WebSocket、Server-Sent Events、长轮询。
区别：GraphQL提供类型安全和查询灵活性，WebSocket更底层。
优化策略：订阅去重、批量推送、连接池管理、权限控制。`,
      analysis: 'GraphQL Subscription为实时应用提供了类型安全的解决方案，适合复杂的实时数据需求。',
      viewCount: 1480,
      likeCount: 122,
      tags: ['GraphQL', 'Subscription', '实时通信', 'WebSocket']
    },
    {
      id: '33',
      title: 'Deno vs Node.js对比',
      description: 'Deno相比Node.js有哪些改进？在什么场景下选择Deno？',
      company: '字节跳动',
      difficulty: '中等',
      category: 'JavaScript运行时',
      year: 2024,
      content: `请对比分析：
1. 安全模型的差异
2. 模块系统的改进
3. TypeScript支持
4. 生态系统成熟度`,
      answer: `安全模型：Deno默认安全，需要显式授权访问文件、网络等。
模块系统：Deno使用URL导入，Node.js使用npm包管理。
TypeScript：Deno原生支持，Node.js需要额外配置。
生态系统：Node.js更成熟，Deno生态在快速发展。`,
      analysis: 'Deno代表了JavaScript运行时的新方向，在安全性和开发体验上有显著改进。',
      viewCount: 1350,
      likeCount: 115,
      tags: ['Deno', 'Node.js', 'JavaScript运行时', 'TypeScript']
    },
    {
      id: '34',
      title: 'WebRTC实时音视频',
      description: 'WebRTC如何实现点对点音视频通信？信令服务器的作用是什么？',
      company: '腾讯',
      difficulty: '困难',
      category: '音视频',
      year: 2024,
      content: `请说明：
1. WebRTC连接建立过程
2. NAT穿透机制
3. 媒体协商过程
4. 质量控制策略`,
      answer: `连接过程：信令交换、ICE候选收集、DTLS握手、媒体传输。
NAT穿透：STUN服务器、TURN中继、ICE协议。
媒体协商：SDP交换、编解码器选择、带宽协商。
质量控制：自适应码率、丢包重传、拥塞控制、回声消除。`,
      analysis: 'WebRTC是实时音视频通信的标准技术，理解其原理对于开发音视频应用至关重要。',
      viewCount: 1780,
      likeCount: 148,
      tags: ['WebRTC', '音视频', 'P2P', 'NAT穿透']
    },
    {
      id: '35',
      title: 'PWA渐进式Web应用',
      description: 'PWA有哪些核心特性？如何实现离线功能和推送通知？',
      company: '谷歌',
      difficulty: '中等',
      category: 'PWA',
      year: 2024,
      content: `请说明：
1. PWA的核心特性
2. Service Worker的作用
3. 缓存策略设计
4. 推送通知实现`,
      answer: `核心特性：可安装、离线工作、响应式、安全、可发现。
Service Worker：后台脚本、拦截网络请求、缓存管理、推送处理。
缓存策略：Cache First、Network First、Stale While Revalidate。
推送通知：注册Service Worker、订阅推送、服务器推送、显示通知。`,
      analysis: 'PWA让Web应用具备了类似原生应用的体验，是Web技术发展的重要方向。',
      viewCount: 1650,
      likeCount: 138,
      tags: ['PWA', 'Service Worker', '离线应用', '推送通知']
    },
    {
      id: '36',
      title: '鸿蒙HarmonyOS应用开发',
      description: '鸿蒙系统的分布式特性如何体现？ArkTS语言有什么特点？',
      company: '华为',
      difficulty: '中等',
      category: '鸿蒙开发',
      year: 2024,
      content: `请说明：
1. 鸿蒙分布式架构
2. ArkTS语言特性
3. 组件化开发模式
4. 跨设备协同能力`,
      answer: `分布式架构：统一OS内核、分布式软总线、设备虚拟化。
ArkTS特性：基于TypeScript、声明式UI、状态管理、组件化。
开发模式：自定义组件、状态管理、生命周期、事件处理。
跨设备协同：分布式任务调度、数据同步、设备发现、能力共享。`,
      analysis: '鸿蒙OS代表了下一代操作系统的发展方向，分布式特性是其核心竞争力。',
      viewCount: 2180,
      likeCount: 195,
      tags: ['鸿蒙', 'HarmonyOS', 'ArkTS', '分布式']
    },
    {
      id: '37',
      title: '量子计算编程入门',
      description: '量子计算的基本原理是什么？如何编写量子算法？',
      company: 'IBM',
      difficulty: '困难',
      category: '量子计算',
      year: 2024,
      content: `请说明：
1. 量子比特和叠加态
2. 量子门操作
3. 量子纠缠现象
4. 经典量子算法`,
      answer: `量子比特：0和1的叠加态，测量后坍缩到确定状态。
量子门：Pauli门、Hadamard门、CNOT门等基本操作。
量子纠缠：多个量子比特的关联状态，测量一个影响其他。
经典算法：Grover搜索、Shor分解、量子傅里叶变换。`,
      analysis: '量子计算是未来计算技术的重要方向，虽然还在早期阶段，但潜力巨大。',
      viewCount: 1250,
      likeCount: 98,
      tags: ['量子计算', '量子算法', '量子比特', '量子门']
    },
    {
      id: '38',
      title: '低代码平台架构设计',
      description: '如何设计一个可扩展的低代码开发平台？核心技术挑战有哪些？',
      company: '钉钉',
      difficulty: '困难',
      category: '低代码',
      year: 2024,
      content: `请说明：
1. 低代码平台核心组件
2. 可视化编辑器设计
3. 代码生成策略
4. 扩展性架构`,
      answer: `核心组件：设计器、渲染引擎、数据源、组件库、发布系统。
编辑器设计：拖拽交互、属性配置、实时预览、撤销重做。
代码生成：模板引擎、AST转换、代码优化、多端适配。
扩展性：插件机制、自定义组件、API集成、主题定制。`,
      analysis: '低代码平台能够显著提升开发效率，是企业数字化转型的重要工具。',
      viewCount: 1890,
      likeCount: 156,
      tags: ['低代码', '可视化编程', '代码生成', '平台架构']
    },
    {
      id: '39',
      title: '数据可视化最佳实践',
      description: '如何设计有效的数据可视化？D3.js和其他可视化库如何选择？',
      company: '阿里巴巴',
      difficulty: '中等',
      category: '数据可视化',
      year: 2024,
      content: `请说明：
1. 可视化设计原则
2. 图表类型选择
3. 交互设计策略
4. 性能优化技巧`,
      answer: `设计原则：准确性、清晰性、美观性、可访问性。
图表选择：根据数据类型和分析目标选择合适图表。
交互设计：缩放、筛选、钻取、联动、动画过渡。
性能优化：数据采样、虚拟化、Canvas渲染、WebGL加速。`,
      analysis: '数据可视化是数据分析的重要环节，好的可视化能够有效传达数据洞察。',
      viewCount: 1720,
      likeCount: 144,
      tags: ['数据可视化', 'D3.js', '图表设计', '交互设计']
    },
    {
      id: '40',
      title: '云原生安全策略',
      description: '云原生环境下有哪些安全挑战？如何构建安全的容器化应用？',
      company: '阿里云',
      difficulty: '困难',
      category: '云原生安全',
      year: 2024,
      content: `请说明：
1. 云原生安全模型
2. 容器安全最佳实践
3. 服务网格安全
4. 零信任架构`,
      answer: `安全模型：纵深防御、最小权限、持续监控、自动化响应。
容器安全：镜像扫描、运行时保护、网络隔离、资源限制。
服务网格：mTLS加密、身份认证、访问控制、流量监控。
零信任：身份验证、设备信任、网络分段、持续验证。`,
      analysis: '云原生安全需要从设计阶段就考虑安全因素，构建多层次的安全防护体系。',
      viewCount: 1580,
      likeCount: 128,
      tags: ['云原生', '容器安全', '零信任', '服务网格']
    }
  ]

  static async getQuestions(): Promise<BigCompanyQuestion[]> {
    // 模拟异步请求
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(BigCompanyQuestionService.mockQuestions)
      }, 500)
    })
  }

  static async getQuestionById(id: string): Promise<BigCompanyQuestion | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const question = BigCompanyQuestionService.mockQuestions.find(q => q.id === id)
        resolve(question || null)
      }, 300)
    })
  }

  static getQuestionsByCompany(company: string): BigCompanyQuestion[] {
    return BigCompanyQuestionService.mockQuestions.filter(q => q.company === company)
  }

  static getQuestionsByDifficulty(difficulty: string): BigCompanyQuestion[] {
    return BigCompanyQuestionService.mockQuestions.filter(q => q.difficulty === difficulty)
  }

  static getQuestionsByCategory(category: string): BigCompanyQuestion[] {
    return BigCompanyQuestionService.mockQuestions.filter(q => q.category === category)
  }

  static getQuestionsByYear(year: number): BigCompanyQuestion[] {
    return BigCompanyQuestionService.mockQuestions.filter(q => q.year === year)
  }

  static searchQuestions(keyword: string): BigCompanyQuestion[] {
    const lowerKeyword = keyword.toLowerCase()
    return BigCompanyQuestionService.mockQuestions.filter(q => 
      q.title.toLowerCase().includes(lowerKeyword) ||
      q.description.toLowerCase().includes(lowerKeyword) ||
      q.content.toLowerCase().includes(lowerKeyword) ||
      q.tags.some(tag => tag.toLowerCase().includes(lowerKeyword))
    )
  }

  static getCompanies(): string[] {
    const companies = new Set(BigCompanyQuestionService.mockQuestions.map(q => q.company))
    return Array.from(companies).sort()
  }

  static getDifficulties(): string[] {
    const difficulties = new Set(BigCompanyQuestionService.mockQuestions.map(q => q.difficulty))
    return Array.from(difficulties)
  }

  static getCategories(): string[] {
    const categories = new Set(BigCompanyQuestionService.mockQuestions.map(q => q.category))
    return Array.from(categories).sort()
  }

  static getYears(): number[] {
    const years = new Set(BigCompanyQuestionService.mockQuestions.map(q => q.year))
    return Array.from(years).sort((a, b) => b - a)
  }

  static async incrementViewCount(id: string): Promise<void> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const question = BigCompanyQuestionService.mockQuestions.find(q => q.id === id)
        if (question) {
          question.viewCount++
        }
        resolve()
      }, 100)
    })
  }

  static async incrementLikeCount(id: string): Promise<void> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const question = BigCompanyQuestionService.mockQuestions.find(q => q.id === id)
        if (question) {
          question.likeCount++
        }
        resolve()
      }, 100)
    })
  }
}