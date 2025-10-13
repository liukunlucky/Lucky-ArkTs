import router from '@ohos.router';

// API数据接口
interface ApiItem {
  name: string;
  category: string;
  description: string;
  syntax: string;
  example: string;
  parameters?: string[];
  returnType?: string;
  isHot?: boolean; // 是否为热门API
}

@Entry
@Component
struct ApiQueryPage {
  @State searchText: string = '';
  @State selectedCategory: string = '全部';
  @State apiList: ApiItem[] = [];
  @State filteredApiList: ApiItem[] = [];
  
  // API分类
  private categories: string[] = ['全部', '组件', '装饰器', '状态管理', '路由', '动画', '布局', '手势', '媒体', '网络', '存储', '工具', '安全'];

  aboutToAppear() {
    this.initApiData();
    this.filteredApiList = this.apiList;
  }

  // 初始化API数据
  initApiData() {
    this.apiList = [
      // 组件相关
      {
        name: 'Text',
        category: '组件',
        description: '文本显示组件，用于显示一段文本',
        syntax: 'Text(content?: string | Resource)',
        example: `Text('Hello World')
  .fontSize(16)
  .fontColor(Color.Black)`,
        parameters: ['content: 文本内容'],
        returnType: 'Text组件实例',
        isHot: true
      },
      {
        name: 'Button',
        category: '组件',
        description: '按钮组件，用于触发操作',
        syntax: 'Button(options?: {type?: ButtonType, stateEffect?: boolean})',
        example: `Button('点击我')
  .onClick(() => {
    console.log('按钮被点击');
  })`,
        parameters: ['type: 按钮类型', 'stateEffect: 是否有点击效果'],
        returnType: 'Button组件实例',
        isHot: true
      },
      {
        name: 'Column',
        category: '布局',
        description: '垂直布局容器，子组件垂直排列',
        syntax: 'Column(value?: {space?: string | number})',
        example: `Column({ space: 10 }) {
  Text('第一行')
  Text('第二行')
}`,
        parameters: ['space: 子组件间距'],
        returnType: 'Column组件实例'
      },
      {
        name: 'Row',
        category: '布局',
        description: '水平布局容器，子组件水平排列',
        syntax: 'Row(value?: {space?: string | number})',
        example: `Row({ space: 10 }) {
  Text('左侧')
  Text('右侧')
}`,
        parameters: ['space: 子组件间距'],
        returnType: 'Row组件实例'
      },
      // 装饰器相关
      {
        name: '@State',
        category: '装饰器',
        description: '状态变量装饰器，用于声明组件的状态变量',
        syntax: '@State variableName: type = initialValue',
        example: `@State count: number = 0;
@State message: string = 'Hello';`,
        parameters: ['variableName: 变量名', 'type: 变量类型', 'initialValue: 初始值'],
        returnType: '状态变量',
        isHot: true
      },
      {
        name: '@Component',
        category: '装饰器',
        description: '组件装饰器，用于声明自定义组件',
        syntax: '@Component struct ComponentName { }',
        example: `@Component
struct MyComponent {
  build() {
    Text('自定义组件')
  }
}`,
        parameters: ['ComponentName: 组件名称'],
        returnType: '自定义组件'
      },
      {
        name: '@Entry',
        category: '装饰器',
        description: '入口组件装饰器，标记应用的入口组件',
        syntax: '@Entry @Component struct EntryComponent { }',
        example: `@Entry
@Component
struct Index {
  build() {
    Text('应用入口')
  }
}`,
        parameters: [],
        returnType: '入口组件'
      },
      // 状态管理
      {
        name: '@Prop',
        category: '状态管理',
        description: '单向数据绑定装饰器，父组件向子组件传递数据',
        syntax: '@Prop variableName: type',
        example: `@Prop title: string;
@Prop count: number;`,
        parameters: ['variableName: 属性名', 'type: 属性类型'],
        returnType: '属性变量'
      },
      {
        name: '@Link',
        category: '状态管理',
        description: '双向数据绑定装饰器，父子组件数据同步',
        syntax: '@Link variableName: type',
        example: `@Link isVisible: boolean;
@Link selectedIndex: number;`,
        parameters: ['variableName: 链接变量名', 'type: 变量类型'],
        returnType: '链接变量'
      },
      // 路由相关
      {
        name: 'router.pushUrl',
        category: '路由',
        description: '路由跳转方法，跳转到指定页面',
        syntax: 'router.pushUrl(options: RouterOptions)',
        example: `router.pushUrl({
  url: 'pages/DetailPage',
  params: { id: 123 }
});`,
        parameters: ['url: 目标页面路径', 'params: 传递参数'],
        returnType: 'Promise<void>',
        isHot: true
      },
      {
        name: 'router.back',
        category: '路由',
        description: '返回上一页面',
        syntax: 'router.back(options?: RouterOptions)',
        example: `router.back();
// 或带参数返回
router.back({
  url: 'pages/HomePage'
});`,
        parameters: ['options: 可选的路由选项'],
        returnType: 'void'
      },
      // 动画相关
      {
        name: 'animateTo',
        category: '动画',
        description: '显式动画API，为状态变化添加动画效果',
        syntax: 'animateTo(value: AnimateParam, event: () => void)',
        example: `animateTo({
  duration: 300,
  curve: Curve.EaseInOut
}, () => {
  this.isVisible = !this.isVisible;
});`,
        parameters: ['value: 动画参数', 'event: 状态变化回调'],
        returnType: 'void'
      },
      // 更多组件
      {
        name: 'Image',
        category: '组件',
        description: '图片显示组件，用于显示图片资源',
        syntax: 'Image(src: string | PixelMap | Resource)',
        example: `Image($r('app.media.icon'))
  .width(100)
  .height(100)
  .objectFit(ImageFit.Cover)`,
        parameters: ['src: 图片资源路径'],
        returnType: 'Image组件实例',
        isHot: true
      },
      {
        name: 'List',
        category: '组件',
        description: '列表容器组件，用于显示一系列相同宽度的列表项',
        syntax: 'List(value?: {space?: number | string, initialIndex?: number})',
        example: `List({ space: 10 }) {
  ForEach(this.data, (item) => {
    ListItem() {
      Text(item.name)
    }
  })
}`,
        parameters: ['space: 列表项间距', 'initialIndex: 初始索引'],
        returnType: 'List组件实例'
      },
      {
        name: 'Grid',
        category: '组件',
        description: '网格容器组件，用于网格布局',
        syntax: 'Grid(scroller?: Scroller)',
        example: `Grid() {
  ForEach(this.data, (item) => {
    GridItem() {
      Text(item.name)
    }
  })
}
.columnsTemplate('1fr 1fr')
.rowsTemplate('1fr 1fr')`,
        parameters: ['scroller: 滚动控制器'],
        returnType: 'Grid组件实例'
      },
      {
        name: 'Swiper',
        category: '组件',
        description: '滑动容器组件，提供子组件滑动轮播功能',
        syntax: 'Swiper(controller?: SwiperController)',
        example: `Swiper() {
  Text('页面1')
  Text('页面2')
  Text('页面3')
}
.autoPlay(true)
.interval(3000)`,
        parameters: ['controller: 滑动控制器'],
        returnType: 'Swiper组件实例'
      },
      {
        name: 'Tabs',
        category: '组件',
        description: '选项卡容器组件，用于页面间的切换',
        syntax: 'Tabs(value?: {barPosition?: BarPosition, index?: number, controller?: TabsController})',
        example: `Tabs({ barPosition: BarPosition.Top }) {
  TabContent() {
    Text('首页内容')
  }.tabBar('首页')
  
  TabContent() {
    Text('我的内容')
  }.tabBar('我的')
}`,
        parameters: ['barPosition: 标签栏位置', 'index: 当前索引', 'controller: 控制器'],
        returnType: 'Tabs组件实例'
      },
      {
        name: 'TextInput',
        category: '组件',
        description: '单行文本输入组件',
        syntax: 'TextInput(value?: {placeholder?: ResourceStr, text?: ResourceStr, controller?: TextInputController})',
        example: `TextInput({ placeholder: '请输入内容' })
  .type(InputType.Normal)
  .onChange((value: string) => {
    this.inputText = value;
  })`,
        parameters: ['placeholder: 占位符', 'text: 输入文本', 'controller: 控制器'],
        returnType: 'TextInput组件实例'
      },
      {
        name: 'TextArea',
        category: '组件',
        description: '多行文本输入组件',
        syntax: 'TextArea(value?: {placeholder?: ResourceStr, text?: ResourceStr, controller?: TextAreaController})',
        example: `TextArea({ placeholder: '请输入多行内容' })
  .width('100%')
  .height(100)
  .onChange((value: string) => {
    this.textContent = value;
  })`,
        parameters: ['placeholder: 占位符', 'text: 输入文本', 'controller: 控制器'],
        returnType: 'TextArea组件实例'
      },
      {
        name: 'Slider',
        category: '组件',
        description: '滑动条组件，用于快速调节设置值',
        syntax: 'Slider(options?: {value?: number, min?: number, max?: number, step?: number, style?: SliderStyle, direction?: Axis})',
        example: `Slider({
  value: this.sliderValue,
  min: 0,
  max: 100,
  step: 1
})
.onChange((value: number) => {
  this.sliderValue = value;
})`,
        parameters: ['value: 当前值', 'min: 最小值', 'max: 最大值', 'step: 步长'],
        returnType: 'Slider组件实例'
      },
      {
        name: 'Progress',
        category: '组件',
        description: '进度条组件，用于显示内容加载或操作处理等进度',
        syntax: 'Progress(options: {value: number, total?: number, type?: ProgressType})',
        example: `Progress({
  value: this.progressValue,
  total: 100,
  type: ProgressType.Linear
})
.width('80%')
.height(20)`,
        parameters: ['value: 当前进度值', 'total: 进度总值', 'type: 进度条类型'],
        returnType: 'Progress组件实例'
      },
      // 更多装饰器
      {
        name: '@Prop',
        category: '装饰器',
        description: '单向数据绑定装饰器，父组件向子组件传递数据',
        syntax: '@Prop variableName: type',
        example: `@Component
struct ChildComponent {
  @Prop message: string;
  
  build() {
    Text(this.message)
  }
}`,
        parameters: ['variableName: 属性变量名', 'type: 变量类型'],
        returnType: '属性变量'
      },
      {
        name: '@Link',
        category: '装饰器',
        description: '双向数据绑定装饰器，父子组件数据同步',
        syntax: '@Link variableName: type',
        example: `@Component
struct ChildComponent {
  @Link count: number;
  
  build() {
    Button(\`点击: \${this.count}\`)
      .onClick(() => this.count++)
  }
}`,
        parameters: ['variableName: 链接变量名', 'type: 变量类型'],
        returnType: '链接变量'
      },
      {
        name: '@Watch',
        category: '装饰器',
        description: '状态变量监听装饰器，监听状态变量变化',
        syntax: '@Watch("methodName") @State variableName: type',
        example: `@Watch("onCountChange")
@State count: number = 0;

onCountChange() {
  console.log('count changed:', this.count);
}`,
        parameters: ['methodName: 监听方法名', 'variableName: 状态变量名'],
        returnType: '监听状态变量'
      },
      {
        name: '@Provide',
        category: '装饰器',
        description: '数据提供装饰器，向后代组件提供数据',
        syntax: '@Provide("alias") variableName: type',
        example: `@Provide("themeColor")
@State color: string = '#FF0000';`,
        parameters: ['alias: 数据别名', 'variableName: 变量名'],
        returnType: '提供数据变量'
      },
      {
        name: '@Consume',
        category: '装饰器',
        description: '数据消费装饰器，消费祖先组件提供的数据',
        syntax: '@Consume("alias") variableName: type',
        example: `@Consume("themeColor")
color: string;`,
        parameters: ['alias: 数据别名', 'variableName: 变量名'],
        returnType: '消费数据变量'
      },
      {
        name: '@ObjectLink',
        category: '装饰器',
        description: '对象链接装饰器，用于嵌套对象的双向绑定',
        syntax: '@ObjectLink variableName: ObservedClass',
        example: `@ObjectLink person: Person;

build() {
  Text(this.person.name)
}`,
        parameters: ['variableName: 对象变量名', 'ObservedClass: 被观察的类'],
        returnType: '对象链接变量'
      },
      {
        name: '@Observed',
        category: '装饰器',
        description: '类装饰器，用于观察类对象的属性变化',
        syntax: '@Observed class ClassName',
        example: `@Observed
class Person {
  name: string = '';
  age: number = 0;
}`,
        parameters: ['ClassName: 类名'],
        returnType: '被观察的类'
      },
      // 状态管理
      {
        name: 'AppStorage',
        category: '状态管理',
        description: '应用全局状态存储，用于应用级别的状态管理',
        syntax: 'AppStorage.SetAndLink(propName: string, defaultValue: T)',
        example: `@StorageLink("userName")
userName: string = '';

// 设置值
AppStorage.Set("userName", "张三");

// 获取值
let name = AppStorage.Get("userName");`,
        parameters: ['propName: 属性名', 'defaultValue: 默认值'],
        returnType: '存储链接'
      },
      {
        name: 'LocalStorage',
        category: '状态管理',
        description: '页面级状态存储，用于页面内的状态管理',
        syntax: 'LocalStorage.GetShared()',
        example: `let storage = new LocalStorage();
storage.setOrCreate("count", 0);

@Component
struct MyComponent {
  @LocalStorageLink("count") count: number = 0;
}`,
        parameters: ['key: 存储键', 'value: 存储值'],
        returnType: 'LocalStorage实例'
      },
      {
        name: 'PersistentStorage',
        category: '状态管理',
        description: '持久化状态存储，数据持久化到本地',
        syntax: 'PersistentStorage.PersistProp(key: string, defaultValue: T)',
        example: `PersistentStorage.PersistProp("userSettings", {
  theme: "light",
  language: "zh"
});

@StorageProp("userSettings")
settings: object = {};`,
        parameters: ['key: 持久化键', 'defaultValue: 默认值'],
        returnType: '持久化属性'
      },
      // 更多路由
      {
        name: 'router.replaceUrl',
        category: '路由',
        description: '替换当前页面，不会增加历史记录',
        syntax: 'router.replaceUrl(options: RouterOptions)',
        example: `router.replaceUrl({
  url: 'pages/LoginPage',
  params: { from: 'home' }
});`,
        parameters: ['options: 路由选项'],
        returnType: 'Promise<void>'
      },
      {
        name: 'router.clear',
        category: '路由',
        description: '清空所有历史页面记录',
        syntax: 'router.clear()',
        example: `router.clear();`,
        parameters: [],
        returnType: 'void'
      },
      {
        name: 'router.getLength',
        category: '路由',
        description: '获取当前在页面栈内的页面数量',
        syntax: 'router.getLength()',
        example: `let length = router.getLength();
console.log('页面栈长度:', length);`,
        parameters: [],
        returnType: 'string'
      },
      {
        name: 'router.getState',
        category: '路由',
        description: '获取当前页面的状态信息',
        syntax: 'router.getState()',
        example: `let state = router.getState();
console.log('当前页面:', state.name);
console.log('页面参数:', state.params);`,
        parameters: [],
        returnType: 'RouterState'
      },
      // 更多动画
      {
        name: 'Transition',
        category: '动画',
        description: '组件转场动画，用于组件出现和消失的动画效果',
        syntax: '.transition(TransitionOptions)',
        example: `Text('Hello')
  .transition({
    type: TransitionType.All,
    scale: { x: 0, y: 0 },
    opacity: 0
  })`,
        parameters: ['TransitionOptions: 转场选项'],
        returnType: '转场动画'
      },
      {
        name: 'Curves',
        category: '动画',
        description: '动画曲线，定义动画的时间函数',
        syntax: 'Curves.cubicBezier(x1, y1, x2, y2)',
        example: `animateTo({
  duration: 500,
  curve: Curves.fastOutSlowIn
}, () => {
  this.scale = 1.2;
});`,
        parameters: ['x1, y1, x2, y2: 贝塞尔曲线控制点'],
        returnType: 'ICurve'
      },
      {
        name: 'Animation',
        category: '动画',
        description: '属性动画，为组件属性变化添加动画',
        syntax: '.animation(AnimationOptions)',
        example: `Text('动画文本')
  .scale(this.scale)
  .animation({
    duration: 300,
    curve: Curve.EaseInOut
  })`,
        parameters: ['AnimationOptions: 动画选项'],
        returnType: '属性动画'
      },
      // 布局组件
      {
        name: 'Flex',
        category: '布局',
        description: 'Flex弹性布局容器',
        syntax: 'Flex(value?: FlexOptions)',
        example: `Flex({
  direction: FlexDirection.Row,
  justifyContent: FlexAlign.SpaceBetween
}) {
  Text('左侧')
  Text('右侧')
}`,
        parameters: ['direction: 主轴方向', 'justifyContent: 主轴对齐', 'alignItems: 交叉轴对齐'],
        returnType: 'Flex组件实例'
      },
      {
        name: 'Stack',
        category: '布局',
        description: '堆叠布局容器，子组件按照顺序依次入栈',
        syntax: 'Stack(value?: { alignContent?: Alignment })',
        example: `Stack({ alignContent: Alignment.Center }) {
  Image($r('app.media.background'))
  Text('叠加文本')
}`,
        parameters: ['alignContent: 对齐方式'],
        returnType: 'Stack组件实例'
      },
      {
        name: 'RelativeContainer',
        category: '布局',
        description: '相对布局容器，子组件相对于容器或其他子组件定位',
        syntax: 'RelativeContainer()',
        example: `RelativeContainer() {
  Text('参考组件')
    .id('reference')
  
  Text('相对组件')
    .alignRules({
      top: { anchor: 'reference', align: VerticalAlign.Bottom }
    })
}`,
        parameters: [],
        returnType: 'RelativeContainer组件实例'
      },
      // 手势
      {
        name: 'TapGesture',
        category: '手势',
        description: '点击手势，识别单击或多击操作',
        syntax: 'TapGesture(value?: { count?: number, fingers?: number })',
        example: `Text('点击我')
  .gesture(
    TapGesture({ count: 2 })
      .onAction(() => {
        console.log('双击事件');
      })
  )`,
        parameters: ['count: 点击次数', 'fingers: 手指数量'],
        returnType: 'TapGesture实例'
      },
      {
        name: 'PanGesture',
        category: '手势',
        description: '拖拽手势，识别拖拽操作',
        syntax: 'PanGesture(value?: PanGestureOptions)',
        example: `Text('拖拽我')
  .gesture(
    PanGesture()
      .onActionStart((event: GestureEvent) => {
        console.log('开始拖拽');
      })
      .onActionUpdate((event: GestureEvent) => {
        this.offsetX = event.offsetX;
        this.offsetY = event.offsetY;
      })
  )`,
        parameters: ['fingers: 手指数量', 'direction: 拖拽方向', 'distance: 最小拖拽距离'],
        returnType: 'PanGesture实例'
      },
      {
        name: 'PinchGesture',
        category: '手势',
        description: '捏合手势，识别缩放操作',
        syntax: 'PinchGesture(value?: { fingers?: number, distance?: number })',
        example: `Image($r('app.media.photo'))
  .gesture(
    PinchGesture()
      .onActionUpdate((event: GestureEvent) => {
        this.scale = event.scale;
      })
  )`,
        parameters: ['fingers: 手指数量', 'distance: 最小识别距离'],
        returnType: 'PinchGesture实例'
      },
      {
        name: 'RotationGesture',
        category: '手势',
        description: '旋转手势，识别旋转操作',
        syntax: 'RotationGesture(value?: { fingers?: number, angle?: number })',
        example: `Image($r('app.media.photo'))
  .gesture(
    RotationGesture()
      .onActionUpdate((event: GestureEvent) => {
        this.rotateAngle = event.angle;
      })
  )`,
        parameters: ['fingers: 手指数量', 'angle: 最小识别角度'],
        returnType: 'RotationGesture实例'
      },
      {
        name: 'SwipeGesture',
        category: '手势',
        description: '滑动手势，识别滑动操作',
        syntax: 'SwipeGesture(value?: { fingers?: number, direction?: SwipeDirection, speed?: number })',
        example: `Text('滑动我')
  .gesture(
    SwipeGesture({ direction: SwipeDirection.Left })
      .onAction(() => {
        console.log('向左滑动');
      })
  )`,
        parameters: ['fingers: 手指数量', 'direction: 滑动方向', 'speed: 最小滑动速度'],
        returnType: 'SwipeGesture实例'
      },
      // 媒体
      {
        name: 'Video',
        category: '媒体',
        description: '视频播放组件',
        syntax: 'Video(value: VideoOptions)',
        example: `Video({
  src: $r('app.media.sample_video'),
  controller: this.videoController
})
.width('100%')
.height(200)
.autoPlay(false)
.controls(true)`,
        parameters: ['src: 视频资源', 'controller: 视频控制器'],
        returnType: 'Video组件实例'
      },
      {
        name: 'Audio',
        category: '媒体',
        description: '音频播放组件',
        syntax: 'Audio(options: AudioOptions)',
        example: `Audio({
  src: $r('app.media.sample_audio'),
  controller: this.audioController
})
.width('100%')
.height(60)
.autoPlay(false)`,
        parameters: ['src: 音频资源', 'controller: 音频控制器'],
        returnType: 'Audio组件实例'
      },
      {
        name: 'Camera',
        category: '媒体',
        description: '相机预览组件',
        syntax: 'Camera(cameraOptions: CameraOptions)',
        example: `Camera({
  devicePosition: CameraPosition.BACK,
  controller: this.cameraController
})
.width('100%')
.height(300)`,
        parameters: ['devicePosition: 摄像头位置', 'controller: 相机控制器'],
        returnType: 'Camera组件实例'
      },
      // 网络
      {
        name: 'http.request',
        category: '网络',
        description: 'HTTP请求API，用于发送网络请求',
        syntax: 'http.createHttp().request(url, options)',
        example: `import http from '@ohos.net.http';

let httpRequest = http.createHttp();
httpRequest.request('https://api.example.com/data', {
  method: http.RequestMethod.GET,
  header: {
    'Content-Type': 'application/json'
  }
}).then((data) => {
  console.log('请求成功:', data.result);
});`,
        parameters: ['url: 请求地址', 'options: 请求选项'],
        returnType: 'Promise<HttpResponse>'
      },
      {
        name: 'WebSocket',
        category: '网络',
        description: 'WebSocket连接API，用于实时通信',
        syntax: 'webSocket.connect(url, options)',
        example: `import webSocket from '@ohos.net.webSocket';

let ws = webSocket.createWebSocket();
ws.connect('ws://example.com/socket', {
  header: { 'Authorization': 'Bearer token' }
});

ws.on('open', () => {
  console.log('WebSocket连接已打开');
});`,
        parameters: ['url: WebSocket地址', 'options: 连接选项'],
        returnType: 'WebSocket实例'
      },
      // 存储
      {
        name: 'preferences',
        category: '存储',
        description: '首选项存储API，用于轻量级数据存储',
        syntax: 'preferences.getPreferences(context, name)',
        example: `import preferences from '@ohos.data.preferences';

let pref = await preferences.getPreferences(this.context, 'myPrefs');
await pref.put('username', '张三');
await pref.flush();

let username = await pref.get('username', '');`,
        parameters: ['context: 应用上下文', 'name: 首选项名称'],
        returnType: 'Promise<Preferences>'
      },
      {
        name: 'relationalStore',
        category: '存储',
        description: '关系型数据库API，用于结构化数据存储',
        syntax: 'relationalStore.getRdbStore(context, config)',
        example: `import relationalStore from '@ohos.data.relationalStore';

const config = {
  name: 'MyDatabase.db',
  securityLevel: relationalStore.SecurityLevel.S1
};

let store = await relationalStore.getRdbStore(this.context, config);
await store.executeSql('CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)');`,
        parameters: ['context: 应用上下文', 'config: 数据库配置'],
        returnType: 'Promise<RdbStore>'
      },
      {
        name: 'distributedKVStore',
        category: '存储',
        description: '分布式键值存储API，支持跨设备数据同步',
        syntax: 'distributedKVStore.createKVManager(config)',
        example: `import distributedKVStore from '@ohos.data.distributedKVStore';

const config = {
  context: this.context,
  bundleName: 'com.example.app'
};

let kvManager = distributedKVStore.createKVManager(config);
let kvStore = await kvManager.getKVStore('storeId');`,
        parameters: ['config: KV管理器配置'],
        returnType: 'KVManager实例'
      },
      // 工具
      {
        name: 'JSON.parse',
        category: '工具',
        description: 'JSON解析工具，将JSON字符串转换为对象',
        syntax: 'JSON.parse(text, reviver?)',
        example: `let jsonStr = '{"name": "张三", "age": 25}';
let obj = JSON.parse(jsonStr);
console.log(obj.name); // 张三`,
        parameters: ['text: JSON字符串', 'reviver: 可选的转换函数'],
        returnType: 'any'
      },
      {
        name: 'JSON.stringify',
        category: '工具',
        description: 'JSON序列化工具，将对象转换为JSON字符串',
        syntax: 'JSON.stringify(value, replacer?, space?)',
        example: `let obj = { name: '张三', age: 25 };
let jsonStr = JSON.stringify(obj);
console.log(jsonStr); // {"name":"张三","age":25}`,
        parameters: ['value: 要序列化的值', 'replacer: 可选的替换函数', 'space: 可选的缩进'],
        returnType: 'string'
      },
      {
        name: 'setTimeout',
        category: '工具',
        description: '定时器工具，延迟执行函数',
        syntax: 'setTimeout(callback, delay, ...args)',
        example: `setTimeout(() => {
  console.log('延迟执行');
}, 1000);

// 带参数
setTimeout((msg) => {
  console.log(msg);
}, 2000, 'Hello World');`,
        parameters: ['callback: 回调函数', 'delay: 延迟时间(毫秒)', 'args: 传递给回调的参数'],
        returnType: 'number'
      },
      {
        name: 'setInterval',
        category: '工具',
        description: '定时器工具，周期性执行函数',
        syntax: 'setInterval(callback, delay, ...args)',
        example: `let timer = setInterval(() => {
  console.log('周期执行');
}, 1000);

// 清除定时器
clearInterval(timer);`,
        parameters: ['callback: 回调函数', 'delay: 间隔时间(毫秒)', 'args: 传递给回调的参数'],
        returnType: 'number'
      },
      {
        name: 'console.log',
        category: '工具',
        description: '控制台输出工具，用于调试和日志记录',
        syntax: 'console.log(message?, ...optionalParams)',
        example: `console.log('简单消息');
console.log('用户信息:', { name: '张三', age: 25 });
console.log('格式化输出: %s, %d', 'Hello', 123);`,
        parameters: ['message: 输出消息', 'optionalParams: 可选参数'],
        returnType: 'void'
      },
      // 安全
      {
        name: 'cryptoFramework',
        category: '安全',
        description: '加密框架API，提供加密解密功能',
        syntax: 'cryptoFramework.createCipher(algorithm)',
        example: `import cryptoFramework from '@ohos.security.cryptoFramework';

let cipher = cryptoFramework.createCipher('AES128|ECB|PKCS7');
let key = await cryptoFramework.createSymKey('AES128', keyData);
await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, key, null);`,
        parameters: ['algorithm: 加密算法'],
        returnType: 'Cipher实例'
      },
      {
        name: 'userAuth',
        category: '安全',
        description: '用户认证API，支持指纹、人脸等生物识别',
        syntax: 'userAuth.getAuthInstance()',
        example: `import userAuth from '@ohos.userIAM.userAuth';

let auth = userAuth.getAuthInstance();
auth.start({
  challenge: new Uint8Array([1, 2, 3, 4]),
  authType: [userAuth.UserAuthType.FINGERPRINT],
  authTrustLevel: userAuth.AuthTrustLevel.ATL1
});`,
        parameters: ['challenge: 挑战值', 'authType: 认证类型', 'authTrustLevel: 信任级别'],
        returnType: 'UserAuthInstance'
      },
      {
        name: 'huks',
        category: '安全',
        description: '密钥管理API，提供密钥生成、存储和使用',
        syntax: 'huks.generateKeyItem(keyAlias, options)',
        example: `import huks from '@ohos.security.huks';

let keyAlias = 'myKey';
let options = {
  properties: [
    { tag: huks.HuksTag.HUKS_TAG_ALGORITHM, value: huks.HuksKeyAlg.HUKS_ALG_AES },
    { tag: huks.HuksTag.HUKS_TAG_PURPOSE, value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT }
  ]
};

await huks.generateKeyItem(keyAlias, options);`,
        parameters: ['keyAlias: 密钥别名', 'options: 密钥选项'],
        returnType: 'Promise<void>'
      }
    ];
  }

