import router from '@ohos.router';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

// 代码模板接口
interface CodeTemplate {
  id: number;
  name: string;
  category: string;
  description: string;
  code: string;
  parameters?: TemplateParameter[];
}

// 模板参数接口
interface TemplateParameter {
  name: string;
  label: string;
  type: 'string' | 'number' | 'boolean';
  defaultValue: string;
  placeholder?: string;
}

@Entry
@Component
struct CodeGeneratorPage {
  @State selectedCategory: string = '全部';
  @State selectedTemplate: CodeTemplate | null = null;
  @State generatedCode: string = '';
  @State parameterValues: Record<string, string> = {};
  @State searchText: string = '';
  @State showPreview: boolean = false;
  @State filteredTemplates: CodeTemplate[] = [];
  @State categories: string[] = ['全部'];

  // 代码模板数据
  private codeTemplates: CodeTemplate[] = [
    {
      id: 1,
      name: '基础页面模板',
      category: '页面模板',
      description: '创建一个基础的鸿蒙页面结构',
      code: `import router from '@ohos.router';

@Entry
@Component
struct {{pageName}}Page {
  @State title: string = '{{pageTitle}}';

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
        
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 页面内容
      Column() {
        Text('{{pageContent}}')
          .fontSize(16)
          .fontColor('#333333')
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}`,
      parameters: [
        { name: 'pageName', label: '页面名称', type: 'string', defaultValue: 'Demo', placeholder: '输入页面名称' },
        { name: 'pageTitle', label: '页面标题', type: 'string', defaultValue: '演示页面', placeholder: '输入页面标题' },
        { name: 'pageContent', label: '页面内容', type: 'string', defaultValue: '这是页面内容', placeholder: '输入页面内容' }
      ]
    },
    {
      id: 2,
      name: '列表页面模板',
      category: '页面模板',
      description: '创建带有列表的页面模板',
      code: `import router from '@ohos.router';

interface {{itemType}} {
  id: number;
  title: string;
  subtitle?: string;
}

@Entry
@Component
struct {{pageName}}Page {
  @State dataList: {{itemType}}[] = [
    { id: 1, title: '示例项目1', subtitle: '这是第一个示例' },
    { id: 2, title: '示例项目2', subtitle: '这是第二个示例' },
    { id: 3, title: '示例项目3', subtitle: '这是第三个示例' }
  ];

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text('{{pageTitle}}')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
        
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 列表内容
      List({ space: 8 }) {
        ForEach(this.dataList, (item: {{itemType}}) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .alignSelf(ItemAlign.Start)
                
                if (item.subtitle) {
                  Text(item.subtitle)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)
                    .margin({ top: 4 })
                }
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(16)
                .height(16)
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .onClick(() => {
              console.log('点击了项目：', item.title);
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}`,
      parameters: [
        { name: 'pageName', label: '页面名称', type: 'string', defaultValue: 'List', placeholder: '输入页面名称' },
        { name: 'pageTitle', label: '页面标题', type: 'string', defaultValue: '列表页面', placeholder: '输入页面标题' },
        { name: 'itemType', label: '列表项类型', type: 'string', defaultValue: 'ListItem', placeholder: '输入数据类型名称' }
      ]
    },
    {
      id: 3,
      name: '表单页面模板',
      category: '页面模板',
      description: '创建包含表单的页面模板',
      code: `import router from '@ohos.router';

@Entry
@Component
struct {{pageName}}Page {
  @State formData: {
    name: string;
    email: string;
    phone: string;
    description: string;
  } = {
    name: '',
    email: '',
    phone: '',
    description: ''
  };

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text('{{pageTitle}}')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
        
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 表单内容
      Scroll() {
        Column() {
          // 姓名输入
          Column() {
            Text('姓名')
              .fontSize(14)
              .fontColor('#333333')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 8 })
            
            TextInput({ placeholder: '请输入姓名' })
              .width('100%')
              .height(40)
              .backgroundColor('#F5F5F5')
              .onChange((value: string) => {
                this.formData.name = value;
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 邮箱输入
          Column() {
            Text('邮箱')
              .fontSize(14)
              .fontColor('#333333')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 8 })
            
            TextInput({ placeholder: '请输入邮箱地址' })
              .width('100%')
              .height(40)
              .backgroundColor('#F5F5F5')
              .type(InputType.Email)
              .onChange((value: string) => {
                this.formData.email = value;
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 提交按钮
          Button('{{submitText}}')
            .width('100%')
            .height(44)
            .backgroundColor('#007DFF')
            .fontColor('#FFFFFF')
            .onClick(() => {
              console.log('表单数据：', this.formData);
            })
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
}`,
      parameters: [
        { name: 'pageName', label: '页面名称', type: 'string', defaultValue: 'Form', placeholder: '输入页面名称' },
        { name: 'pageTitle', label: '页面标题', type: 'string', defaultValue: '表单页面', placeholder: '输入页面标题' },
        { name: 'submitText', label: '提交按钮文本', type: 'string', defaultValue: '提交', placeholder: '输入按钮文本' }
      ]
    },
    {
      id: 4,
      name: '自定义组件模板',
      category: '组件模板',
      description: '创建可复用的自定义组件',
      code: `@Component
export struct {{componentName}} {
  @Prop title: string = '{{defaultTitle}}';
  @Prop content: string = '{{defaultContent}}';
  @State isExpanded: boolean = false;

  build() {
    Column() {
      // 标题栏
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
        
        Image(this.isExpanded ? $r('sys.media.ohos_ic_public_arrow_up') : $r('sys.media.ohos_ic_public_arrow_down'))
          .width(16)
          .height(16)
          .onClick(() => {
            this.isExpanded = !this.isExpanded;
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#F8F9FA')
      .borderRadius({ topLeft: 8, topRight: 8 })

      // 内容区域
      if (this.isExpanded) {
        Column() {
          Text(this.content)
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius({ bottomLeft: 8, bottomRight: 8 })
      }
    }
    .width('100%')
    .margin({ bottom: 8 })
  }
}`,
      parameters: [
        { name: 'componentName', label: '组件名称', type: 'string', defaultValue: 'CustomCard', placeholder: '输入组件名称' },
        { name: 'defaultTitle', label: '默认标题', type: 'string', defaultValue: '标题', placeholder: '输入默认标题' },
        { name: 'defaultContent', label: '默认内容', type: 'string', defaultValue: '这是内容', placeholder: '输入默认内容' }
      ]
    },
    {
      id: 5,
      name: 'HTTP请求工具',
      category: '工具类',
      description: '创建HTTP请求的工具类',
      code: `import http from '@ohos.net.http';

export class {{className}} {
  private baseUrl: string = '{{baseUrl}}';

  // GET请求
  async get(url: string, params?: Record<string, any>): Promise<any> {
    const httpRequest = http.createHttp();
    
    try {
      let fullUrl = this.baseUrl + url;
      if (params) {
        const queryString = Object.keys(params)
          .map(key => \`\${key}=\${encodeURIComponent(params[key])}\`)
          .join('&');
        fullUrl += '?' + queryString;
      }

      const response = await httpRequest.request(fullUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      return JSON.parse(response.result.toString());
    } catch (error) {
      console.error('GET请求失败:', error);
      throw error;
    } finally {
      httpRequest.destroy();
    }
  }

  // POST请求
  async post(url: string, data?: any): Promise<any> {
    const httpRequest = http.createHttp();
    
    try {
      const response = await httpRequest.request(this.baseUrl + url, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(data)
      });

      return JSON.parse(response.result.toString());
    } catch (error) {
      console.error('POST请求失败:', error);
      throw error;
    } finally {
      httpRequest.destroy();
    }
  }
}`,
      parameters: [
        { name: 'className', label: '类名', type: 'string', defaultValue: 'HttpUtil', placeholder: '输入类名' },
        { name: 'baseUrl', label: '基础URL', type: 'string', defaultValue: 'https://api.example.com', placeholder: '输入API基础地址' }
      ]
    },
    {
      id: 6,
      name: '数据存储工具',
      category: '工具类',
      description: '创建本地数据存储的工具类',
      code: `import preferences from '@ohos.data.preferences';

export class {{className}} {
  private static instance: {{className}};
  private preferencesHelper: preferences.Preferences | null = null;

  private constructor() {}

  static getInstance(): {{className}} {
    if (!{{className}}.instance) {
      {{className}}.instance = new {{className}}();
    }
    return {{className}}.instance;
  }

  // 初始化
  async init(context: Context): Promise<void> {
    try {
      this.preferencesHelper = await preferences.getPreferences(context, '{{storeName}}');
    } catch (error) {
      console.error('初始化存储失败:', error);
    }
  }

  // 保存数据
  async setData(key: string, value: any): Promise<void> {
    if (!this.preferencesHelper) {
      throw new Error('存储未初始化');
    }
    
    try {
      await this.preferencesHelper.put(key, JSON.stringify(value));
      await this.preferencesHelper.flush();
    } catch (error) {
      console.error('保存数据失败:', error);
      throw error;
    }
  }

  // 获取数据
  async getData(key: string, defaultValue?: any): Promise<any> {
    if (!this.preferencesHelper) {
      throw new Error('存储未初始化');
    }
    
    try {
      const value = await this.preferencesHelper.get(key, '');
      return value ? JSON.parse(value as string) : defaultValue;
    } catch (error) {
      console.error('获取数据失败:', error);
      return defaultValue;
    }
  }

  // 删除数据
  async removeData(key: string): Promise<void> {
    if (!this.preferencesHelper) {
      throw new Error('存储未初始化');
    }
    
    try {
      await this.preferencesHelper.delete(key);
      await this.preferencesHelper.flush();
    } catch (error) {
      console.error('删除数据失败:', error);
      throw error;
    }
  }
}`,
      parameters: [
        { name: 'className', label: '类名', type: 'string', defaultValue: 'StorageUtil', placeholder: '输入类名' },
        { name: 'storeName', label: '存储名称', type: 'string', defaultValue: 'app_data', placeholder: '输入存储名称' }
      ]
    },
    {
      id: 7,
      name: '弹窗组件',
      category: '组件模板',
      description: '创建自定义弹窗组件',
      code: `@CustomDialog
export struct {{dialogName}} {
  @State title: string = '{{dialogTitle}}';
  @State content: string = '{{dialogContent}}';
  @State confirmText: string = '{{confirmText}}';
  @State cancelText: string = '{{cancelText}}';
  
  controller: CustomDialogController;
  onConfirm?: () => void;
  onCancel?: () => void;

  build() {
    Column() {
      // 标题
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .margin({ bottom: 16 })

      // 内容
      Text(this.content)
        .fontSize(14)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 24 })

      // 按钮区域
      Row() {
        Button(this.cancelText)
          .width('45%')
          .height(36)
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .onClick(() => {
            this.controller.close();
            if (this.onCancel) {
              this.onCancel();
            }
          })

        Blank()

        Button(this.confirmText)
          .width('45%')
          .height(36)
          .backgroundColor('#007DFF')
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.controller.close();
            if (this.onConfirm) {
              this.onConfirm();
            }
          })
      }
      .width('100%')
    }
    .width(280)
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }
}`,
      parameters: [
        { name: 'dialogName', label: '弹窗名称', type: 'string', defaultValue: 'CustomDialog', placeholder: '输入弹窗名称' },
        { name: 'dialogTitle', label: '弹窗标题', type: 'string', defaultValue: '提示', placeholder: '输入弹窗标题' },
        { name: 'dialogContent', label: '弹窗内容', type: 'string', defaultValue: '确定要执行此操作吗？', placeholder: '输入弹窗内容' },
        { name: 'confirmText', label: '确认按钮文本', type: 'string', defaultValue: '确定', placeholder: '输入确认按钮文本' },
        { name: 'cancelText', label: '取消按钮文本', type: 'string', defaultValue: '取消', placeholder: '输入取消按钮文本' }
      ]
    },
    {
      id: 8,
      name: '加载组件',
      category: '组件模板',
      description: '创建加载状态组件',
      code: `@Component
export struct {{componentName}} {
  @Prop isLoading: boolean = false;
  @Prop loadingText: string = '{{loadingText}}';
  @Prop size: number = 32;

  build() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .width(this.size)
          .height(this.size)
          .color('#007DFF')

        Text(this.loadingText)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 8 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(255, 255, 255, 0.8)')
    }
  }
}`,
      parameters: [
        { name: 'componentName', label: '组件名称', type: 'string', defaultValue: 'LoadingComponent', placeholder: '输入组件名称' },
        { name: 'loadingText', label: '加载文本', type: 'string', defaultValue: '加载中...', placeholder: '输入加载文本' }
      ]
    },
    {
      id: 9,
      name: '网格布局页面',
      category: '页面模板',
      description: '创建网格布局的页面模板',
      code: `import router from '@ohos.router';

interface {{itemType}} {
  id: number;
  title: string;
  icon: Resource;
  color?: string;
}

@Entry
@Component
struct {{pageName}}Page {
  @State gridData: {{itemType}}[] = [
    { id: 1, title: '功能1', icon: $r('sys.media.ohos_ic_public_app'), color: '#FF6B6B' },
    { id: 2, title: '功能2', icon: $r('sys.media.ohos_ic_public_settings'), color: '#4ECDC4' },
    { id: 3, title: '功能3', icon: $r('sys.media.ohos_ic_public_folder'), color: '#45B7D1' },
    { id: 4, title: '功能4', icon: $r('sys.media.ohos_ic_public_camera'), color: '#96CEB4' },
    { id: 5, title: '功能5', icon: $r('sys.media.ohos_ic_public_message'), color: '#FFEAA7' },
    { id: 6, title: '功能6', icon: $r('sys.media.ohos_ic_public_contacts'), color: '#DDA0DD' }
  ];

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text('{{pageTitle}}')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
        
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 网格内容
      Grid() {
        ForEach(this.gridData, (item: {{itemType}}) => {
          GridItem() {
            Column() {
              Image(item.icon)
                .width(32)
                .height(32)
                .fillColor(item.color || '#333333')

              Text(item.title)
                .fontSize(12)
                .fontColor('#333333')
                .margin({ top: 8 })
            }
            .width('100%')
            .height(80)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .onClick(() => {
              console.log('点击了：', item.title);
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap(12)
      .columnsGap(12)
      .width('100%')
      .layoutWeight(1)
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}`,
      parameters: [
        { name: 'pageName', label: '页面名称', type: 'string', defaultValue: 'Grid', placeholder: '输入页面名称' },
        { name: 'pageTitle', label: '页面标题', type: 'string', defaultValue: '功能中心', placeholder: '输入页面标题' },
        { name: 'itemType', label: '网格项类型', type: 'string', defaultValue: 'GridItem', placeholder: '输入数据类型名称' }
      ]
    },
    {
      id: 10,
      name: '轮播图组件',
      category: '组件模板',
      description: '创建轮播图组件',
      code: `@Component
export struct {{componentName}} {
  @State currentIndex: number = 0;
  @Prop images: string[] = [];
  @Prop autoPlay: boolean = true;
  @Prop interval: number = 3000;
  
  private timer: number = -1;

  aboutToAppear() {
    if (this.autoPlay && this.images.length > 1) {
      this.startAutoPlay();
    }
  }

  aboutToDisappear() {
    this.stopAutoPlay();
  }

  startAutoPlay() {
    this.timer = setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % this.images.length;
    }, this.interval);
  }

  stopAutoPlay() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
    }
  }

  build() {
    Column() {
      // 轮播图主体
      Swiper() {
        ForEach(this.images, (image: string, index: number) => {
          Image(image)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
        })
      }
      .width('100%')
      .height(200)
      .autoPlay(this.autoPlay)
      .interval(this.interval)
      .indicator(true)
      .loop(true)
      .onChange((index: number) => {
        this.currentIndex = index;
      })

      // 指示器
      Row() {
        ForEach(this.images, (item: string, index: number) => {
          Circle({ width: 6, height: 6 })
            .fill(this.currentIndex === index ? '#007DFF' : '#CCCCCC')
            .margin({ left: 4, right: 4 })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 8 })
    }
    .width('100%')
  }
}`,
      parameters: [
        { name: 'componentName', label: '组件名称', type: 'string', defaultValue: 'BannerSwiper', placeholder: '输入组件名称' }
      ]
    }
  ];

