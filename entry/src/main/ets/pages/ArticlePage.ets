import router from '@ohos.router'
import { promptAction } from '@kit.ArkUI'

class ArticleData {
  id: number = 0
  title: string = ''
  summary: string = ''
  content: string = ''
  author: string = ''
  publishDate: string = ''
  readCount: number = 0
  likeCount: number = 0
  category: string = ''
  tags: string[] = []
  coverImage?: string
  hasCode: boolean = false
  difficulty: string = 'beginner'
  estimatedReadTime: number = 0
}

@Entry
@Component
struct ArticlePage {
  @State articles: ArticleData[] = []
  @State filteredArticles: ArticleData[] = []
  @State selectedCategory: string = '全部'
  @State searchText: string = ''
  @State isLoading: boolean = true


  private categories: string[] = ['全部', '基础语法', '面向对象', '函数编程', '并发编程', '性能优化', '实战项目', '最佳实践']

  aboutToAppear() {
    this.loadArticles()
  }

  loadArticles() {
    this.articles = [
      {
        id: 1,
        title: 'ArkTS语言入门指南：华为鸿蒙应用开发必备技能',
        summary: '本文将带你从零开始学习ArkTS语言，了解其基本语法、特性和鸿蒙应用开发环境搭建。',
        content: `# ArkTS语言入门指南

ArkTS是华为为鸿蒙生态系统开发的应用开发语言，基于TypeScript扩展而来，专门为构建高性能、跨平台的鸿蒙应用而设计。作为鸿蒙应用开发的主要编程语言，ArkTS结合了TypeScript的类型安全特性和鸿蒙系统的原生能力。

## 语言特性与优势

ArkTS语言的设计哲学体现在多个方面。首先是**类型安全**，继承了TypeScript的静态类型系统，在编译时就能发现潜在的类型错误，大大减少了运行时错误的可能性。这种设计让开发者能够更早地发现问题，提高代码质量。

在**组件化开发**方面，ArkTS提供了声明式UI开发范式，通过@Component装饰器和状态管理机制，让界面开发变得更加直观和高效。开发者可以专注于描述UI的状态和行为，而不需要关心底层的渲染细节。

**高性能**是ArkTS的另一大特色。作为编译型语言，ArkTS代码会被编译成高效的字节码，在ArkTS运行时中执行，性能表现优异。同时，编译器还会进行各种优化，进一步提升应用性能。

在语法设计上，ArkTS追求**现代化和简洁性**。基于TypeScript的语法基础，添加了鸿蒙特有的装饰器和API，既保持了Web开发者的熟悉感，又提供了原生应用开发的强大能力。

## 基础语法概览

ArkTS的变量声明遵循TypeScript规范，支持let、const关键字，类型注解采用冒号语法：

\`\`\`typescript
let name: string = "ArkTS"
const PI: number = 3.14159
\`\`\`

组件定义是ArkTS的核心特性，使用@Component装饰器和struct关键字：

\`\`\`typescript
@Component
struct HelloWorld {
  @State message: string = 'Hello ArkTS'
  
  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}
\`\`\`

## 开发环境与生态

要开始ArkTS编程之旅，首先需要搭建鸿蒙开发环境。华为提供了DevEco Studio IDE，这是一个专为鸿蒙应用开发设计的集成开发环境，包含了代码编辑、调试、模拟器、性能分析等完整的开发工具链。

ArkTS的生态系统正在快速发展中，华为官方提供了丰富的API和组件库，涵盖了UI组件、系统服务、设备能力等各个方面。无论是移动应用、智能穿戴设备应用还是智能家居控制应用，都能找到相应的解决方案。

总的来说，ArkTS语言代表了华为在移动应用开发领域的创新尝试，它不仅继承了现代Web技术的优秀特性，还在跨平台能力、性能和开发效率方面有所突破，是鸿蒙应用开发者必须掌握的核心技能。`,
        author: '华为技术专家',
        publishDate: '2024-01-15',
        readCount: 1250,
        likeCount: 89,
        category: '基础语法',
        tags: ['入门', '语法', '环境搭建'],
        coverImage: 'https://example.com/arkts-intro.jpg',
        hasCode: true,
        difficulty: 'beginner',
        estimatedReadTime: 8
      },
      {
        id: 2,
        title: '深入理解ArkTS的类型系统与装饰器',
        summary: '探索ArkTS强大的类型系统，包括TypeScript类型特性、装饰器系统和状态管理类型安全等高级特性。',
        content: `# 深入理解ArkTS的类型系统与装饰器

类型系统是编程语言的核心组成部分，它决定了语言的表达能力、安全性和性能特征。ArkTS基于TypeScript构建，在继承其强大类型系统的基础上，针对鸿蒙应用开发进行了专门的优化和扩展，特别是在装饰器和状态管理方面。

## 类型系统的设计理念

ArkTS的类型系统采用静态类型检查，这意味着所有的类型错误都会在编译时被发现，而不是等到程序运行时才暴露。这种设计大大提高了程序的可靠性，让开发者能够更有信心地编写和维护代码。

与传统的静态类型语言相比，ArkTS在保持类型安全的同时，还提供了TypeScript的类型推导功能。编译器能够根据上下文自动推断变量的类型，减少了冗余的类型注解，让代码更加简洁。

## 基本类型体系

ArkTS继承了TypeScript的基本类型体系，提供了丰富的基本类型来满足不同的编程需求。数字类型 \`number\` 用于处理数值运算，字符串类型 \`string\` 处理文本数据，布尔类型 \`boolean\` 表示逻辑值。

\`\`\`typescript
let count: number = 42
let message: string = "Hello ArkTS"
let isVisible: boolean = true
\`\`\`

这些基本类型不仅提供了基础的数据表示能力，还配备了丰富的操作方法，能够满足大部分编程场景的需求。

## 装饰器类型系统

装饰器是ArkTS的核心特性，为组件开发提供了强大的类型支持。每个装饰器都有明确的类型约束，确保状态管理的类型安全：

\`\`\`typescript
@Component
struct TypeSafeComponent {
  @State count: number = 0
  @Prop title: string = ''
  @Link isExpanded: boolean
  @Provide dataSource: string[] = []
  
  build() {
    Column() {
      Text(\`\${this.title}: \${this.count}\`)
        .fontSize(16)
        .onClick(() => {
          this.count++
        })
    }
  }
}
\`\`\`

装饰器类型系统确保了状态变量的类型一致性和使用规范，编译器会检查状态变量的类型匹配和数据流向。

## 泛型在组件开发中的应用

ArkTS充分利用了TypeScript的泛型特性，在组件开发中实现高度的代码复用。泛型组件可以处理多种数据类型，提高代码的复用性：

\`\`\`typescript
interface ListItem {
  id: string
  title: string
}

@Component
struct GenericList<T extends ListItem> {
  @Prop items: T[]
  @Prop itemBuilder: (item: T, index: number) => void
  
  build() {
    List() {
      ForEach(this.items, (item: T, index: number) => {
        ListItem() {
          this.itemBuilder(item, index)
        }
      })
    }
  }
}
\`\`\`

泛型约束进一步增强了类型系统的表达能力，允许我们对泛型参数施加特定的限制，确保类型具有某些特定的能力或属性。

## 可选类型与空值安全

TypeScript的可选类型和联合类型在ArkTS中得到了很好的应用，帮助开发者处理可能为空的值。通过可选属性和联合类型，我们可以明确表示一个值可能存在也可能不存在：

\`\`\`typescript
interface UserInfo {
  id: string
  name: string
  avatar?: string  // 可选属性
  email: string | undefined  // 联合类型
}

@Component
struct UserCard {
  @Prop user: UserInfo
  
  build() {
    Row() {
      if (this.user.avatar) {
        Image(this.user.avatar)
          .width(50)
          .height(50)
      }
      
      Text(this.user.name)
        .fontSize(16)
    }
  }
}
\`\`\`

这种设计不仅提高了代码的安全性，还让代码的意图更加明确。

## 类型推导与开发体验

ArkTS的类型推导系统能够在保持类型安全的前提下，显著减少样板代码。DevEco Studio会根据赋值、函数调用、返回值等上下文信息，自动推断出变量和表达式的类型。

这种设计让开发者能够专注于业务逻辑的实现，而不是被繁琐的类型声明所困扰。同时，IDE还能够提供更好的代码补全和错误提示，进一步提升开发效率。

总的来说，ArkTS的类型系统在继承TypeScript强大特性的基础上，针对鸿蒙应用开发场景进行了优化，为开发者提供了类型安全、高效开发的编程体验。`,
        author: 'ArkTS核心开发者',
        publishDate: '2024-01-20',
        readCount: 890,
        likeCount: 67,
        category: '基础语法',
        tags: ['类型系统', '泛型', '装饰器'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 12
      },
      {
        id: 3,
        title: 'ArkTS组件化编程实践：构建可复用的鸿蒙UI组件',
        summary: '学习如何在ArkTS中使用组件化思想，通过@Component装饰器和状态管理来构建可复用的鸿蒙应用界面。',
        content: `# ArkTS组件化编程实践：构建可复用的鸿蒙UI组件

组件化编程是现代前端开发的重要编程范式，它通过封装、复用和组合等机制，帮助开发者构建更加模块化、可维护的用户界面系统。ArkTS在设计时充分考虑了组件化开发的需求，提供了完整而现代的组件化特性。

## 组件化设计理念

ArkTS的组件化设计遵循了现代UI框架的最佳实践。它强调**封装性**，通过@Component装饰器来定义独立的UI组件；支持**状态管理**，通过各种状态装饰器来管理组件的数据流；实现了**组合性**，让复杂的界面可以由简单的组件组合而成。

与传统的UI开发方式相比，ArkTS在保持核心概念不变的同时，提供了声明式的语法结构，减少了样板代码，让组件化开发变得更加直观和高效。

## 组件的设计与实现

在ArkTS中，组件是UI的基本构建单元，定义了界面的结构和行为。组件的设计需要考虑数据的封装和UI的组织。一个设计良好的组件应该具有清晰的职责边界，提供简洁的接口，隐藏实现细节。

以 UserCard 组件为例，我们可以看到ArkTS如何优雅地实现组件封装：

\`\`\`typescript
interface UserInfo {
  id: string
  name: string
  avatar?: string
  email?: string
}

@Component
struct UserCard {
  @Prop user: UserInfo
  @Prop onTap?: () => void
  @State isExpanded: boolean = false
  
  build() {
    Column() {
      Row() {
        Image(this.user.avatar || $r('app.media.default_avatar'))
          .width(50)
          .height(50)
          .borderRadius(25)
        
        Column() {
          Text(this.user.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          
          if (this.user.email && this.isExpanded) {
            Text(this.user.email)
              .fontSize(14)
              .fontColor(Color.Gray)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
        
        Spacer()
        
        Button(this.isExpanded ? '收起' : '展开')
          .fontSize(12)
          .onClick(() => {
            this.isExpanded = !this.isExpanded
          })
      }
      .width('100%')
      .padding(12)
    }
    .backgroundColor(Color.White)
    .borderRadius(8)
    .onClick(this.onTap)
  }
}
\`\`\`

这个例子展示了ArkTS组件定义的基本结构：@Prop接收外部数据，@State管理内部状态，build()方法定义UI结构。

## 状态管理与数据流

状态管理是组件化开发中的核心概念。ArkTS提供了多种状态装饰器来处理不同场景的数据流：

\`\`\`typescript
@Component
struct TodoList {
  @State todos: TodoItem[] = []
  @Provide selectedCount: number = 0
  
  addTodo = (text: string) => {
    this.todos.push({
      id: Date.now().toString(),
      text: text,
      completed: false
    })
  }
  
  toggleTodo = (id: string) => {
    const index = this.todos.findIndex(todo => todo.id === id)
    if (index !== -1) {
      this.todos[index].completed = !this.todos[index].completed
      this.updateSelectedCount()
    }
  }
  
  updateSelectedCount = () => {
    this.selectedCount = this.todos.filter(todo => todo.completed).length
  }
  
  build() {
    Column() {
      TodoInput({ onAdd: this.addTodo })
      
      List() {
        ForEach(this.todos, (todo: TodoItem) => {
          ListItem() {
            TodoItemComponent({
              todo: todo,
              onToggle: this.toggleTodo
            })
          }
        })
      }
      
      TodoSummary()
    }
  }
}
\`\`\`

ArkTS的状态管理机制确保了数据变化时UI的自动更新，开发者只需要关注数据的变化，UI的重新渲染由框架自动处理。

## 组件组合与复用

组件化的核心优势在于复用性。通过合理的组件设计，我们可以创建可在多个场景中使用的通用组件：

\`\`\`typescript
@Component
struct GenericButton {
  @Prop text: string
  @Prop type: 'primary' | 'secondary' | 'danger' = 'primary'
  @Prop disabled: boolean = false
  @Prop onTap?: () => void
  
  private getButtonStyle() {
    switch (this.type) {
      case 'primary':
        return { backgroundColor: '#007DFF', fontColor: Color.White }
      case 'secondary':
        return { backgroundColor: '#F1F3F5', fontColor: '#182431' }
      case 'danger':
        return { backgroundColor: '#FA2A2D', fontColor: Color.White }
      default:
        return { backgroundColor: '#007DFF', fontColor: Color.White }
    }
  }
  
  build() {
    Button(this.text)
      .backgroundColor(this.getButtonStyle().backgroundColor)
      .fontColor(this.getButtonStyle().fontColor)
      .enabled(!this.disabled)
      .opacity(this.disabled ? 0.5 : 1)
      .onClick(this.onTap)
  }
}

// 使用通用按钮组件
@Component
struct ActionPanel {
  build() {
    Row() {
      GenericButton({
        text: '确认',
        type: 'primary',
        onTap: () => console.log('确认')
      })
      
      GenericButton({
        text: '取消',
        type: 'secondary',
        onTap: () => console.log('取消')
      })
      
      GenericButton({
        text: '删除',
        type: 'danger',
        onTap: () => console.log('删除')
      })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}
\`\`\`

## 组件通信模式

在复杂的应用中，组件之间需要进行数据通信。ArkTS提供了多种通信模式：

\`\`\`typescript
// 父子组件通信
@Component
struct ParentComponent {
  @State parentData: string = 'Hello'
  
  handleChildEvent = (data: string) => {
    this.parentData = data
  }
  
  build() {
    Column() {
      Text(\`父组件数据: \${this.parentData}\`)
      
      ChildComponent({
        propData: this.parentData,
        onEvent: this.handleChildEvent
      })
    }
  }
}

@Component
struct ChildComponent {
  @Prop propData: string
  @Prop onEvent?: (data: string) => void
  @State childData: string = ''
  
  build() {
    Column() {
      Text(\`接收到的数据: \${this.propData}\`)
      
      TextInput({ text: this.childData })
        .onChange((value) => {
          this.childData = value
        })
      
      Button('发送给父组件')
        .onClick(() => {
          this.onEvent?.(this.childData)
        })
    }
  }
}
\`\`\`

## 最佳实践与设计模式

在使用ArkTS进行组件化开发时，遵循一些最佳实践可以让代码更加健壮和可维护：

1. **单一职责原则**：每个组件应该只负责一个特定的功能
2. **接口设计**：通过明确的@Prop接口定义组件的输入
3. **状态提升**：将共享状态提升到最近的公共父组件
4. **组件拆分**：将复杂组件拆分为更小的、可复用的子组件

ArkTS的语法设计也鼓励这些最佳实践的应用。清晰的装饰器系统、声明式的UI语法、强大的状态管理机制，都让开发者能够更容易地编写高质量的组件化代码。

通过合理运用ArkTS的组件化特性，开发者可以构建出结构清晰、易于维护和扩展的鸿蒙应用界面，充分发挥组件化开发的优势。`,
        author: '面向对象专家',
        publishDate: '2024-01-25',
        readCount: 756,
        likeCount: 54,
        category: '面向对象',
        tags: ['类', '继承', '接口'],
        coverImage: 'https://example.com/oop-arkts.jpg',
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 15
      },
      {
        id: 4,
        title: 'ArkTS状态管理与响应式编程：构建高效的鸿蒙应用',
        summary: '深入探索ArkTS的状态管理机制，包括@State、@Prop、@Link等装饰器的使用和响应式编程模式。',
        content: `# ArkTS状态管理与响应式编程：构建高效的鸿蒙应用

状态管理是现代前端开发的核心概念，它决定了应用的数据流向和UI更新机制。ArkTS作为鸿蒙应用开发的主要语言，提供了一套完整的响应式状态管理系统，通过装饰器模式让开发者能够轻松构建高效、可维护的应用程序。

## 响应式编程的核心理念

响应式编程是一种以数据流和变化传播为核心的编程范式。在ArkTS中，当状态发生变化时，所有依赖该状态的UI组件会自动更新，这种自动化的更新机制大大简化了开发复杂度，让开发者能够专注于业务逻辑而不是手动管理UI更新。

ArkTS的响应式系统基于装饰器模式，通过@State、@Prop、@Link等装饰器来标识不同类型的状态变量。这种设计不仅让状态管理变得直观，还提供了编译时的类型检查，确保状态使用的正确性。

## @State：组件内部状态管理

@State装饰器用于管理组件内部的状态，当被@State装饰的变量发生变化时，组件会自动重新渲染。这是最基础也是最常用的状态管理方式：

\`\`\`typescript
@Entry
@Component
struct CounterExample {
  @State count: number = 0;
  @State message: string = 'Hello ArkTS';

  build() {
    Column() {
      Text(\`计数: \${this.count}\`)
        .fontSize(24)
        .margin(10)
      
      Text(this.message)
        .fontSize(18)
        .margin(10)
      
      Button('增加')
        .onClick(() => {
          this.count++;
          this.message = \`当前计数: \${this.count}\`;
        })
    }
    .padding(20)
  }
}
\`\`\`

这种声明式的状态管理让UI与数据保持同步变得非常简单，开发者只需要关注状态的变化，UI会自动响应这些变化。

## @Prop与@Link：父子组件通信

在组件化开发中，父子组件之间的数据传递是常见需求。ArkTS提供了@Prop和@Link装饰器来处理这种场景：

\`\`\`typescript
@Component
struct ChildComponent {
  @Prop title: string;
  @Link count: number;

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .margin(10)
      
      Text(\`子组件计数: \${this.count}\`)
        .fontSize(16)
        .margin(10)
      
      Button('子组件增加')
        .onClick(() => {
          this.count++;
        })
    }
    .padding(10)
    .border({ width: 1, color: Color.Gray })
  }
}

@Entry
@Component
struct ParentComponent {
  @State parentCount: number = 0;

  build() {
    Column() {
      Text('父组件')
        .fontSize(24)
        .margin(10)
      
      ChildComponent({
        title: '这是子组件',
        count: $parentCount
      })
      
      Text(\`父组件计数: \${this.parentCount}\`)
        .fontSize(16)
        .margin(10)
    }
    .padding(20)
  }
}
\`\`\`

@Prop用于单向数据传递，@Link用于双向数据绑定，这种设计让组件间的数据流向变得清晰可控。

## @Observed与@ObjectLink：对象状态管理

对于复杂的对象状态，ArkTS提供了@Observed和@ObjectLink装饰器来实现深度响应式：

\`\`\`typescript
@Observed
class UserInfo {
  name: string = '';
  age: number = 0;
  email: string = '';
}

@Component
struct UserProfile {
  @ObjectLink user: UserInfo;

  build() {
    Column() {
      Text(\`姓名: \${this.user.name}\`)
        .margin(5)
      Text(\`年龄: \${this.user.age}\`)
        .margin(5)
      Text(\`邮箱: \${this.user.email}\`)
        .margin(5)
      
      Button('更新用户信息')
        .onClick(() => {
          this.user.name = '张三';
          this.user.age = 25;
          this.user.email = 'zhangsan@example.com';
        })
    }
    .padding(10)
  }
}
\`\`\`

这种模式特别适合管理复杂的业务对象，确保对象属性的变化能够正确触发UI更新。

## @Provide与@Consume：跨层级状态共享

在复杂的组件树中，有时需要跨多个层级共享状态。@Provide和@Consume装饰器提供了这种能力：

\`\`\`typescript
@Entry
@Component
struct AppRoot {
  @Provide theme: string = 'light';

  build() {
    Column() {
      Button(\`切换主题 (当前: \${this.theme})\`)
        .onClick(() => {
          this.theme = this.theme === 'light' ? 'dark' : 'light';
        })
      
      MiddleComponent()
    }
    .padding(20)
  }
}

@Component
struct MiddleComponent {
  build() {
    Column() {
      Text('中间组件')
        .margin(10)
      
      DeepComponent()
    }
    .padding(10)
  }
}

@Component
struct DeepComponent {
  @Consume theme: string;

  build() {
    Column() {
      Text(\`深层组件 - 主题: \${this.theme}\`)
        .fontColor(this.theme === 'light' ? Color.Black : Color.White)
        .backgroundColor(this.theme === 'light' ? Color.White : Color.Black)
    }
    .padding(10)
  }
}
\`\`\`

这种模式避免了props drilling问题，让状态共享变得更加优雅。

## 状态管理最佳实践

在实际开发中，合理的状态管理策略对应用性能和可维护性至关重要。建议遵循以下原则：

1. 状态就近原则：将状态定义在最接近使用它的组件中
2. 单一数据源：避免重复的状态定义
3. 不可变更新：通过创建新对象而不是修改现有对象来更新状态
4. 合理使用装饰器：根据具体场景选择合适的状态装饰器

ArkTS的状态管理系统为开发者提供了强大而灵活的工具，通过合理运用这些特性，可以构建出高性能、易维护的鸿蒙应用程序。`,
        author: 'ArkTS开发专家',
        publishDate: '2024-02-01',
        readCount: 623,
        likeCount: 45,
        category: '状态管理',
        tags: ['@State', '@Prop', '@Link', '响应式编程'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 10
      },
      {
        id: 5,
        title: 'ArkTS异步编程与网络请求：构建响应式鸿蒙应用',
        summary: '深入学习ArkTS的异步编程模型，包括Promise、async/await和网络请求处理。',
        content: `# ArkTS异步编程与网络请求：构建响应式鸿蒙应用

异步编程是现代移动应用开发的核心技术，它让应用能够在不阻塞用户界面的情况下处理耗时操作，如网络请求、文件读写和数据库操作。ArkTS提供了完整的异步编程支持，包括Promise、async/await语法和丰富的网络API，为开发者构建高性能的鸿蒙应用提供了强大的工具。

## 异步编程的重要性

在移动应用开发中，用户体验是至关重要的。任何阻塞主线程的操作都会导致界面卡顿，严重影响用户体验。异步编程让我们能够在后台执行耗时操作，同时保持界面的流畅响应。

ArkTS的异步编程模型基于JavaScript的Promise和async/await，这种设计让有前端开发经验的开发者能够快速上手，同时也提供了类型安全的保障。

## Promise：异步操作的基础

Promise是ArkTS异步编程的基础，它代表一个异步操作的最终完成或失败。Promise有三种状态：pending（进行中）、fulfilled（已成功）和rejected（已失败）：

\`\`\`typescript
// 创建一个简单的Promise
function fetchUserData(userId: string): Promise<UserInfo> {
  return new Promise((resolve, reject) => {
    // 模拟异步操作
    setTimeout(() => {
      if (userId) {
        resolve({
          id: userId,
          name: '张三',
          email: 'zhangsan@example.com'
        });
      } else {
        reject(new Error('用户ID不能为空'));
      }
    }, 1000);
  });
}

// 使用Promise
fetchUserData('123')
  .then(user => {
    console.log('用户信息:', user);
  })
  .catch(error => {
    console.error('获取用户信息失败:', error);
  });
\`\`\`

Promise链式调用让异步操作的组合变得更加清晰和可控。

## async/await：更优雅的异步语法

async/await是基于Promise的语法糖，它让异步代码看起来像同步代码，大大提高了代码的可读性：

\`\`\`typescript
@Entry
@Component
struct AsyncExample {
  @State userInfo: UserInfo | null = null;
  @State loading: boolean = false;
  @State error: string = '';

  async loadUserData(userId: string) {
    this.loading = true;
    this.error = '';
    
    try {
      const user = await fetchUserData(userId);
      this.userInfo = user;
    } catch (err) {
      this.error = err.message;
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
      if (this.loading) {
        Text('加载中...')
          .fontSize(16)
          .margin(10)
      } else if (this.error) {
        Text(\`错误: \${this.error}\`)
          .fontColor(Color.Red)
          .margin(10)
      } else if (this.userInfo) {
        Column() {
          Text(\`姓名: \${this.userInfo.name}\`)
            .margin(5)
          Text(\`邮箱: \${this.userInfo.email}\`)
            .margin(5)
        }
        .padding(10)
      }
      
      Button('加载用户数据')
        .onClick(() => {
          this.loadUserData('123');
        })
        .margin(10)
    }
    .padding(20)
  }
}
\`\`\`

这种写法让错误处理和状态管理变得更加直观。

## 网络请求：连接外部世界

网络请求是移动应用的重要功能，ArkTS提供了http模块来处理各种网络操作：

\`\`\`typescript
import http from '@ohos.net.http';

class ApiService {
  private baseUrl = 'https://api.example.com';

  async get<T>(endpoint: string): Promise<T> {
    const httpRequest = http.createHttp();
    
    try {
      const response = await httpRequest.request(\`\${this.baseUrl}\${endpoint}\`, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });

      if (response.responseCode === 200) {
        return JSON.parse(response.result as string);
      } else {
        throw new Error(\`请求失败: \${response.responseCode}\`);
      }
    } finally {
      httpRequest.destroy();
    }
  }

  async post<T>(endpoint: string, data: any): Promise<T> {
    const httpRequest = http.createHttp();
    
    try {
      const response = await httpRequest.request(\`\${this.baseUrl}\${endpoint}\`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(data)
      });

      if (response.responseCode === 200 || response.responseCode === 201) {
        return JSON.parse(response.result as string);
      } else {
        throw new Error(\`请求失败: \${response.responseCode}\`);
      }
    } finally {
      httpRequest.destroy();
    }
  }
}
\`\`\`

这个ApiService类封装了常用的HTTP操作，提供了类型安全的接口。

## 并发请求处理

在实际应用中，经常需要同时发起多个请求。Promise.all和Promise.allSettled提供了并发处理的能力：

\`\`\`typescript
@Component
struct ConcurrentRequestExample {
  @State data: any = null;
  @State loading: boolean = false;

  async loadAllData() {
    this.loading = true;
    const apiService = new ApiService();

    try {
      // 并发执行多个请求
      const [users, posts, comments] = await Promise.all([
        apiService.get('/users'),
        apiService.get('/posts'),
        apiService.get('/comments')
      ]);

      this.data = { users, posts, comments };
    } catch (error) {
      console.error('加载数据失败:', error);
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
      Button('加载所有数据')
        .onClick(() => {
          this.loadAllData();
        })
        .margin(10)

      if (this.loading) {
        Text('加载中...')
          .margin(10)
      } else if (this.data) {
        Text(\`用户数: \${this.data.users.length}\`)
          .margin(5)
        Text(\`文章数: \${this.data.posts.length}\`)
          .margin(5)
        Text(\`评论数: \${this.data.comments.length}\`)
          .margin(5)
      }
    }
    .padding(20)
  }
}
\`\`\`

## 错误处理与重试机制

健壮的异步代码需要完善的错误处理和重试机制：

\`\`\`typescript
class RobustApiService extends ApiService {
  async requestWithRetry<T>(
    endpoint: string, 
    options: any, 
    maxRetries: number = 3
  ): Promise<T> {
    let lastError: Error;

    for (let i = 0; i <= maxRetries; i++) {
      try {
        return await this.get<T>(endpoint);
      } catch (error) {
        lastError = error;
        
        if (i < maxRetries) {
          // 指数退避策略
          const delay = Math.pow(2, i) * 1000;
          await new Promise(resolve => setTimeout(resolve, delay));
        }
      }
    }

    throw lastError;
  }
}
\`\`\`

## 最佳实践与性能优化

在ArkTS异步编程中，遵循以下最佳实践能够提高应用性能和用户体验：

1. **合理使用loading状态**：为用户提供明确的加载反馈
2. **实现错误边界**：优雅地处理网络错误和异常情况
3. **请求去重**：避免重复的网络请求
4. **缓存策略**：合理缓存数据减少不必要的网络请求
5. **超时处理**：设置合理的请求超时时间

ArkTS的异步编程模型为开发者提供了强大而灵活的工具，通过合理运用这些特性，可以构建出响应迅速、用户体验优秀的鸿蒙应用程序。`,
        author: 'ArkTS异步编程专家',
        publishDate: '2024-02-05',
        readCount: 892,
        likeCount: 78,
        category: '异步编程',
        tags: ['Promise', 'async/await', '网络请求'],
        coverImage: 'https://example.com/arkts-async.jpg',
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 18
      },
      {
        id: 6,
        title: 'ArkTS性能优化与鸿蒙应用调优实战',
        summary: '掌握ArkTS和鸿蒙应用的性能优化技巧，让你的应用运行得更快更流畅。',
        content: `# ArkTS性能优化与鸿蒙应用调优实战

## 组件渲染优化

### 避免不必要的重新渲染

\`\`\`typescript
@Component
struct OptimizedList {
  @State items: Array<ItemData> = [];

  // 使用LazyForEach进行列表优化
  build() {
    List() {
      LazyForEach(this.dataSource, (item: ItemData, index: number) => {
        ListItem() {
          // 使用@Reusable装饰器复用组件
          OptimizedListItem({ data: item })
        }
        .reuseId(item.type) // 设置复用ID
      }, (item: ItemData) => item.id.toString())
    }
    .cachedCount(5) // 设置缓存数量
    .onScrollIndex((start, end) => {
      // 按需加载数据
      this.loadDataIfNeeded(start, end);
    })
  }
}

@Reusable
@Component
struct OptimizedListItem {
  @Prop data: ItemData;

  aboutToReuse(params: Record<string, Object>) {
    // 组件复用时的回调
    this.data = params.data as ItemData;
  }

  build() {
    Row() {
      Text(this.data.title)
        .fontSize(16)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .padding(10)
  }
}
\`\`\`

## 状态管理优化

### 合理使用状态装饰器

\`\`\`typescript
// 避免过度使用@State，优先使用@Prop和@Link
@Component
struct PerformantComponent {
  @Prop title: string; // 单向传递，性能更好
  @Link @Watch('onCountChange') count: number; // 双向绑定，按需使用
  @State private localState: boolean = false; // 仅组件内部状态使用@State

  onCountChange() {
    // 只在count变化时执行，避免不必要的计算
    console.log('Count changed:', this.count);
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
      
      // 使用条件渲染减少DOM节点
      if (this.count > 0) {
        Text(\`计数: \${this.count}\`)
          .fontSize(14)
      }
      
      Button('切换状态')
        .onClick(() => {
          this.localState = !this.localState;
        })
    }
  }
}
\`\`\`

## 内存管理优化

### 及时释放资源

\`\`\`typescript
@Component
struct ResourceManagement {
  private timer: number = -1;
  private subscription: any = null;

  aboutToAppear() {
    // 组件出现时初始化资源
    this.timer = setInterval(() => {
      this.updateData();
    }, 1000);
    
    this.subscription = this.subscribeToData();
  }

  aboutToDisappear() {
    // 组件销毁时清理资源
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
    }
    
    if (this.subscription) {
      this.subscription.unsubscribe();
      this.subscription = null;
    }
  }

  updateData() {
    // 更新数据逻辑
  }

  subscribeToData() {
    // 订阅数据逻辑
    return {
      unsubscribe: () => {
        // 取消订阅逻辑
      }
    };
  }

  build() {
    Column() {
      Text('资源管理示例')
    }
  }
}
\`\`\`

## 图片和媒体优化

### 图片懒加载和缓存

\`\`\`typescript
@Component
struct OptimizedImage {
  @Prop imageUrl: string;
  @State isLoaded: boolean = false;

  build() {
    Stack() {
      if (this.isLoaded) {
        Image(this.imageUrl)
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .onComplete(() => {
            this.isLoaded = true;
          })
          .onError(() => {
            console.error('图片加载失败:', this.imageUrl);
          })
      } else {
        // 占位符
        Column() {
          Text('加载中...')
            .fontSize(14)
            .fontColor(Color.Gray)
        }
        .width('100%')
        .height(200)
        .backgroundColor('#F5F5F5')
        .justifyContent(FlexAlign.Center)
      }
    }
  }
}
\`\`\`

## 网络请求优化

### 请求缓存和防抖

\`\`\`typescript
class OptimizedApiService {
  private cache = new Map<string, any>();
  private pendingRequests = new Map<string, Promise<any>>();

  async getData(url: string, useCache: boolean = true): Promise<any> {
    // 缓存检查
    if (useCache && this.cache.has(url)) {
      return this.cache.get(url);
    }

    // 防止重复请求
    if (this.pendingRequests.has(url)) {
      return this.pendingRequests.get(url);
    }

    const request = this.fetchData(url);
    this.pendingRequests.set(url, request);

    try {
      const data = await request;
      if (useCache) {
        this.cache.set(url, data);
      }
      return data;
    } finally {
      this.pendingRequests.delete(url);
    }
  }

  private async fetchData(url: string): Promise<any> {
    // 实际的网络请求逻辑
    const response = await fetch(url);
    return response.json();
  }

  // 防抖搜索
  debounceSearch(query: string, delay: number = 300): Promise<any> {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(this.getData(\`/search?q=\${query}\`));
      }, delay);
    });
  }
}
\`\`\`

## 布局性能优化

### 使用高效的布局组件

\`\`\`typescript
@Component
struct EfficientLayout {
  @State items: Array<string> = [];

  build() {
    // 使用Flex而不是嵌套的Row/Column
    Flex({
      direction: FlexDirection.Row,
      wrap: FlexWrap.Wrap,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      ForEach(this.items, (item: string, index: number) => {
        Text(item)
          .width('48%') // 使用百分比而不是固定像素
          .height(50)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.Blue)
          .margin({ bottom: 10 })
      }, (item: string, index: number) => \`\${index}-\${item}\`)
    }
    .padding(10)
  }
}
\`\`\`

## 性能监控与调试

### 使用性能分析工具

\`\`\`typescript
@Component
struct PerformanceMonitor {
  @State renderTime: number = 0;

  aboutToAppear() {
    const startTime = performance.now();
    
    // 模拟组件初始化
    this.initializeComponent().then(() => {
      this.renderTime = performance.now() - startTime;
      console.log(\`组件渲染时间: \${this.renderTime}ms\`);
    });
  }

  async initializeComponent() {
    // 组件初始化逻辑
    await new Promise(resolve => setTimeout(resolve, 100));
  }

  build() {
    Column() {
      Text(\`渲染时间: \${this.renderTime.toFixed(2)}ms\`)
        .fontSize(16)
        .margin(10)
    }
  }
}
\`\`\`

## 最佳实践总结

在ArkTS和鸿蒙应用开发中，性能优化需要关注以下几个方面：

1. **组件优化**：合理使用LazyForEach、@Reusable装饰器
2. **状态管理**：避免过度使用@State，优先使用@Prop和@Link
3. **内存管理**：及时清理定时器、订阅等资源
4. **网络优化**：实现请求缓存、防抖和去重
5. **布局优化**：使用高效的布局组件，避免过度嵌套
6. **图片优化**：实现懒加载和适当的缓存策略

通过这些优化技巧，可以显著提升鸿蒙应用的性能和用户体验。`,
        author: 'ArkTS性能优化专家',
        publishDate: '2024-02-10',
        readCount: 1045,
        likeCount: 92,
        category: '性能优化',
        tags: ['组件优化', '状态管理', '内存管理', '网络优化'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 14
      },
      {
        id: 7,
        title: 'ArkTS鸿蒙应用开发实战：构建完整的用户管理应用',
        summary: '从零开始使用ArkTS构建一个完整的鸿蒙用户管理应用，包括页面导航、数据管理和网络请求。',
        content: `# ArkTS鸿蒙应用开发实战：构建完整的用户管理应用

## 项目结构

\`\`\`
user-management-app/
├── entry/src/main/ets/
│   ├── entryability/
│   │   └── EntryAbility.ets
│   ├── pages/
│   │   ├── Index.ets
│   │   ├── UserListPage.ets
│   │   ├── UserDetailPage.ets
│   │   └── AddUserPage.ets
│   ├── models/
│   │   └── User.ets
│   ├── services/
│   │   └── UserService.ets
│   └── common/
│       ├── constants/
│       └── utils/
└── entry/src/main/resources/
\`\`\`

## 用户数据模型

\`\`\`typescript
// models/User.ets
export class User {
  id: string;
  name: string;
  email: string;
  phone: string;
  avatar: string;
  createdAt: Date;

  constructor(id: string, name: string, email: string, phone: string = '', avatar: string = '') {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.avatar = avatar;
    this.createdAt = new Date();
  }

  static fromJson(json: any): User {
    return new User(
      json.id,
      json.name,
      json.email,
      json.phone || '',
      json.avatar || ''
    );
  }

  toJson(): Record<string, any> {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      phone: this.phone,
      avatar: this.avatar,
      createdAt: this.createdAt.toISOString()
    };
  }
}
\`\`\`

## 用户服务类

\`\`\`typescript
// services/UserService.ets
import { User } from '../models/User';
import http from '@ohos.net.http';

export class UserService {
  private static instance: UserService;
  private baseUrl: string = 'https://api.example.com';

  static getInstance(): UserService {
    if (!UserService.instance) {
      UserService.instance = new UserService();
    }
    return UserService.instance;
  }

  async getAllUsers(): Promise<User[]> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(\`\${this.baseUrl}/users\`, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string);
        return data.map((item: any) => User.fromJson(item));
      }
      throw new Error('获取用户列表失败');
    } catch (error) {
      console.error('获取用户列表错误:', error);
      // 返回模拟数据
      return this.getMockUsers();
    }
  }

  async createUser(user: User): Promise<User> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(\`\${this.baseUrl}/users\`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(user.toJson())
      });

      if (response.responseCode === 201) {
        const data = JSON.parse(response.result as string);
        return User.fromJson(data);
      }
      throw new Error('创建用户失败');
    } catch (error) {
      console.error('创建用户错误:', error);
      // 返回模拟创建的用户
      return user;
    }
  }

  async getUserById(id: string): Promise<User | null> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(\`\${this.baseUrl}/users/\${id}\`, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string);
        return User.fromJson(data);
      }
      return null;
    } catch (error) {
      console.error('获取用户详情错误:', error);
      return null;
    }
  }

  private getMockUsers(): User[] {
    return [
      new User('1', '张三', 'zhangsan@example.com', '13800138001'),
      new User('2', '李四', 'lisi@example.com', '13800138002'),
      new User('3', '王五', 'wangwu@example.com', '13800138003')
    ];
  }
}
\`\`\`

## 用户列表页面

\`\`\`typescript
// pages/UserListPage.ets
import { User } from '../models/User';
import { UserService } from '../services/UserService';
import router from '@ohos.router';

@Entry
@Component
struct UserListPage {
  @State users: User[] = [];
  @State isLoading: boolean = false;
  private userService: UserService = UserService.getInstance();

  aboutToAppear() {
    this.loadUsers();
  }

  async loadUsers() {
    this.isLoading = true;
    try {
      this.users = await this.userService.getAllUsers();
    } catch (error) {
      console.error('加载用户列表失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  navigateToAddUser() {
    router.pushUrl({
      url: 'pages/AddUserPage'
    });
  }

  navigateToUserDetail(user: User) {
    router.pushUrl({
      url: 'pages/UserDetailPage',
      params: { user: user }
    });
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('用户管理')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('添加用户')
          .fontSize(14)
          .backgroundColor('#007DFF')
          .onClick(() => {
            this.navigateToAddUser();
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.isLoading) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 用户列表
        List({ space: 10 }) {
          ForEach(this.users, (user: User) => {
            ListItem() {
              UserListItem({ 
                user: user,
                onItemClick: () => {
                  this.navigateToUserDetail(user);
                }
              })
            }
          }, (user: User) => user.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, bottom: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

@Component
struct UserListItem {
  @Prop user: User;
  onItemClick: () => void = () => {};

  build() {
    Row() {
      // 头像
      Image(this.user.avatar || $r('app.media.default_avatar'))
        .width(50)
        .height(50)
        .borderRadius(25)
        .margin({ right: 12 })

      // 用户信息
      Column() {
        Text(this.user.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 4 })

        Text(this.user.email)
          .fontSize(14)
          .fontColor('#666666')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 箭头图标
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(20)
        .height(20)
        .fillColor('#CCCCCC')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .onClick(() => {
      this.onItemClick();
    })
  }
}
\`\`\`

## 添加用户页面

\`\`\`typescript
// pages/AddUserPage.ets
import { User } from '../models/User';
import { UserService } from '../services/UserService';
import router from '@ohos.router';

@Entry
@Component
struct AddUserPage {
  @State name: string = '';
  @State email: string = '';
  @State phone: string = '';
  @State isSubmitting: boolean = false;
  private userService: UserService = UserService.getInstance();

  async submitUser() {
    if (!this.validateForm()) {
      return;
    }

    this.isSubmitting = true;
    try {
      const newUser = new User(
        Date.now().toString(),
        this.name,
        this.email,
        this.phone
      );

      await this.userService.createUser(newUser);
      
      // 返回上一页
      router.back();
    } catch (error) {
      console.error('创建用户失败:', error);
    } finally {
      this.isSubmitting = false;
    }
  }

  validateForm(): boolean {
    if (!this.name.trim()) {
      console.log('请输入用户名');
      return false;
    }
    if (!this.email.trim()) {
      console.log('请输入邮箱');
      return false;
    }
    return true;
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('取消')
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back();
          })

        Text('添加用户')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('保存')
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .fontColor(this.isSubmitting ? '#CCCCCC' : '#007DFF')
          .enabled(!this.isSubmitting)
          .onClick(() => {
            this.submitUser();
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      // 表单内容
      Column({ space: 20 }) {
        // 用户名输入
        Column() {
          Text('用户名 *')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入用户名' })
            .width('100%')
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .onChange((value: string) => {
              this.name = value;
            })
        }

        // 邮箱输入
        Column() {
          Text('邮箱 *')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入邮箱地址' })
            .width('100%')
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .type(InputType.Email)
            .onChange((value: string) => {
              this.email = value;
            })
        }

        // 手机号输入
        Column() {
          Text('手机号')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入手机号' })
            .width('100%')
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .type(InputType.PhoneNumber)
            .onChange((value: string) => {
              this.phone = value;
            })
        }
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
\`\`\`

## 项目特点

这个用户管理应用展示了ArkTS鸿蒙开发的核心特性：

1. **组件化架构**：使用@Component装饰器创建可复用组件
2. **状态管理**：通过@State、@Prop等装饰器管理组件状态
3. **页面导航**：使用router进行页面间跳转和参数传递
4. **网络请求**：集成HTTP模块进行数据交互
5. **响应式布局**：使用Flex布局适配不同屏幕尺寸
6. **生命周期管理**：合理使用aboutToAppear等生命周期方法

通过这个实战项目，你可以掌握ArkTS鸿蒙应用开发的完整流程和最佳实践。`,
        author: '鸿蒙应用开发专家',
        publishDate: '2024-02-15',
        readCount: 1340,
        likeCount: 156,
        category: '实战项目',
        tags: ['鸿蒙应用', '用户管理', '网络请求', '页面导航'],
        coverImage: 'https://example.com/harmonyos-app.jpg',
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 25
      },
      {
        id: 8,
        title: 'ArkTS最佳实践与鸿蒙开发规范指南',
        summary: '总结ArkTS和鸿蒙应用开发中的最佳实践和代码规范，帮助你写出更优雅、更高效的代码。',
        content: `# ArkTS最佳实践与鸿蒙开发规范指南

## 命名规范

### 组件和类命名

\`\`\`typescript
// 组件名使用大驼峰命名法
@Component
struct UserListComponent {
  build() {
    // 组件实现
  }
}

// 类名使用大驼峰命名法
export class UserManager {
  private users: User[] = [];
  
  addUser(user: User): void {
    this.users.push(user);
  }
}

// 接口名使用大驼峰命名法
export interface Serializable {
  serialize(): string;
}
\`\`\`

### 变量和函数命名

\`\`\`typescript
// 变量使用小驼峰命名法
@State userName: string = '张三';
@State maxRetryCount: number = 3;
@Prop isVisible: boolean = false;

// 函数使用小驼峰命名法
calculateTotalPrice(items: Item[]): number {
  return items.reduce((total, item) => total + item.price, 0);
}

// 常量使用大写字母和下划线
const MAX_RETRY_COUNT: number = 3;
const API_BASE_URL: string = 'https://api.example.com';
\`\`\`

## 组件设计最佳实践

### 组件职责单一

\`\`\`typescript
// 好的做法：职责单一的组件
@Component
struct UserAvatar {
  @Prop avatarUrl: string;
  @Prop size: number = 50;

  build() {
    Image(this.avatarUrl || $r('app.media.default_avatar'))
      .width(this.size)
      .height(this.size)
      .borderRadius(this.size / 2)
      .objectFit(ImageFit.Cover)
  }
}

// 好的做法：可复用的列表项组件
@Component
struct UserListItem {
  @Prop user: User;
  @Prop onItemClick: (user: User) => void = () => {};

  build() {
    Row() {
      UserAvatar({ avatarUrl: this.user.avatar, size: 50 })
        .margin({ right: 12 })

      Column() {
        Text(this.user.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        
        Text(this.user.email)
          .fontSize(14)
          .fontColor('#666666')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .onClick(() => {
      this.onItemClick(this.user);
    })
  }
}
\`\`\`

### 状态管理最佳实践

\`\`\`typescript
// 合理使用状态装饰器
@Component
struct OptimizedComponent {
  // 仅在组件内部使用的状态用@State
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';

  // 从父组件传递的数据用@Prop
  @Prop title: string;
  @Prop data: any[];

  // 需要双向绑定的数据用@Link
  @Link selectedItem: any;

  // 监听状态变化
  @Watch('onDataChange') @Prop watchedData: any[];

  onDataChange() {
    // 数据变化时的处理逻辑
    console.log('数据已更新');
  }

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
      } else if (this.errorMessage) {
        Text(this.errorMessage)
          .fontColor(Color.Red)
      } else {
        // 正常内容
        Text(this.title)
          .fontSize(18)
      }
    }
  }
}
\`\`\`

## 错误处理规范

### 统一错误处理

\`\`\`typescript
// 定义错误类型
export enum ErrorType {
  NETWORK_ERROR = 'NETWORK_ERROR',
  VALIDATION_ERROR = 'VALIDATION_ERROR',
  UNKNOWN_ERROR = 'UNKNOWN_ERROR'
}

export class AppError extends Error {
  type: ErrorType;
  code?: string;

  constructor(message: string, type: ErrorType, code?: string) {
    super(message);
    this.type = type;
    this.code = code;
    this.name = 'AppError';
  }
}

// 统一的错误处理函数
export function handleError(error: Error): void {
  if (error instanceof AppError) {
    switch (error.type) {
      case ErrorType.NETWORK_ERROR:
        console.error('网络错误:', error.message);
        break;
      case ErrorType.VALIDATION_ERROR:
        console.error('验证错误:', error.message);
        break;
      default:
        console.error('未知错误:', error.message);
    }
  } else {
    console.error('系统错误:', error.message);
  }
}

// 在组件中使用
@Component
struct ErrorHandlingExample {
  @State errorMessage: string = '';

  async loadData() {
    try {
      const data = await this.fetchData();
      // 处理数据
    } catch (error) {
      handleError(error as Error);
      this.errorMessage = '数据加载失败，请重试';
    }
  }

  private async fetchData(): Promise<any> {
    // 网络请求逻辑
    throw new AppError('网络连接失败', ErrorType.NETWORK_ERROR, 'NET_001');
  }

  build() {
    Column() {
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontColor(Color.Red)
          .margin(10)
      }
      
      Button('加载数据')
        .onClick(() => {
          this.loadData();
        })
    }
  }
}
\`\`\`

## 代码组织规范

### 文件结构规范

\`\`\`typescript
// models/User.ets - 数据模型
export class User {
  id: string;
  name: string;
  email: string;

  constructor(id: string, name: string, email: string) {
    this.id = id;
    this.name = name;
    this.email = email;
  }

  validate(): boolean {
    return this.name.length > 0 && this.email.includes('@');
  }
}

// services/UserService.ets - 业务逻辑
import { User } from '../models/User';

export class UserService {
  private static instance: UserService;

  static getInstance(): UserService {
    if (!UserService.instance) {
      UserService.instance = new UserService();
    }
    return UserService.instance;
  }

  async getUsers(): Promise<User[]> {
    // 业务逻辑实现
    return [];
  }
}

// utils/ValidationUtils.ets - 工具函数
export class ValidationUtils {
  static isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  static isValidPhone(phone: string): boolean {
    const phoneRegex = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phone);
  }
}
\`\`\`

## 性能优化规范

### 组件复用和缓存

\`\`\`typescript
// 使用@Reusable装饰器优化列表性能
@Reusable
@Component
struct ReusableListItem {
  @Prop data: any;

  aboutToReuse(params: Record<string, Object>) {
    this.data = params.data;
  }

  build() {
    Row() {
      Text(this.data.title)
        .fontSize(16)
    }
    .padding(10)
  }
}

// 缓存管理类
export class CacheManager {
  private static cache = new Map<string, any>();
  private static readonly MAX_CACHE_SIZE = 100;

  static set(key: string, value: any): void {
    if (this.cache.size >= this.MAX_CACHE_SIZE) {
      const firstKey = this.cache.keys().next().value;
      this.cache.delete(firstKey);
    }
    this.cache.set(key, value);
  }

  static get(key: string): any {
    return this.cache.get(key);
  }

  static has(key: string): boolean {
    return this.cache.has(key);
  }

  static clear(): void {
    this.cache.clear();
  }
}
\`\`\`

## 代码质量保证

### TypeScript类型安全

\`\`\`typescript
// 定义严格的类型
interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

interface UserListResponse {
  users: User[];
  total: number;
  page: number;
}

// 使用泛型提高代码复用性
class ApiClient {
  async request<T>(url: string, options?: RequestInit): Promise<ApiResponse<T>> {
    try {
      const response = await fetch(url, options);
      const data = await response.json();
      return data as ApiResponse<T>;
    } catch (error) {
      throw new AppError('网络请求失败', ErrorType.NETWORK_ERROR);
    }
  }
}

// 在组件中使用类型安全的API
@Component
struct TypeSafeComponent {
  @State users: User[] = [];
  private apiClient = new ApiClient();

  async loadUsers() {
    try {
      const response = await this.apiClient.request<UserListResponse>('/api/users');
      if (response.code === 200) {
        this.users = response.data.users;
      }
    } catch (error) {
      handleError(error as Error);
    }
  }

  build() {
    List() {
      ForEach(this.users, (user: User) => {
        ListItem() {
          UserListItem({ user: user })
        }
      }, (user: User) => user.id)
    }
  }
}
\`\`\`

## 最佳实践总结

在ArkTS和鸿蒙应用开发中，遵循以下最佳实践：

1. **命名规范**：使用清晰、一致的命名约定
2. **组件设计**：保持组件职责单一，提高可复用性
3. **状态管理**：合理使用状态装饰器，避免不必要的重渲染
4. **错误处理**：建立统一的错误处理机制
5. **代码组织**：按功能模块组织代码，保持清晰的文件结构
6. **性能优化**：使用组件复用、缓存等技术提升性能
7. **类型安全**：充分利用TypeScript的类型系统

通过遵循这些规范和最佳实践，可以开发出高质量、可维护的鸿蒙应用。`,
        author: 'ArkTS代码规范专家',
        publishDate: '2024-02-20',
        readCount: 987,
        likeCount: 123,
        category: '最佳实践',
        tags: ['代码规范', '最佳实践', '错误处理', '性能优化'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 16
      },
      {
        id: 9,
        title: 'ArkTS数据结构与算法实现：鸿蒙应用开发进阶',
        summary: '使用ArkTS实现常见的数据结构和算法，提升鸿蒙应用开发中的编程能力和性能优化技巧。',
        content: `# ArkTS数据结构与算法实现：鸿蒙应用开发进阶

## 链表实现与应用

### 基础链表结构

\`\`\`typescript
// 链表节点类
export class ListNode<T> {
  data: T;
  next: ListNode<T> | null = null;
  
  constructor(data: T) {
    this.data = data;
  }
}

// 单向链表实现
export class LinkedList<T> {
  private head: ListNode<T> | null = null;
  private size: number = 0;
  
  // 添加元素到链表末尾
  append(data: T): void {
    const newNode = new ListNode(data);
    
    if (!this.head) {
      this.head = newNode;
    } else {
      let current = this.head;
      while (current.next) {
        current = current.next;
      }
      current.next = newNode;
    }
    this.size++;
  }
  
  // 在指定位置插入元素
  insert(index: number, data: T): boolean {
    if (index < 0 || index > this.size) {
      return false;
    }
    
    if (index === 0) {
      const newNode = new ListNode(data);
      newNode.next = this.head;
      this.head = newNode;
    } else {
      const newNode = new ListNode(data);
      let current = this.head;
      for (let i = 0; i < index - 1; i++) {
        current = current!.next;
      }
      newNode.next = current!.next;
      current!.next = newNode;
    }
    this.size++;
    return true;
  }
  
  // 获取指定位置的元素
  get(index: number): T | null {
    if (index < 0 || index >= this.size) {
      return null;
    }
    
    let current = this.head;
    for (let i = 0; i < index; i++) {
      current = current!.next;
    }
    return current!.data;
  }
  
  // 删除指定位置的元素
  remove(index: number): T | null {
    if (index < 0 || index >= this.size) {
      return null;
    }
    
    if (index === 0) {
      const removedData = this.head!.data;
      this.head = this.head!.next;
      this.size--;
      return removedData;
    }
    
    let current = this.head;
    for (let i = 0; i < index - 1; i++) {
      current = current!.next;
    }
    
    const removedData = current!.next!.data;
    current!.next = current!.next!.next;
    this.size--;
    return removedData;
  }
  
  // 转换为数组
  toArray(): T[] {
    const result: T[] = [];
    let current = this.head;
    while (current) {
      result.push(current.data);
      current = current.next;
    }
    return result;
  }
  
  getSize(): number {
    return this.size;
  }
}
\`\`\`

### 在鸿蒙应用中的应用示例

\`\`\`typescript
// 消息队列管理器
export class MessageQueue {
  private messages: LinkedList<Message> = new LinkedList();
  
  addMessage(message: Message): void {
    this.messages.append(message);
  }
  
  getNextMessage(): Message | null {
    if (this.messages.getSize() > 0) {
      return this.messages.remove(0);
    }
    return null;
  }
  
  getAllMessages(): Message[] {
    return this.messages.toArray();
  }
}

// 在组件中使用
@Component
struct MessageListComponent {
  @State messageQueue: MessageQueue = new MessageQueue();
  @State displayMessages: Message[] = [];

  aboutToAppear() {
    // 模拟添加消息
    this.messageQueue.addMessage({ id: '1', content: '欢迎使用鸿蒙应用', timestamp: Date.now() });
    this.messageQueue.addMessage({ id: '2', content: '您有新的通知', timestamp: Date.now() });
    this.updateDisplayMessages();
  }

  updateDisplayMessages() {
    this.displayMessages = this.messageQueue.getAllMessages();
  }

  build() {
    Column() {
      List() {
        ForEach(this.displayMessages, (message: Message) => {
          ListItem() {
            Text(message.content)
              .fontSize(16)
              .padding(10)
          }
        }, (message: Message) => message.id)
      }
      .layoutWeight(1)

      Button('处理下一条消息')
        .onClick(() => {
          const nextMessage = this.messageQueue.getNextMessage();
          if (nextMessage) {
            console.log('处理消息:', nextMessage.content);
            this.updateDisplayMessages();
          }
        })
    }
  }
}

interface Message {
  id: string;
  content: string;
  timestamp: number;
}
\`\`\`

## 二叉搜索树实现

### 基础二叉搜索树

\`\`\`typescript
// 二叉树节点
export class TreeNode<T> {
  data: T;
  left: TreeNode<T> | null = null;
  right: TreeNode<T> | null = null;
  
  constructor(data: T) {
    this.data = data;
  }
}

// 二叉搜索树实现
export class BinarySearchTree<T> {
  private root: TreeNode<T> | null = null;
  private compareFunction: (a: T, b: T) => number;
  
  constructor(compareFunction: (a: T, b: T) => number) {
    this.compareFunction = compareFunction;
  }
  
  // 插入节点
  insert(data: T): void {
    this.root = this.insertNode(this.root, data);
  }
  
  private insertNode(node: TreeNode<T> | null, data: T): TreeNode<T> {
    if (!node) {
      return new TreeNode(data);
    }
    
    const comparison = this.compareFunction(data, node.data);
    if (comparison < 0) {
      node.left = this.insertNode(node.left, data);
    } else if (comparison > 0) {
      node.right = this.insertNode(node.right, data);
    }
    
    return node;
  }
  
  // 搜索节点
  search(data: T): boolean {
    return this.searchNode(this.root, data);
  }
  
  private searchNode(node: TreeNode<T> | null, data: T): boolean {
    if (!node) {
      return false;
    }
    
    const comparison = this.compareFunction(data, node.data);
    if (comparison === 0) {
      return true;
    } else if (comparison < 0) {
      return this.searchNode(node.left, data);
    } else {
      return this.searchNode(node.right, data);
    }
  }
  
  // 中序遍历
  inorderTraversal(): T[] {
    const result: T[] = [];
    this.inorderTraversalHelper(this.root, result);
    return result;
  }
  
  private inorderTraversalHelper(node: TreeNode<T> | null, result: T[]): void {
    if (node) {
      this.inorderTraversalHelper(node.left, result);
      result.push(node.data);
      this.inorderTraversalHelper(node.right, result);
    }
  }
  
  // 查找最小值
  findMin(): T | null {
    if (!this.root) {
      return null;
    }
    
    let current = this.root;
    while (current.left) {
      current = current.left;
    }
    return current.data;
  }
  
  // 查找最大值
  findMax(): T | null {
    if (!this.root) {
      return null;
    }
    
    let current = this.root;
    while (current.right) {
      current = current.right;
    }
    return current.data;
  }
}
\`\`\`

### 在鸿蒙应用中的应用示例

\`\`\`typescript
// 用户搜索管理器
interface User {
  id: string;
  name: string;
  score: number;
}

export class UserSearchManager {
  private userTree: BinarySearchTree<User>;
  
  constructor() {
    // 按分数排序的比较函数
    this.userTree = new BinarySearchTree<User>((a, b) => a.score - b.score);
  }
  
  addUser(user: User): void {
    this.userTree.insert(user);
  }
  
  findUser(targetScore: number): boolean {
    const dummyUser: User = { id: '', name: '', score: targetScore };
    return this.userTree.search(dummyUser);
  }
  
  getAllUsersSorted(): User[] {
    return this.userTree.inorderTraversal();
  }
  
  getTopUser(): User | null {
    return this.userTree.findMax();
  }
  
  getLowestUser(): User | null {
    return this.userTree.findMin();
  }
}

// 在组件中使用
@Component
struct UserRankingComponent {
  @State userManager: UserSearchManager = new UserSearchManager();
  @State sortedUsers: User[] = [];
  @State topUser: User | null = null;
  @State searchScore: number = 0;
  @State searchResult: string = '';

  aboutToAppear() {
    // 添加示例用户
    this.userManager.addUser({ id: '1', name: '张三', score: 85 });
    this.userManager.addUser({ id: '2', name: '李四', score: 92 });
    this.userManager.addUser({ id: '3', name: '王五', score: 78 });
    this.userManager.addUser({ id: '4', name: '赵六', score: 96 });
    
    this.updateUserList();
  }

  updateUserList() {
    this.sortedUsers = this.userManager.getAllUsersSorted();
    this.topUser = this.userManager.getTopUser();
  }

  build() {
    Column() {
      Text('用户排行榜')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(10)

      if (this.topUser) {
        Text(\`最高分用户: \${this.topUser.name} - \${this.topUser.score}分\`)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin(10)
      }

      List() {
        ForEach(this.sortedUsers, (user: User, index: number) => {
          ListItem() {
            Row() {
              Text(\`\${index + 1}.\`)
                .width(30)
              Text(user.name)
                .layoutWeight(1)
              Text(\`\${user.score}分\`)
                .fontColor(Color.Blue)
            }
            .width('100%')
            .padding(10)
          }
        }, (user: User) => user.id)
      }
      .layoutWeight(1)

      Row() {
        TextInput({ placeholder: '输入分数搜索' })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.searchScore = parseInt(value) || 0;
          })

        Button('搜索')
          .onClick(() => {
            const found = this.userManager.findUser(this.searchScore);
            this.searchResult = found ? '找到匹配分数的用户' : '未找到匹配分数的用户';
          })
      }
      .margin(10)

      if (this.searchResult) {
        Text(this.searchResult)
          .fontSize(14)
          .fontColor(this.searchResult.includes('找到') ? Color.Green : Color.Red)
          .margin(10)
      }
    }
  }
}
\`\`\`

## 栈和队列实现

### 栈实现

\`\`\`typescript
export class Stack<T> {
  private items: T[] = [];
  
  push(item: T): void {
    this.items.push(item);
  }
  
  pop(): T | undefined {
    return this.items.pop();
  }
  
  peek(): T | undefined {
    return this.items[this.items.length - 1];
  }
  
  isEmpty(): boolean {
    return this.items.length === 0;
  }
  
  size(): number {
    return this.items.length;
  }
  
  clear(): void {
    this.items = [];
  }
}

// 应用示例：页面导航历史管理
export class NavigationHistory {
  private history: Stack<string> = new Stack();
  
  pushPage(pageName: string): void {
    this.history.push(pageName);
  }
  
  goBack(): string | undefined {
    return this.history.pop();
  }
  
  getCurrentPage(): string | undefined {
    return this.history.peek();
  }
  
  canGoBack(): boolean {
    return !this.history.isEmpty();
  }
}
\`\`\`

### 队列实现

\`\`\`typescript
export class Queue<T> {
  private items: T[] = [];
  
  enqueue(item: T): void {
    this.items.push(item);
  }
  
  dequeue(): T | undefined {
    return this.items.shift();
  }
  
  front(): T | undefined {
    return this.items[0];
  }
  
  isEmpty(): boolean {
    return this.items.length === 0;
  }
  
  size(): number {
    return this.items.length;
  }
}

// 应用示例：任务队列管理
export class TaskQueue {
  private tasks: Queue<Task> = new Queue();
  
  addTask(task: Task): void {
    this.tasks.enqueue(task);
  }
  
  processNextTask(): Task | undefined {
    return this.tasks.dequeue();
  }
  
  getNextTask(): Task | undefined {
    return this.tasks.front();
  }
  
  hasTask(): boolean {
    return !this.tasks.isEmpty();
  }
}

interface Task {
  id: string;
  name: string;
  priority: number;
}
\`\`\`

## 算法应用实例

### 排序算法

\`\`\`typescript
export class SortingAlgorithms {
  // 快速排序
  static quickSort<T>(arr: T[], compareFunction: (a: T, b: T) => number): T[] {
    if (arr.length <= 1) {
      return arr;
    }
    
    const pivot = arr[Math.floor(arr.length / 2)];
    const left = arr.filter(item => compareFunction(item, pivot) < 0);
    const middle = arr.filter(item => compareFunction(item, pivot) === 0);
    const right = arr.filter(item => compareFunction(item, pivot) > 0);
    
    return [
      ...this.quickSort(left, compareFunction),
      ...middle,
      ...this.quickSort(right, compareFunction)
    ];
  }
  
  // 归并排序
  static mergeSort<T>(arr: T[], compareFunction: (a: T, b: T) => number): T[] {
    if (arr.length <= 1) {
      return arr;
    }
    
    const middle = Math.floor(arr.length / 2);
    const left = arr.slice(0, middle);
    const right = arr.slice(middle);
    
    return this.merge(
      this.mergeSort(left, compareFunction),
      this.mergeSort(right, compareFunction),
      compareFunction
    );
  }
  
  private static merge<T>(left: T[], right: T[], compareFunction: (a: T, b: T) => number): T[] {
    const result: T[] = [];
    let leftIndex = 0;
    let rightIndex = 0;
    
    while (leftIndex < left.length && rightIndex < right.length) {
      if (compareFunction(left[leftIndex], right[rightIndex]) <= 0) {
        result.push(left[leftIndex]);
        leftIndex++;
      } else {
        result.push(right[rightIndex]);
        rightIndex++;
      }
    }
    
    return result.concat(left.slice(leftIndex)).concat(right.slice(rightIndex));
  }
}
\`\`\`

通过这些数据结构和算法的实现，可以在鸿蒙应用开发中提升性能，优化用户体验，并解决复杂的业务逻辑问题。`,
        author: 'ArkTS算法工程师',
        publishDate: '2024-02-25',
        readCount: 734,
        likeCount: 67,
        category: '进阶开发',
        tags: ['数据结构', '算法', '性能优化', '鸿蒙开发'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 20
      },
      {
        id: 11,
        title: 'ArkTS测试驱动开发实践',
        summary: '学习如何在ArkTS项目中实践测试驱动开发，编写高质量的测试代码。',
        content: `# ArkTS测试驱动开发实践

## 单元测试基础

\`\`\`typescript
import { describe, it, expect } from '@ohos/hypium'

class Calculator {
  static add(a: number, b: number): number {
    return a + b
  }
  
  static divide(a: number, b: number): number | Error {
    if (b === 0) {
      return new Error("除数不能为零")
    }
    return a / b
  }
}

// 测试用例
describe('Calculator', () => {
  it('should add two numbers correctly', () => {
    const result = Calculator.add(2, 3)
    expect(result).assertEqual(5)
  })

  it('should divide two numbers correctly', () => {
    const result = Calculator.divide(10, 2)
    expect(result).assertEqual(5)
  })

  it('should handle division by zero', () => {
    const result = Calculator.divide(10, 0)
    expect(result instanceof Error).assertTrue()
    expect((result as Error).message).assertEqual("除数不能为零")
  })
})
\`\`\`

## Mock和Stub

\`\`\`typescript
interface UserRepository {
  findById(id: string): User | null
  save(user: User): boolean
}

interface User {
  id: string
  name: string
  email: string
}

class MockUserRepository implements UserRepository {
  private users: Map<string, User> = new Map()
  
  findById(id: string): User | null {
    return this.users.get(id) || null
  }
  
  save(user: User): boolean {
    this.users.set(user.id, user)
    return true
  }
  
  addUser(user: User): void {
    this.users.set(user.id, user)
  }
}

class UserService {
  private repository: UserRepository
  
  constructor(repository: UserRepository) {
    this.repository = repository
  }
  
  getUserName(id: string): string | null {
    const user = this.repository.findById(id)
    return user ? user.name : null
  }
}

describe('UserService', () => {
  it('should get user name correctly', () => {
    const mockRepo = new MockUserRepository()
    const user: User = { id: "123", name: "张三", email: "zhang@example.com" }
    mockRepo.addUser(user)
    
    const service = new UserService(mockRepo)
    const name = service.getUserName("123")
    
    expect(name).assertEqual("张三")
  })
})
\`\`\``,
        author: '测试工程师',
        publishDate: '2024-03-01',
        readCount: 567,
        likeCount: 43,
        category: '最佳实践',
        tags: ['测试', 'TDD', 'Mock', '单元测试'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 18
      },
      {
        id: 12,
        title: 'ArkTS微服务架构设计',
        summary: '探索如何使用ArkTS构建可扩展的微服务架构，包括服务发现、负载均衡和容错处理。',
        content: `# ArkTS微服务架构设计

## 服务注册与发现

\`\`\`typescript
interface ServiceRegistry {
  register(service: ServiceInfo): Promise<boolean>
  discover(serviceName: string): Promise<ServiceInfo[]>
  unregister(serviceId: string): Promise<boolean>
}

interface ServiceInfo {
  id: string
  name: string
  host: string
  port: number
  healthCheckUrl: string
  weight?: number
}

class ServiceInfoImpl implements ServiceInfo {
  id: string
  name: string
  host: string
  port: number
  healthCheckUrl: string
  weight: number = 1
  
  constructor(id: string, name: string, host: string, port: number) {
    this.id = id
    this.name = name
    this.host = host
    this.port = port
    this.healthCheckUrl = \`http://\${host}:\${port}/health\`
  }
}

class EtcdServiceRegistry implements ServiceRegistry {
  private etcdClient: EtcdClient
  
  constructor(etcdEndpoints: string[]) {
    this.etcdClient = new EtcdClient(etcdEndpoints)
  }
  
  async register(service: ServiceInfo): Promise<boolean> {
    const key = \`/services/\${service.name}/\${service.id}\`
    const value = JSON.stringify(service)
    return await this.etcdClient.put(key, value)
  }
  
  async discover(serviceName: string): Promise<ServiceInfo[]> {
    const prefix = \`/services/\${serviceName}/\`
    const kvPairs = await this.etcdClient.getByPrefix(prefix)
    return kvPairs.map(kv => JSON.parse(kv.value) as ServiceInfo)
  }
}
\`\`\`

## 负载均衡

\`\`\`typescript
interface LoadBalancer {
  selectService(services: ServiceInfo[]): ServiceInfo | null
}

class RoundRobinLoadBalancer implements LoadBalancer {
  private currentIndex: number = 0
  
  selectService(services: ServiceInfo[]): ServiceInfo | null {
    if (services.length === 0) {
      return null
    }
    
    const service = services[this.currentIndex % services.length]
    this.currentIndex++
    return service
  }
}

class WeightedLoadBalancer implements LoadBalancer {
  selectService(services: ServiceInfo[]): ServiceInfo | null {
    if (services.length === 0) {
      return null
    }
    
    // 基于权重的选择算法
    const totalWeight = services.reduce((sum, s) => sum + (s.weight || 1), 0)
    const random = Math.floor(Math.random() * totalWeight)
    
    let currentWeight = 0
    for (const service of services) {
      currentWeight += service.weight || 1
      if (random < currentWeight) {
        return service
      }
    }
    
    return services[services.length - 1]
  }
}
\`\`\``,
        author: '微服务架构师',
        publishDate: '2024-03-05',
        readCount: 892,
        likeCount: 78,
        category: '实战项目',
        tags: ['微服务', '架构设计', '服务发现', '负载均衡'],
        coverImage: 'https://example.com/microservices-cangjie.jpg',
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 22
      },
      {
        id: 13,
        title: 'ArkTS数据库操作与ORM设计',
        summary: '学习如何在ArkTS中进行数据库操作，设计简洁高效的ORM框架。',
        content: `# ArkTS数据库操作与ORM设计

## 数据库连接

\`\`\`typescript
class DatabaseConfig {
    public let host: String
    public let port: Int
    public let database: String
    public let username: String
    public let password: String
    public let maxConnections: Int
    
    public init(host: String, port: Int, database: String, username: String, password: String, maxConnections: Int = 10) {
        this.host = host
        this.port = port
        this.database = database
        this.username = username
        this.password = password
        this.maxConnections = maxConnections
    }
}

class ConnectionPool {
    private let config: DatabaseConfig
    private var connections: Array<Connection> = []
    private let mutex = Mutex()
    
    public init(config: DatabaseConfig) {
        this.config = config
        this.initializePool()
    }
    
    public func getConnection(): Result<Connection, DatabaseError> {
        this.mutex.lock()
        defer { this.mutex.unlock() }
        
        if (this.connections.isEmpty()) {
            return this.createConnection()
        }
        
        return Ok(this.connections.removeLast())
    }
    
    public func returnConnection(conn: Connection) {
        this.mutex.lock()
        defer { this.mutex.unlock() }
        
        if (this.connections.size() < this.config.maxConnections) {
            this.connections.append(conn)
        } else {
            conn.close()
        }
    }
}
\`\`\`

## ORM实体映射

\`\`\`cangjie
@Table("users")
class User {
    @Id
    @Column("id")
    public var id: Option<Int> = None
    
    @Column("name")
    public var name: String = ""
    
    @Column("email")
    public var email: String = ""
    
    @Column("created_at")
    public var createdAt: DateTime = DateTime.now()
    
    public init() {}
    
    public init(name: String, email: String) {
        this.name = name
        this.email = email
    }
}

class Repository<T> {
    private let connectionPool: ConnectionPool
    private let entityClass: Class<T>
    
    public init(connectionPool: ConnectionPool, entityClass: Class<T>) {
        this.connectionPool = connectionPool
        this.entityClass = entityClass
    }
    
    public func save(entity: T): Result<T, DatabaseError> {
        match this.connectionPool.getConnection() {
            case Ok(conn) => {
                defer { this.connectionPool.returnConnection(conn) }
                
                let sql = this.generateInsertSql(entity)
                match conn.execute(sql) {
                    case Ok(result) => {
                        entity.setId(result.getGeneratedId())
                        return Ok(entity)
                    }
                    case Err(error) => return Err(error)
                }
            }
            case Err(error) => return Err(error)
        }
    }
    
    public func findById(id: Int): Result<Option<T>, DatabaseError> {
        match this.connectionPool.getConnection() {
            case Ok(conn) => {
                defer { this.connectionPool.returnConnection(conn) }
                
                let sql = "SELECT * FROM \${this.getTableName()} WHERE id = ?"
                match conn.query(sql, [id]) {
                    case Ok(resultSet) => {
                        if (resultSet.hasNext()) {
                            let entity = this.mapResultToEntity(resultSet.next())
                            return Ok(Some(entity))
                        } else {
                            return Ok(None)
                        }
                    }
                    case Err(error) => return Err(error)
                }
            }
            case Err(error) => return Err(error)
        }
    }
}
\`\`\``,
        author: '数据库专家',
        publishDate: '2024-03-10',
        readCount: 1156,
        likeCount: 89,
        category: '实战项目',
        tags: ['数据库', 'ORM', '连接池', '实体映射'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 18
      },
      {
        id: 14,
        title: '仓颉语言响应式编程模式',
        summary: '探索仓颉语言中的响应式编程模式，学习如何处理异步数据流和事件。',
        content: `# 仓颉语言响应式编程模式

## Observable模式

\`\`\`cangjie
interface Observer<T> {
    func onNext(value: T): Unit
    func onError(error: Exception): Unit
    func onComplete(): Unit
}

class Observable<T> {
    private var observers: Array<Observer<T>> = []
    
    public func subscribe(observer: Observer<T>): Subscription {
        this.observers.append(observer)
        return Subscription({ => this.unsubscribe(observer) })
    }
    
    public func emit(value: T) {
        for (observer in this.observers) {
            observer.onNext(value)
        }
    }
    
    public func error(error: Exception) {
        for (observer in this.observers) {
            observer.onError(error)
        }
    }
    
    public func complete() {
        for (observer in this.observers) {
            observer.onComplete()
        }
    }
    
    public func map<R>(transform: (T) -> R): Observable<R> {
        let mapped = Observable<R>()
        this.subscribe({
            onNext: { value => mapped.emit(transform(value)) },
            onError: { error => mapped.error(error) },
            onComplete: { => mapped.complete() }
        })
        return mapped
    }
    
    public func filter(predicate: (T) -> Bool): Observable<T> {
        let filtered = Observable<T>()
        this.subscribe({
            onNext: { value => 
                if (predicate(value)) {
                    filtered.emit(value)
                }
            },
            onError: { error => filtered.error(error) },
            onComplete: { => filtered.complete() }
        })
        return filtered
    }
}
\`\`\`

## 事件流处理

\`\`\`cangjie
class EventStream<T> {
    private let observable: Observable<T>
    
    public init() {
        this.observable = Observable<T>()
    }
    
    public func publish(event: T) {
        this.observable.emit(event)
    }
    
    public func subscribe(handler: (T) -> Unit): Subscription {
        return this.observable.subscribe({
            onNext: handler,
            onError: { error => println("事件流错误: \${error.message}") },
            onComplete: { => println("事件流完成") }
        })
    }
    
    public func debounce(timeMs: Int): EventStream<T> {
        let debounced = EventStream<T>()
        var lastEmitTime: Option<DateTime> = None
        
        this.subscribe({ event =>
            let now = DateTime.now()
            lastEmitTime = Some(now)
            
            Timer.schedule(timeMs, {
                match lastEmitTime {
                    case Some(time) => {
                        if (now.equals(time)) {
                            debounced.publish(event)
                        }
                    }
                    case None => {}
                }
            })
        })
        
        return debounced
    }
}
\`\`\``,
        author: '响应式编程专家',
        publishDate: '2024-03-15',
        readCount: 678,
        likeCount: 56,
        category: '函数编程',
        tags: ['响应式编程', 'Observable', '事件流', '异步'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 16
      },
      {
        id: 15,
        title: '仓颉语言移动应用开发实战',
        summary: '使用仓颉语言开发跨平台移动应用，掌握UI组件、状态管理和原生交互。',
        content: `# 仓颉语言移动应用开发实战

## 组件化开发

\`\`\`cangjie
@Component
struct CustomButton {
    @Prop text: String = ""
    @Prop onClick: () -> Unit = { => }
    @Prop disabled: Bool = false
    @State isPressed: Bool = false
    
    build() {
        Button(this.text)
            .enabled(!this.disabled)
            .backgroundColor(this.getBackgroundColor())
            .fontColor(this.disabled ? Color.Gray : Color.White)
            .borderRadius(8)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .onTouch({ event =>
                if (event.type == TouchType.Down) {
                    this.isPressed = true
                } else if (event.type == TouchType.Up) {
                    this.isPressed = false
                    if (!this.disabled) {
                        this.onClick()
                    }
                }
            })
    }
    
    private func getBackgroundColor(): Color {
        if (this.disabled) {
            return Color.Gray
        } else if (this.isPressed) {
            return Color.Blue.darker()
        } else {
            return Color.Blue
        }
    }
}
\`\`\`

## 状态管理

\`\`\`cangjie
class AppState {
    @State var user: Option<User> = None
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    public func login(username: String, password: String) {
        this.isLoading = true
        this.errorMessage = ""
        
        AuthService.login(username, password)
            .then({ user =>
                this.user = Some(user)
                this.isLoading = false
            })
            .catch({ error =>
                this.errorMessage = error.message
                this.isLoading = false
            })
    }
    
    public func logout() {
        this.user = None
        AuthService.logout()
    }
}

@Entry
@Component
struct LoginPage {
    @State username: String = ""
    @State password: String = ""
    @StorageLink("appState") appState: AppState = AppState()
    
    build() {
        Column() {
            TextInput({ placeholder: "用户名", text: this.username })
                .onChange({ value => this.username = value })
                .margin({ bottom: 16 })
            
            TextInput({ placeholder: "密码", text: this.password })
                .type(InputType.Password)
                .onChange({ value => this.password = value })
                .margin({ bottom: 24 })
            
            CustomButton({
                text: this.appState.isLoading ? "登录中..." : "登录",
                disabled: this.appState.isLoading,
                onClick: { => this.handleLogin() }
            })
            
            if (this.appState.errorMessage.isNotEmpty()) {
                Text(this.appState.errorMessage)
                    .fontColor(Color.Red)
                    .margin({ top: 16 })
            }
        }
        .padding(24)
    }
    
    private func handleLogin() {
        if (this.username.isEmpty() || this.password.isEmpty()) {
            this.appState.errorMessage = "请输入用户名和密码"
            return
        }
        
        this.appState.login(this.username, this.password)
    }
}
\`\`\``,
        author: '移动开发工程师',
        publishDate: '2024-03-20',
        readCount: 1234,
        likeCount: 98,
        category: '实战项目',
        tags: ['移动开发', 'UI组件', '状态管理', '跨平台'],
        coverImage: 'https://example.com/mobile-dev-cangjie.jpg',
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 20
      },
      {
        id: 16,
        title: '仓颉语言编译器原理与实现',
        summary: '深入了解仓颉语言编译器的工作原理，学习词法分析、语法分析和代码生成。',
        content: `# 仓颉语言编译器原理与实现

## 词法分析器

\`\`\`cangjie
enum TokenType {
    IDENTIFIER,
    NUMBER,
    STRING,
    KEYWORD,
    OPERATOR,
    DELIMITER,
    EOF
}

class Token {
    public let type: TokenType
    public let value: String
    public let line: Int
    public let column: Int
    
    public init(type: TokenType, value: String, line: Int, column: Int) {
        this.type = type
        this.value = value
        this.line = line
        this.column = column
    }
}

class Lexer {
    private let source: String
    private var position: Int = 0
    private var line: Int = 1
    private var column: Int = 1
    
    public init(source: String) {
        this.source = source
    }
    
    public func nextToken(): Token {
        this.skipWhitespace()
        
        if (this.position >= this.source.length()) {
            return Token(TokenType.EOF, "", this.line, this.column)
        }
        
        let char = this.currentChar()
        
        if (char.isLetter() || char == '_') {
            return this.readIdentifier()
        } else if (char.isDigit()) {
            return this.readNumber()
        } else if (char == '"') {
            return this.readString()
        } else {
            return this.readOperatorOrDelimiter()
        }
    }
    
    private func readIdentifier(): Token {
        let start = this.position
        let startColumn = this.column
        
        while (this.position < this.source.length() && 
               (this.currentChar().isAlphaNumeric() || this.currentChar() == '_')) {
            this.advance()
        }
        
        let value = this.source.substring(start, this.position)
        let type = this.isKeyword(value) ? TokenType.KEYWORD : TokenType.IDENTIFIER
        
        return Token(type, value, this.line, startColumn)
    }
    
    private func readNumber(): Token {
        let start = this.position
        let startColumn = this.column
        
        while (this.position < this.source.length() && 
               (this.currentChar().isDigit() || this.currentChar() == '.')) {
            this.advance()
        }
        
        let value = this.source.substring(start, this.position)
        return Token(TokenType.NUMBER, value, this.line, startColumn)
    }
}
\`\`\`

## 语法分析器

\`\`\`cangjie
abstract class ASTNode {
    public abstract func accept<T>(visitor: ASTVisitor<T>): T
}

class BinaryExpression <: ASTNode {
    public let left: ASTNode
    public let operator: Token
    public let right: ASTNode
    
    public init(left: ASTNode, operator: Token, right: ASTNode) {
        this.left = left
        this.operator = operator
        this.right = right
    }
    
    public override func accept<T>(visitor: ASTVisitor<T>): T {
        return visitor.visitBinaryExpression(this)
    }
}

class Parser {
    private let tokens: Array<Token>
    private var current: Int = 0
    
    public init(tokens: Array<Token>) {
        this.tokens = tokens
    }
    
    public func parse(): ASTNode {
        return this.expression()
    }
    
    private func expression(): ASTNode {
        return this.addition()
    }
    
    private func addition(): ASTNode {
        var expr = this.multiplication()
        
        while (this.match(["+", "-"])) {
            let operator = this.previous()
            let right = this.multiplication()
            expr = BinaryExpression(expr, operator, right)
        }
        
        return expr
    }
    
    private func multiplication(): ASTNode {
        var expr = this.primary()
        
        while (this.match(["*", "/"])) {
            let operator = this.previous()
            let right = this.primary()
            expr = BinaryExpression(expr, operator, right)
        }
        
        return expr
    }
}
\`\`\``,
        author: '编译器专家',
        publishDate: '2024-03-25',
        readCount: 456,
        likeCount: 34,
        category: '基础语法',
        tags: ['编译器', '词法分析', '语法分析', 'AST'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 25
      },
      {
        id: 10,
        title: '仓颉语言数据结构与算法实现',
        summary: '深入学习仓颉语言中的数据结构实现，包括链表、树、图等经典算法。',
        content: `# 仓颉语言数据结构与算法实现

## 链表实现

\`\`\`cangjie
class ListNode<T> {
    public var data: T
    public var next: Option<ListNode<T>>
    
    public init(data: T) {
        this.data = data
        this.next = None
    }
}

class LinkedList<T> {
    private var head: Option<ListNode<T>> = None
    private var size: Int = 0
    
    public func append(data: T) {
        let newNode = ListNode(data)
        match this.head {
            case None => this.head = Some(newNode)
            case Some(headNode) => {
                var current = headNode
                while (let nextNode = current.next) {
                    current = nextNode
                }
                current.next = Some(newNode)
            }
        }
        this.size += 1
    }
    
    public func get(index: Int): Option<T> {
        if (index < 0 || index >= this.size) {
            return None
        }
        
        var current = this.head
        for (i in 0..<index) {
            match current {
                case Some(node) => current = node.next
                case None => return None
            }
        }
        
        match current {
            case Some(node) => return Some(node.data)
            case None => return None
        }
    }
}
\`\`\`

## 二叉搜索树

\`\`\`cangjie
class TreeNode<T where T: Comparable> {
    public var data: T
    public var left: Option<TreeNode<T>>
    public var right: Option<TreeNode<T>>
    
    public init(data: T) {
        this.data = data
        this.left = None
        this.right = None
    }
}

class BinarySearchTree<T where T: Comparable> {
    private var root: Option<TreeNode<T>> = None
    
    public func insert(data: T) {
        this.root = this.insertNode(this.root, data)
    }
    
    private func insertNode(node: Option<TreeNode<T>>, data: T): TreeNode<T> {
        match node {
            case None => return TreeNode(data)
            case Some(currentNode) => {
                if (data < currentNode.data) {
                    currentNode.left = Some(this.insertNode(currentNode.left, data))
                } else if (data > currentNode.data) {
                    currentNode.right = Some(this.insertNode(currentNode.right, data))
                }
                return currentNode
            }
        }
    }
    
    public func search(data: T): Bool {
        return this.searchNode(this.root, data)
    }
    
    private func searchNode(node: Option<TreeNode<T>>, data: T): Bool {
        match node {
            case None => return false
            case Some(currentNode) => {
                if (data == currentNode.data) {
                    return true
                } else if (data < currentNode.data) {
                    return this.searchNode(currentNode.left, data)
                } else {
                    return this.searchNode(currentNode.right, data)
                }
            }
        }
    }
}
\`\`\``,
        author: '算法工程师',
        publishDate: '2024-02-25',
        readCount: 734,
        likeCount: 67,
        category: '基础语法',
        tags: ['数据结构', '算法', '链表', '二叉树'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 20
      },
      {
        id: 17,
        title: '仓颉语言测试驱动开发实践',
        summary: '学习如何在仓颉语言项目中实践测试驱动开发，编写高质量的测试代码。',
        content: `# 仓颉语言测试驱动开发实践

## 单元测试基础

\`\`\`cangjie
import test.Assert

class Calculator {
    public static func add(a: Int, b: Int): Int {
        return a + b
    }
    
    public static func divide(a: Int, b: Int): Result<Int, String> {
        if (b == 0) {
            return Err("除数不能为零")
        }
        return Ok(a / b)
    }
}

// 测试用例
@Test
func testAdd() {
    let result = Calculator.add(2, 3)
    Assert.assertEquals(5, result)
}

@Test
func testDivide() {
    match Calculator.divide(10, 2) {
        case Ok(result) => Assert.assertEquals(5, result)
        case Err(_) => Assert.fail("不应该出现错误")
    }
}

@Test
func testDivideByZero() {
    match Calculator.divide(10, 0) {
        case Ok(_) => Assert.fail("应该返回错误")
        case Err(message) => Assert.assertEquals("除数不能为零", message)
    }
}
\`\`\`

## Mock和Stub

\`\`\`cangjie
interface UserRepository {
    func findById(id: String): Option<User>
    func save(user: User): Bool
}

class MockUserRepository <: UserRepository {
    private var users: Map<String, User> = Map()
    
    public func findById(id: String): Option<User> {
        return this.users.get(id)
    }
    
    public func save(user: User): Bool {
        this.users.put(user.id, user)
        return true
    }
    
    public func addUser(user: User) {
        this.users.put(user.id, user)
    }
}

class UserService {
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        this.repository = repository
    }
    
    public func getUserName(id: String): Option<String> {
        match this.repository.findById(id) {
            case Some(user) => return Some(user.name)
            case None => return None
        }
    }
}

@Test
func testGetUserName() {
    let mockRepo = MockUserRepository()
    let user = User("123", "张三", "zhang@example.com")
    mockRepo.addUser(user)
    
    let service = UserService(mockRepo)
    let name = service.getUserName("123")
    
    Assert.assertEquals(Some("张三"), name)
}
\`\`\``,
        author: '测试工程师',
        publishDate: '2024-03-01',
        readCount: 567,
        likeCount: 43,
        category: '最佳实践',
        tags: ['测试', 'TDD', 'Mock', '单元测试'],
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 12
      },
      {
        id: 18,
        title: '仓颉语言游戏开发入门',
        summary: '使用仓颉语言开发2D游戏，学习游戏循环、碰撞检测和动画系统。',
        content: `# 仓颉语言游戏开发入门

## 游戏引擎基础

\`\`\`cangjie
class GameEngine {
    private var isRunning: Bool = false
    private var scenes: Map<String, Scene> = Map()
    private var currentScene: Option<Scene> = None
    private let renderer: Renderer
    private let inputManager: InputManager
    
    public init() {
        this.renderer = Renderer()
        this.inputManager = InputManager()
    }
    
    public func start() {
        this.isRunning = true
        this.gameLoop()
    }
    
    private func gameLoop() {
        let targetFPS = 60
        let frameTime = 1000 / targetFPS
        
        while (this.isRunning) {
            let startTime = Time.now()
            
            this.update()
            this.render()
            
            let elapsed = Time.now() - startTime
            if (elapsed < frameTime) {
                Thread.sleep(frameTime - elapsed)
            }
        }
    }
    
    private func update() {
        this.inputManager.update()
        match this.currentScene {
            case Some(scene) => scene.update()
            case None => {}
        }
    }
    
    private func render() {
        this.renderer.clear()
        match this.currentScene {
            case Some(scene) => scene.render(this.renderer)
            case None => {}
        }
        this.renderer.present()
    }
}
\`\`\`

## 游戏对象系统

\`\`\`cangjie
class GameObject {
    public var position: Vector2
    public var velocity: Vector2
    public var size: Vector2
    public var active: Bool = true
    private var components: Array<Component> = []
    
    public init(x: Float, y: Float) {
        this.position = Vector2(x, y)
        this.velocity = Vector2(0, 0)
        this.size = Vector2(32, 32)
    }
    
    public func addComponent<T where T: Component>(component: T) {
        this.components.append(component)
        component.setOwner(this)
    }
    
    public func getComponent<T where T: Component>(): Option<T> {
        for (component in this.components) {
            if (component is T) {
                return Some(component as T)
            }
        }
        return None
    }
    
    public func update(deltaTime: Float) {
        if (!this.active) return
        
        this.position.x += this.velocity.x * deltaTime
        this.position.y += this.velocity.y * deltaTime
        
        for (component in this.components) {
            component.update(deltaTime)
        }
    }
}

class Player <: GameObject {
    private let speed: Float = 200.0
    
    public init(x: Float, y: Float) {
        super(x, y)
        this.addComponent(SpriteRenderer("player.png"))
        this.addComponent(Collider(this.size))
    }
    
    public override func update(deltaTime: Float) {
        this.handleInput()
        super.update(deltaTime)
    }
    
    private func handleInput() {
        this.velocity.x = 0
        this.velocity.y = 0
        
        if (Input.isKeyPressed(Key.LEFT)) {
            this.velocity.x = -this.speed
        }
        if (Input.isKeyPressed(Key.RIGHT)) {
            this.velocity.x = this.speed
        }
        if (Input.isKeyPressed(Key.UP)) {
            this.velocity.y = -this.speed
        }
        if (Input.isKeyPressed(Key.DOWN)) {
            this.velocity.y = this.speed
        }
    }
}
\`\`\``,
        author: '游戏开发者',
        publishDate: '2024-03-30',
        readCount: 1089,
        likeCount: 134,
        category: '实战项目',
        tags: ['游戏开发', '2D游戏', '游戏引擎', '碰撞检测'],
        coverImage: 'https://example.com/game-dev-cangjie.jpg',
        hasCode: true,
        difficulty: 'intermediate',
        estimatedReadTime: 24
      },
      {
        id: 19,
        title: '仓颉语言区块链开发实战',
        summary: '学习使用仓颉语言开发区块链应用，包括智能合约、共识算法和加密技术。',
        content: `# 仓颉语言区块链开发实战

## 区块链基础结构

\`\`\`cangjie
class Block {
    public let index: Int
    public let timestamp: DateTime
    public let data: String
    public let previousHash: String
    public let hash: String
    public let nonce: Int
    
    public init(index: Int, data: String, previousHash: String) {
        this.index = index
        this.timestamp = DateTime.now()
        this.data = data
        this.previousHash = previousHash
        let (hash, nonce) = this.mineBlock()
        this.hash = hash
        this.nonce = nonce
    }
    
    private func calculateHash(nonce: Int): String {
        let input = "\${this.index}\${this.timestamp}\${this.data}\${this.previousHash}\${nonce}"
        return SHA256.hash(input)
    }
    
    private func mineBlock(): (String, Int) {
        let difficulty = 4
        let target = "0".repeat(difficulty)
        var nonce = 0
        
        while (true) {
            let hash = this.calculateHash(nonce)
            if (hash.startsWith(target)) {
                return (hash, nonce)
            }
            nonce += 1
        }
    }
    
    public func isValid(): Bool {
        let calculatedHash = this.calculateHash(this.nonce)
        return calculatedHash == this.hash
    }
}

class Blockchain {
    private var chain: Array<Block> = []
    
    public init() {
        this.chain.append(this.createGenesisBlock())
    }
    
    private func createGenesisBlock(): Block {
        return Block(0, "Genesis Block", "0")
    }
    
    public func getLatestBlock(): Block {
        return this.chain.last()
    }
    
    public func addBlock(data: String) {
        let previousBlock = this.getLatestBlock()
        let newBlock = Block(
            previousBlock.index + 1,
            data,
            previousBlock.hash
        )
        this.chain.append(newBlock)
    }
    
    public func isChainValid(): Bool {
        for (i in 1..<this.chain.size()) {
            let currentBlock = this.chain[i]
            let previousBlock = this.chain[i - 1]
            
            if (!currentBlock.isValid()) {
                return false
            }
            
            if (currentBlock.previousHash != previousBlock.hash) {
                return false
            }
        }
        return true
    }
}
\`\`\`

## 智能合约

\`\`\`cangjie
abstract class SmartContract {
    protected var state: Map<String, Any> = Map()
    protected let owner: String
    
    public init(owner: String) {
        this.owner = owner
    }
    
    public abstract func execute(method: String, params: Map<String, Any>): Result<Any, String>
    
    protected func requireOwner(caller: String): Result<Unit, String> {
        if (caller != this.owner) {
            return Err("只有合约所有者可以执行此操作")
        }
        return Ok(())
    }
}

class TokenContract <: SmartContract {
    public init(owner: String, totalSupply: Int) {
        super(owner)
        this.state.put("totalSupply", totalSupply)
        this.state.put("balances", Map<String, Int>())
        
        let balances = this.state.get("balances") as Map<String, Int>
        balances.put(owner, totalSupply)
    }
    
    public override func execute(method: String, params: Map<String, Any>): Result<Any, String> {
        match method {
            case "transfer" => return this.transfer(params)
            case "balanceOf" => return this.balanceOf(params)
            case "mint" => return this.mint(params)
            default => return Err("未知方法: \${method}")
        }
    }
    
    private func transfer(params: Map<String, Any>): Result<Any, String> {
        let from = params.get("from") as String
        let to = params.get("to") as String
        let amount = params.get("amount") as Int
        
        let balances = this.state.get("balances") as Map<String, Int>
        let fromBalance = balances.get(from).getOrElse(0)
        
        if (fromBalance < amount) {
            return Err("余额不足")
        }
        
        balances.put(from, fromBalance - amount)
        let toBalance = balances.get(to).getOrElse(0)
        balances.put(to, toBalance + amount)
        
        return Ok(true)
    }
    
    private func balanceOf(params: Map<String, Any>): Result<Any, String> {
        let address = params.get("address") as String
        let balances = this.state.get("balances") as Map<String, Int>
        let balance = balances.get(address).getOrElse(0)
        return Ok(balance)
    }
}
\`\`\``,
        author: '区块链开发者',
        publishDate: '2024-04-05',
        readCount: 567,
        likeCount: 45,
        category: '实战项目',
        tags: ['区块链', '智能合约', '加密技术', '共识算法'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 28
      },
      {
        id: 20,
        title: '仓颉语言机器学习基础',
        summary: '探索仓颉语言在机器学习领域的应用，实现基础的机器学习算法。',
        content: `# 仓颉语言机器学习基础

## 线性回归实现

\`\`\`cangjie
class Matrix {
    private let data: Array<Array<Float>>
    public let rows: Int
    public let cols: Int
    
    public init(rows: Int, cols: Int) {
        this.rows = rows
        this.cols = cols
        this.data = Array<Array<Float>>()
        for (i in 0..<rows) {
            let row = Array<Float>()
            for (j in 0..<cols) {
                row.append(0.0)
            }
            this.data.append(row)
        }
    }
    
    public func get(row: Int, col: Int): Float {
        return this.data[row][col]
    }
    
    public func set(row: Int, col: Int, value: Float) {
        this.data[row][col] = value
    }
    
    public func multiply(other: Matrix): Matrix {
        if (this.cols != other.rows) {
            throw Exception("矩阵维度不匹配")
        }
        
        let result = Matrix(this.rows, other.cols)
        for (i in 0..<this.rows) {
            for (j in 0..<other.cols) {
                var sum: Float = 0.0
                for (k in 0..<this.cols) {
                    sum += this.get(i, k) * other.get(k, j)
                }
                result.set(i, j, sum)
            }
        }
        return result
    }
    
    public func transpose(): Matrix {
        let result = Matrix(this.cols, this.rows)
        for (i in 0..<this.rows) {
            for (j in 0..<this.cols) {
                result.set(j, i, this.get(i, j))
            }
        }
        return result
    }
}

class LinearRegression {
    private var weights: Option<Matrix> = None
    private var bias: Float = 0.0
    
    public func fit(X: Matrix, y: Array<Float>, learningRate: Float = 0.01, epochs: Int = 1000) {
        let m = X.rows
        let n = X.cols
        
        // 初始化权重
        this.weights = Some(Matrix(n, 1))
        for (i in 0..<n) {
            this.weights!.set(i, 0, Random.nextFloat() * 0.01)
        }
        
        // 梯度下降
        for (epoch in 0..<epochs) {
            let predictions = this.predict(X)
            let cost = this.calculateCost(predictions, y)
            
            // 计算梯度
            let dw = Matrix(n, 1)
            var db: Float = 0.0
            
            for (i in 0..<m) {
                let error = predictions[i] - y[i]
                db += error
                for (j in 0..<n) {
                    let currentDw = dw.get(j, 0)
                    dw.set(j, 0, currentDw + error * X.get(i, j))
                }
            }
            
            // 更新参数
            for (j in 0..<n) {
                let currentWeight = this.weights!.get(j, 0)
                this.weights!.set(j, 0, currentWeight - learningRate * dw.get(j, 0) / m)
            }
            this.bias -= learningRate * db / m
            
            if (epoch % 100 == 0) {
                println("Epoch \${epoch}, Cost: \${cost}")
            }
        }
    }
    
    public func predict(X: Matrix): Array<Float> {
        match this.weights {
            case Some(w) => {
                let predictions = Array<Float>()
                for (i in 0..<X.rows) {
                    var prediction: Float = this.bias
                    for (j in 0..<X.cols) {
                        prediction += X.get(i, j) * w.get(j, 0)
                    }
                    predictions.append(prediction)
                }
                return predictions
            }
            case None => throw Exception("模型尚未训练")
        }
    }
    
    private func calculateCost(predictions: Array<Float>, actual: Array<Float>): Float {
        var cost: Float = 0.0
        for (i in 0..<predictions.size()) {
            let error = predictions[i] - actual[i]
            cost += error * error
        }
        return cost / (2.0 * predictions.size())
    }
}
\`\`\`

## 神经网络基础

\`\`\`cangjie
class NeuralNetwork {
    private let layers: Array<Int>
    private var weights: Array<Matrix> = []
    private var biases: Array<Matrix> = []
    
    public init(layers: Array<Int>) {
        this.layers = layers
        this.initializeWeights()
    }
    
    private func initializeWeights() {
        for (i in 0..<this.layers.size() - 1) {
            let inputSize = this.layers[i]
            let outputSize = this.layers[i + 1]
            
            let weight = Matrix(inputSize, outputSize)
            for (j in 0..<inputSize) {
                for (k in 0..<outputSize) {
                    weight.set(j, k, Random.nextGaussian() * 0.1)
                }
            }
            this.weights.append(weight)
            
            let bias = Matrix(1, outputSize)
            for (k in 0..<outputSize) {
                bias.set(0, k, 0.0)
            }
            this.biases.append(bias)
        }
    }
    
    public func forward(input: Matrix): Matrix {
        var activation = input
        
        for (i in 0..<this.weights.size()) {
            let z = activation.multiply(this.weights[i])
            // 添加偏置
            for (j in 0..<z.rows) {
                for (k in 0..<z.cols) {
                    let value = z.get(j, k) + this.biases[i].get(0, k)
                    z.set(j, k, this.sigmoid(value))
                }
            }
            activation = z
        }
        
        return activation
    }
    
    private func sigmoid(x: Float): Float {
        return 1.0 / (1.0 + Math.exp(-x))
    }
}
\`\`\``,
        author: '机器学习工程师',
        publishDate: '2024-04-10',
        readCount: 789,
        likeCount: 67,
        category: '高级特性',
        tags: ['机器学习', '线性回归', '神经网络', '算法'],
        hasCode: true,
        difficulty: 'advanced',
        estimatedReadTime: 22
      }
    ]

    this.filterArticles()
    this.isLoading = false
  }

  filterArticles() {
    let filtered = this.articles
    
    // 按分类筛选
    if (this.selectedCategory !== '全部') {
      filtered = filtered.filter(article => article.category === this.selectedCategory)
    }
    
    // 按搜索文本筛选
    if (this.searchText.length > 0) {
      const searchLower = this.searchText.toLowerCase()
      filtered = filtered.filter(article => 
        article.title.toLowerCase().includes(searchLower) ||
        article.summary.toLowerCase().includes(searchLower) ||
        article.tags.some(tag => tag.toLowerCase().includes(searchLower))
      )
    }
    
    this.filteredArticles = filtered
  }

  getDifficultyColor(difficulty: string): string {
    switch (difficulty) {
      case 'beginner': return '#4CAF50'
      case 'intermediate': return '#FF9800'
      case 'advanced': return '#F44336'
      default: return '#666666'
    }
  }

  getDifficultyText(difficulty: string): string {
    switch (difficulty) {
      case 'beginner': return '入门'
      case 'intermediate': return '进阶'
      case 'advanced': return '高级'
      default: return '未知'
    }
  }

  build() {
    Column() {
      // 顶部搜索和筛选区域
      this.HeaderSection()
      
      if (this.isLoading) {
        this.LoadingSection()
      } else {
        // 网格内容区域
        this.GridSection()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder HeaderSection() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .fillColor('#333333')
          .onClick(() => {
            router.back()
          })
        
        Text('知识库')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        
        // 占位，保持标题居中
        Row().width(24).height(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      
      // 搜索框
      Row() {
        Image($r('app.media.ic_search'))
          .width(20)
          .height(20)
          .fillColor('#999999')
          .margin({ right: 8 })
        
        TextInput({ placeholder: '搜索技术文章...', text: this.searchText })
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .border({ width: 0 })
          .onChange((value: string) => {
            this.searchText = value
            this.filterArticles()
          })
      }
      .width('100%')
      .height(40)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#F8F9FA')
      .borderRadius(20)
      .margin({ left: 16, right: 16, top: 12, bottom: 12 })
      
      // 分类筛选
      Scroll() {
        Row() {
          ForEach(this.categories, (category: string) => {
            Text(category)
              .fontSize(14)
              .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#666666')
              .backgroundColor(this.selectedCategory === category ? '#007AFF' : '#FFFFFF')
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .borderRadius(16)
              .border({ 
                width: 1, 
                color: this.selectedCategory === category ? '#007AFF' : '#E5E5E5' 
              })
              .margin({ right: 8 })
              .onClick(() => {
                this.selectedCategory = category
                this.filterArticles()
              })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .margin({ bottom: 12 })
    }
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }

  @Builder LoadingSection() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#007AFF')
      
      Text('加载中...')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder GridSection() {
    Scroll() {
      Grid() {
        ForEach(this.filteredArticles, (article: ArticleData) => {
          GridItem() {
            this.ArticleCard(article)
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
  }

  @Builder ArticleCard(article: ArticleData) {
    Column() {
      // 封面图片（如果有）
      if (article.coverImage) {
        Image(article.coverImage)
          .width('100%')
          .height(100)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: 12, topRight: 12 })
          .alt('文章封面')
      }
      
      // 文章内容
      Column() {
        // 标题
        Text(article.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)
          .width('100%')
          .margin({ bottom: 8 })
        
        // 摘要
        Text(article.summary)
          .fontSize(13)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(18)
          .width('100%')
          .margin({ bottom: 10 })
        
        // 标签
        if (article.tags.length > 0) {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(article.tags.slice(0, 2), (tag: string) => {
              Text(`#${tag}`)
                .fontSize(11)
                .fontColor('#007AFF')
                .backgroundColor('#F0F8FF')
                .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                .borderRadius(6)
                .margin({ right: 4, bottom: 4 })
            })
          }
          .width('100%')
          .margin({ bottom: 10 })
        }
        
        Blank()
        
        // 底部信息
        Row() {
          // 难度标识
          Text(this.getDifficultyText(article.difficulty))
            .fontSize(11)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getDifficultyColor(article.difficulty))
            .padding({ left: 6, right: 6, top: 3, bottom: 3 })
            .borderRadius(8)
          
          Blank()
          
          // 阅读时间
          Row() {
            Image($r('app.media.ic_time'))
              .width(12)
              .height(12)
              .fillColor('#999999')
              .margin({ right: 3 })
            
            Text(`${article.estimatedReadTime}分钟`)
              .fontSize(11)
              .fontColor('#999999')
          }
        }
        .width('100%')
        .margin({ bottom: 8 })
        
        // 作者和阅读量
        Row() {
          Text(article.author)
            .fontSize(11)
            .fontColor('#666666')
            .layoutWeight(1)
          
          Row() {
            Image($r('app.media.ic_statistics'))
              .width(12)
              .height(12)
              .fillColor('#999999')
              .margin({ right: 3 })
            
            Text(article.readCount.toString())
              .fontSize(11)
              .fontColor('#999999')
          }
        }
        .width('100%')
      }
      .padding(12)
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height(280)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      // 跳转到文章详情页
      router.pushUrl({
        url: 'pages/ArticleDetailPage',
        params: { article: article }
      })
    })
  }
}