  // 搜索和筛选API
  filterApis() {
    let filtered = this.apiList;
    
    // 按分类筛选
    if (this.selectedCategory !== '全部') {
      filtered = filtered.filter(api => api.category === this.selectedCategory);
    }
    
    // 按搜索文本筛选
    if (this.searchText.trim() !== '') {
      const searchLower = this.searchText.toLowerCase();
      filtered = filtered.filter(api => 
        api.name.toLowerCase().includes(searchLower) ||
        api.description.toLowerCase().includes(searchLower)
      );
    }
    
    this.filteredApiList = filtered;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button() {
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .fillColor('#333333')
        }
        .width(40)
        .height(40)
        .backgroundColor('#ffffff')
        .borderRadius(20)
        .onClick(() => {
          router.back();
        })
        
        Text('API查询')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      // 搜索框
      Row() {
        TextInput({ placeholder: '搜索API名称或描述...' })
          .width('100%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.searchText = value;
            this.filterApis();
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)

      // 分类筛选
      Scroll(new Scroller()) {
        Row() {
          ForEach(this.categories, (category: string) => {
            Text(category)
              .fontSize(14)
              .fontColor(this.selectedCategory === category ? Color.White : '#666666')
              .backgroundColor(this.selectedCategory === category ? '#007DFF' : '#F0F0F0')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .borderRadius(16)
              .margin({ right: 8 })
              .onClick(() => {
                this.selectedCategory = category;
                this.filterApis();
              })
          })
        }
        .alignItems(VerticalAlign.Center)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
      .backgroundColor(Color.White)

      // API列表
      List({ space: 12 }) {
        ForEach(this.filteredApiList, (api: ApiItem, index: number) => {
          ListItem() {
            this.ApiCard(api)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#F5F5F5')

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder ApiCard(api: ApiItem) {
    Column() {
      // API名称和分类
      Row() {
        Row() {
          Text(api.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          
          // 热门图标
          if (api.isHot) {
            Image($r('app.media.icon_hot'))
              .width(28)
              .height(14)
              .margin({ left: 6 })
          }
        }
        
        Blank()
        
        Text(api.category)
          .fontSize(12)
          .fontColor('#007DFF')
          .backgroundColor('#E6F3FF')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(12)
      }
      .width('100%')
      .margin({ bottom: 8 })

      // API描述
      Text(api.description)
        .fontSize(14)
        .fontColor('#666666')
        .width('100%')
        .margin({ bottom: 12 })

      // 语法
      Column() {
        Text('语法:')
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
          .margin({ bottom: 4 })
        
        Text(api.syntax)
          .fontSize(12)
          .fontColor('#333333')
          .backgroundColor('#F8F8F8')
          .padding(8)
          .borderRadius(4)
          .width('100%')
          .fontFamily('monospace')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 12 })

      // 示例代码
      Column() {
        Text('示例:')
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
          .margin({ bottom: 4 })
        
        Text(api.example)
          .fontSize(12)
          .fontColor('#333333')
          .backgroundColor('#F8F8F8')
          .padding(8)
          .borderRadius(4)
          .width('100%')
          .fontFamily('monospace')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 参数和返回值（如果有）
      if (api.parameters && api.parameters.length > 0) {
        Column() {
          Text('参数:')
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .margin({ bottom: 4, top: 12 })
          
          ForEach(api.parameters, (param: string) => {
            Text(`• ${param}`)
              .fontSize(12)
              .fontColor('#666666')
              .width('100%')
              .margin({ bottom: 2 })
          })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }

      if (api.returnType) {
        Row() {
          Text('返回值: ')
            .fontSize(12)
            .fontColor('#999999')
          Text(api.returnType)
            .fontSize(12)
            .fontColor('#666666')
        }
        .width('100%')
        .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
  }
}