  // 更新分类列表
  private updateCategories() {
    if (!this.codeTemplates || !Array.isArray(this.codeTemplates)) {
      this.categories = ['全部'];
      return;
    }
    const uniqueCategories = new Set(this.codeTemplates.map(t => t.category));
    const cats = ['全部'];
    uniqueCategories.forEach(cat => cats.push(cat));
    this.categories = cats;
  }

  // 过滤模板
  private filterTemplates() {
    if (!this.codeTemplates || !Array.isArray(this.codeTemplates)) {
      this.filteredTemplates = [];
      return;
    }
    this.filteredTemplates = this.codeTemplates.filter(t => {
      const categoryMatch = this.selectedCategory === '全部' || t.category === this.selectedCategory;
      const searchMatch = this.searchText === '' || 
        t.name.toLowerCase().includes(this.searchText.toLowerCase()) ||
        t.description.toLowerCase().includes(this.searchText.toLowerCase());
      return categoryMatch && searchMatch;
    });
  }

  // 生成代码
  private generateCode(): string {
    if (!this.selectedTemplate) return '';
    
    let code = this.selectedTemplate.code;
    
    // 替换模板参数
    if (this.selectedTemplate.parameters) {
      this.selectedTemplate.parameters.forEach(param => {
        const value = this.parameterValues[param.name] || param.defaultValue;
        const regex = new RegExp(`{{${param.name}}}`, 'g');
        code = code.replace(regex, value);
      });
    }
    
    return code;
  }

  // 复制代码到剪贴板
  private async copyToClipboard() {
    try {
      const code = this.generatedCode;
      if (!code || code.trim() === '') {
        promptAction.showToast({
          message: '没有可复制的代码',
          duration: 2000
        });
        return;
      }

      const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, code);
      const systemPasteboard = pasteboard.getSystemPasteboard();
      await systemPasteboard.setData(pasteData);
      
      // 显示成功提示
      promptAction.showToast({
        message: '代码已复制到剪贴板',
        duration: 2000
      });
      
      console.info('代码已复制到剪贴板');
    } catch (error) {
      console.error('复制失败:', error);
      promptAction.showToast({
        message: '复制失败，请重试',
        duration: 2000
      });
    }
  }

  // 页面初始化
  aboutToAppear() {
    console.log('CodeGeneratorPage aboutToAppear started');
    
    try {
      // 基本信息日志
      console.log('selectedCategory:', this.selectedCategory || 'undefined');
      console.log('searchText:', this.searchText || 'undefined');
      
      // 检查模板数据
      if (this.codeTemplates && Array.isArray(this.codeTemplates)) {
        console.log('codeTemplates length:', this.codeTemplates.length);
        console.log('Templates loaded successfully');
      } else {
        console.error('codeTemplates is not properly initialized');
      }
      
      // 初始化分类列表
      this.updateCategories();
      
      // 初始化过滤
      this.filterTemplates();
      
      console.log('CodeGeneratorPage aboutToAppear completed');
    } catch (error) {
      console.error('Error in aboutToAppear:', error);
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .fillColor('#333333')
          .onClick(() => {
            router.back()
          })


        Text('代码生成器')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Row() {
        // 左侧模板列表
        Column() {

          // 模板列表
          Column() {
            if (this.filteredTemplates.length > 0) {
              List({ space: 8 }) {
                ForEach(this.filteredTemplates, (template: CodeTemplate) => {
                  ListItem() {
                    Row() {
                      Column() {
                        Text(template.name)
                          .fontSize(15)
                          .fontWeight(FontWeight.Medium)
                          .fontColor(this.selectedTemplate?.id === template.id ? '#007DFF' : '#333333')
                          .alignSelf(ItemAlign.Start)
                        
                        Text(template.description)
                          .fontSize(12)
                          .fontColor('#666666')
                          .alignSelf(ItemAlign.Start)
                          .margin({ top: 2 })
                          .maxLines(2)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .lineHeight(16)

                        // 模板标签
                        Row() {
                          Text(template.category)
                            .fontSize(10)
                            .fontColor('#007DFF')
                            .backgroundColor('#E8F4FD')
                            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                            .borderRadius(10)

                          if (template.parameters && template.parameters.length > 0) {
                            Text(`${template.parameters.length}个参数`)
                              .fontSize(10)
                              .fontColor('#FF6B35')
                              .backgroundColor('#FFF2E8')
                              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                              .borderRadius(10)
                              .margin({ left: 6 })
                          }
                        }
                        .margin({ top: 6 })
                        .alignSelf(ItemAlign.Start)
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)
                    }
                    .width('100%')
                    .padding(16)
                    .backgroundColor(this.selectedTemplate?.id === template.id ? '#F8FCFF' : '#FFFFFF')
                    .borderRadius(12)
                    .alignItems(VerticalAlign.Top)
                    .border({
                      width: this.selectedTemplate?.id === template.id ? 2 : 1,
                      color: this.selectedTemplate?.id === template.id ? '#007DFF' : '#E8E8E8'
                    })
                    .shadow({
                      radius: this.selectedTemplate?.id === template.id ? 8 : 2,
                      color: this.selectedTemplate?.id === template.id ? '#007DFF20' : '#00000010',
                      offsetX: 0,
                      offsetY: 2
                    })
                    .onClick(() => {
                      this.selectedTemplate = template;
                      this.parameterValues = {};
                      // 初始化参数默认值
                      if (template.parameters) {
                        template.parameters.forEach(param => {
                          this.parameterValues[param.name] = param.defaultValue;
                        });
                      }
                      this.generatedCode = this.generateCode();
                    })
                  }
                })
              }
              .width('100%')
              .layoutWeight(1)
            } else {
              // 空状态显示
              Column() {
                Text('暂无模板')
                  .fontSize(16)
                  .fontColor('#999999')
                  .margin({ top: 40 })
                
                Text(`模板总数: ${this.codeTemplates.length}`)
                  .fontSize(12)
                  .fontColor('#666666')
                  .margin({ top: 8 })
                  
                Text(`过滤条件: ${this.selectedCategory}`)
                  .fontSize(12)
                  .fontColor('#666666')
                  .margin({ top: 4 })
              }
              .width('100%')
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
            }
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 12, right: 12, bottom: 12 })
        }
        .width('40%')
        .height('100%')
        .backgroundColor('#F8F9FA')

        // 右侧代码预览
        Column() {
          if (this.selectedTemplate) {
            // 模板信息头部
            Column() {
              Row() {
                Column() {
                  Text(this.selectedTemplate.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .alignSelf(ItemAlign.Start)
                  
                  Text(this.selectedTemplate.description)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 快速操作按钮
                Button('复制代码')
                  .height(32)
                  .backgroundColor('#007DFF')
                  .fontColor('#FFFFFF')
                  .fontSize(12)
                  .onClick(() => {
                    this.copyToClipboard();
                  })
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius({ topLeft: 8, topRight: 8 })

            // 代码预览区域
            Column() {
              // 代码标题栏
              Row() {
                Text('代码预览')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#666666')
                  .layoutWeight(1)

                Text(`${this.selectedTemplate.category}`)
                  .fontSize(12)
                  .fontColor('#999999')
                  .backgroundColor('#F5F5F5')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(4)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 8 })
              .backgroundColor('#FAFAFA')

              // 代码内容
              Scroll() {
                Text(this.selectedTemplate.code)
                  .fontSize(12)
                  .fontColor('#333333')
                  .fontFamily('Courier New, monospace')
                  .width('100%')
                  .backgroundColor('#F8F8F8')
                  .padding(16)
                  .textAlign(TextAlign.Start)
                  .copyOption(CopyOptions.InApp)
              }
              .width('100%')
              .layoutWeight(1)
              .backgroundColor('#F8F8F8')
            }
            .width('100%')
            .layoutWeight(1)
            .backgroundColor('#FFFFFF')
            .borderRadius({ bottomLeft: 8, bottomRight: 8 })
            .margin({ top: 1 })

            // 底部统计信息
            Row() {
              Text(`代码行数: ${this.selectedTemplate.code.split('\n').length}`)
                .fontSize(12)
                .fontColor('#999999')
              
              Blank()
              
              Text(`模板ID: ${this.selectedTemplate.id}`)
                .fontSize(12)
                .fontColor('#999999')
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#F5F5F5')
            .borderRadius(4)
            .margin({ top: 8 })
          } else {
            // 未选择模板时的提示
            Column() {
              Text('{ }')
                .fontSize(48)
                .fontWeight(FontWeight.Bold)
                .fontColor('#CCCCCC')

              Text('选择代码模板')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#666666')
                .margin({ top: 16 })

              Text('从左侧列表中选择您需要的代码模板\n即可在此处预览和复制代码')
                .fontSize(14)
                .fontColor('#999999')
                .textAlign(TextAlign.Center)
                .margin({ top: 8 })
                .lineHeight(20)

              // 快速统计
              Column() {
                Text(`共 ${this.codeTemplates.length} 个模板`)
                  .fontSize(12)
                  .fontColor('#CCCCCC')
                
                Text(`${this.categories.length - 1} 个分类`)
                  .fontSize(12)
                  .fontColor('#CCCCCC')
                  .margin({ top: 4 })
              }
              .margin({ top: 24 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#FAFAFA')
          }
        }
        .width('60%')
        .height('100%')
        .backgroundColor('#FFFFFF')
        .margin({ left: 1 })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}