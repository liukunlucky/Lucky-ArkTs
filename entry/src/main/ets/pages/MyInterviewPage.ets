import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { InterviewRecordModel, InterviewStatus, InterviewRound, InterviewResult, OfferStatus } from '../model/InterviewRecordModel';
import { AppButton, AppButtonType } from '../component/AppButton';
import { AppLoading } from '../component/AppLoading';
import { DatabaseManager } from '../common/DatabaseManager'

export interface InterviewStats {
  total: number;
  pending: number;
  completed: number;
  passed: number;
  failed: number;
  offers: number;
}

@Entry
@Component
struct MyInterviewPage {
  @State private records: InterviewRecordModel[] = [];
  @State private filteredRecords: InterviewRecordModel[] = [];
  @State private isLoading: boolean = true;
  @State private selectedStatus: InterviewStatus | 'all' | null = 'all';
  @State private selectedResult: InterviewResult | 'all' | null = 'all';
  @State private searchText: string = '';
  @State private viewMode: 'timeline' | 'list' = 'timeline';
  @State private statistics: InterviewStats = {
    total: 0,
    pending: 0,
    completed: 0,
    passed: 0,
    failed: 0,
    offers: 0
  };
  private databaseManager: DatabaseManager = DatabaseManager.getInstance()

  onPageShow() {
    // 页面显示时重新加载数据，确保从其他页面返回时数据是最新的
    this.loadData();
  }

  private async loadData(): Promise<void> {
    try {
      this.isLoading = true;
      this.records = await this.databaseManager.getAllInterviewRecords();
      this.statistics = await this.databaseManager.getInterviewStats();
      this.filterRecords();
    } catch (error) {
      console.error('Failed to load interview records:', error);
    } finally {
      this.isLoading = false;
    }
  }

  private filterRecords() {
    let filtered = this.records;

    // 按状态筛选
    if (this.selectedStatus && this.selectedStatus !== 'all') {
      filtered = filtered.filter(record => record.status === this.selectedStatus);
    }

    // 按结果筛选
    if (this.selectedResult && this.selectedResult !== 'all') {
      filtered = filtered.filter(record => record.result === this.selectedResult);
    }

    // 按搜索文本筛选
    if (this.searchText.trim()) {
      const searchLower = this.searchText.toLowerCase();
      filtered = filtered.filter(record => 
        record.company.toLowerCase().includes(searchLower) ||
        record.position.toLowerCase().includes(searchLower) ||
        record.interviewer.toLowerCase().includes(searchLower)
      );
    }

    // 按日期排序（最新的在前）
    filtered.sort((a, b) => {
      const dateA = new Date(a.interviewDate).getTime();
      const dateB = new Date(b.interviewDate).getTime();
      return dateB - dateA;
    });

    this.filteredRecords = filtered;
  }

  private onSearchTextChange(value: string) {
    this.searchText = value;
    this.filterRecords();
  }

  private onStatusFilterChange(status: InterviewStatus | 'all') {
    this.selectedStatus = status;
    this.filterRecords();
  }

  private onResultFilterChange(result: InterviewResult | 'all') {
    this.selectedResult = result;
    this.filterRecords();
  }

  private navigateToEdit(record: InterviewRecordModel) {
    router.pushUrl({
      url: 'pages/AddInterviewRecordPage',
      params: { record: record }
    }).catch((error: Error) => {
      console.error('Failed to navigate to edit:', error);
    });
  }

  private navigateToAdd() {
    router.pushUrl({
      url: 'pages/AddInterviewRecordPage'
    }).catch((error: Error) => {
      console.error('Failed to navigate to add:', error);
    });
  }

  private async deleteRecord(record: InterviewRecordModel) {
    try {
      // 从数据库中删除
      await this.databaseManager.deleteInterviewRecord(record.id);
      // 重新加载数据
      await this.loadData();
      // 重新过滤数据
      this.filterRecords();
      
      promptAction.showToast({
        message: '删除成功',
        duration: 2000
      });
    } catch (error) {
      console.error('删除记录失败:', error);
      promptAction.showToast({
        message: '删除失败，请重试',
        duration: 2000
      });
    }
  }

  build() {
    Column() {
      // 标题栏
      this.buildHeader()
      
      if (this.isLoading) {
        this.buildLoadingState()
      } else {
        Column() {
          // 统计卡片
          this.buildStatisticsCard()
          
          // 筛选栏
          this.buildFilterBar()
          
          // 视图切换
          this.buildViewToggle()
          
          // 记录列表
          if (this.viewMode === 'timeline') {
            this.buildTimelineView()
          } else {
            this.buildListView()
          }
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }

  @Builder
  buildHeader() {
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

      Text('面试记录')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Button() {
        Image($r('app.media.icon_add'))
          .width(36)
          .height(36)
          .fillColor('#FF6B35')
      }
      .width(40)
      .height(40)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.navigateToAdd();
      })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#ffffff')
  }

  @Builder
  buildLoadingState() {
    Column({ space: 16 }) {
      AppLoading({ loadingText: '正在加载面试记录...' })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildStatisticsCard() {
    Column({ space: 12 }) {
      Text('面试统计')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .alignSelf(ItemAlign.Start)

      Row({ space: 20 }) {
        this.buildStatItem('总计', this.statistics.total.toString(), '#1890ff')
        this.buildStatItem('已完成', this.statistics.completed.toString(), '#52c41a')
        this.buildStatItem('待面试', this.statistics.pending.toString(), '#faad14')
        this.buildStatItem('收到offer', this.statistics.offers.toString(), '#722ed1')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .padding(16)
    .margin({ left: 16, right: 16, top: 12 })
    .backgroundColor('#ffffff')
    .borderRadius(8)
  }

  @Builder
  buildStatItem(title: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(12)
        .fontColor('#666666')
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildFilterBar() {
    Column({ space: 12 }) {
      // 搜索框
      Row({ space: 12 }) {
        Image($r('app.media.icon_search'))
          .width(20)
          .height(20)

        TextInput({ placeholder: '搜索公司、职位或面试官' })
          .layoutWeight(1)
          .height(40)
          .backgroundColor('transparent')
          .border({ width: 0 })
          .onChange((value: string) => {
            this.onSearchTextChange(value);
          })
      }
      .width('100%')
      .height(48)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#f8f9fa')
      .borderRadius(8)
      .visibility(Visibility.None)

      // 筛选芯片
      Row({ space: 8 }) {
        Text('状态:')
          .fontSize(14)
          .fontColor('#666666')

        this.buildFilterChip('全部', 'all')
        this.buildFilterChip('已安排', InterviewStatus.SCHEDULED)
        this.buildFilterChip('已完成', InterviewStatus.COMPLETED)
        this.buildFilterChip('已取消', InterviewStatus.CANCELLED)
        this.buildFilterChip('待定', InterviewStatus.PENDING)
      }
      .width('100%')

      Row({ space: 8 }) {
        Text('结果:')
          .fontSize(14)
          .fontColor('#666666')

        this.buildResultFilterChip('全部', 'all')
        this.buildResultFilterChip('通过', InterviewResult.PASS)
        this.buildResultFilterChip('未通过', InterviewResult.FAIL)
        this.buildResultFilterChip('待定', InterviewResult.PENDING)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .margin({ left: 16, right: 16, top: 8 })
    .backgroundColor('#ffffff')
    .borderRadius(8)
  }

  @Builder
  buildFilterChip(text: string, value: InterviewStatus | 'all') {
    Text(text)
      .fontSize(12)
      .fontColor(this.selectedStatus === value ? '#ffffff' : '#666666')
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .backgroundColor(this.selectedStatus === value ? '#1890ff' : '#f0f0f0')
      .borderRadius(16)
      .onClick(() => {
        this.onStatusFilterChange(value);
      })
  }

  @Builder
  buildResultFilterChip(text: string, value: InterviewResult | 'all') {
    Text(text)
      .fontSize(12)
      .fontColor(this.selectedResult === value ? '#ffffff' : '#666666')
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .backgroundColor(this.selectedResult === value ? '#1890ff' : '#f0f0f0')
      .borderRadius(16)
      .onClick(() => {
        this.onResultFilterChange(value);
      })
  }

  @Builder
  buildViewToggle() {
    Row({ space: 8 }) {
      Text('视图:')
        .fontSize(14)
        .fontColor('#666666')

      Row({ space: 4 }) {
        Text('时间轴')
          .fontSize(12)
          .fontColor(this.viewMode === 'timeline' ? '#ffffff' : '#666666')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(this.viewMode === 'timeline' ? '#1890ff' : '#f0f0f0')
          .borderRadius(16)
          .onClick(() => {
            this.viewMode = 'timeline';
          })

        Text('列表')
          .fontSize(12)
          .fontColor(this.viewMode === 'list' ? '#ffffff' : '#666666')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(this.viewMode === 'list' ? '#1890ff' : '#f0f0f0')
          .borderRadius(16)
          .onClick(() => {
            this.viewMode = 'list';
          })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  buildTimelineView() {
    if (this.filteredRecords.length === 0) {
      this.buildEmptyState()
    } else {
      List({ space: 0 }) {
        ForEach(this.filteredRecords, (record: InterviewRecordModel, index: number) => {
          ListItem() {
            this.buildTimelineItem(record, index)
          }
          .swipeAction({
            end: {
              builder: () => {
                this.buildSwipeAction(record)
              }
            }
          })
        }, (record: InterviewRecordModel) => record.id.toString())
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })
    }
  }

  @Builder
  buildListView() {
    if (this.filteredRecords.length === 0) {
      this.buildEmptyState()
    } else {
      List({ space: 8 }) {
        ForEach(this.filteredRecords, (record: InterviewRecordModel) => {
          ListItem() {
            this.buildRecordCard(record)
          }
          .swipeAction({
            end: {
              builder: () => {
                this.buildSwipeAction(record)
              }
            }
          })
        }, (record: InterviewRecordModel) => record.id.toString())
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })
    }
  }

  @Builder
  buildSwipeAction(record: InterviewRecordModel) {
    Row() {
      Button() {
        Column() {
          Image($r('app.media.icon_delete'))
            .width(24)
            .height(24)
            .fillColor('#FF6B35')
          Text('删除')
            .fontSize(12)
            .fontColor('#FF6B35')
            .margin({ top: 4 })
        }
      }
      .width(80)
      .backgroundColor(Color.Transparent)
      .height('100%')
      .borderRadius(0)
      .onClick(() => {
        AlertDialog.show({
          title: '确认删除',
          message: '确定要删除这个记录吗？\n删除后无法恢复。',
          primaryButton: {
            value: '取消',
            action: () => {
              console.info('取消删除');
            }
          },
          secondaryButton: {
            value: '删除',
            fontColor: '#FF4444',
            action: () => {
              this.deleteRecord(record);
            }
          }
        });
      })
    }
    .height('100%')
  }

  @Builder
  buildTimelineItem(record: InterviewRecordModel, index: number) {
    Row({ space: 12 }) {
      // 时间轴线条
      Column() {
        if (index === 0) {
          Column()
            .width(2)
            .height(20)
            .backgroundColor('transparent')
        } else {
          Column()
            .width(2)
            .height(20)
            .backgroundColor('#e8e8e8')
        }

        // 时间轴节点
        Column()
          .width(12)
          .height(12)
          .backgroundColor(record.getStatusColor())
          .borderRadius(6)
          .border({ width: 2, color: '#ffffff' })

        if (index < this.filteredRecords.length - 1) {
          Column()
            .width(2)
            .height(20)
            .backgroundColor('#e8e8e8')
        }
      }
      .alignItems(HorizontalAlign.Center)

      // 记录内容
      Column({ space: 8 }) {
        this.buildRecordCard(record)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .margin({ bottom: 8 })
  }

  @Builder
  buildRecordCard(record: InterviewRecordModel) {
    Column({ space: 12 }) {
      // 头部信息
      Row({ space: 12 }) {
        Column({ space: 4 }) {
          Text(record.company)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')

          Text(record.position)
            .fontSize(14)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column({ space: 4 }) {
          Text(record.getStatusText())
            .fontSize(12)
            .fontColor('#ffffff')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(record.getStatusColor())
            .borderRadius(12)

          if (record.result !== InterviewResult.PENDING) {
            Text(record.getResultText())
              .fontSize(12)
              .fontColor('#ffffff')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor(record.getResultColor())
              .borderRadius(12)
          }
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')

      // 面试信息
      Row({ space: 16 }) {
        Row({ space: 4 }) {
          Image($r('app.media.calendar_icon'))
            .width(16)
            .height(16)

          Text(record.getFormattedDateTime())
            .fontSize(12)
            .fontColor('#666666')
        }

        Row({ space: 4 }) {
          Image($r('app.media.icon_mine'))
            .width(16)
            .height(16)

          Text(record.getRoundText())
            .fontSize(12)
            .fontColor('#666666')
        }

        if (record.duration > 0) {
          Row({ space: 4 }) {
            Image($r('app.media.clock_icon'))
              .width(16)
              .height(16)

            Text(record.duration + '分钟')
              .fontSize(12)
              .fontColor('#666666')
          }
        }
      }
      .width('100%')

      // Offer状态
      if (record.offerStatus !== OfferStatus.NO_OFFER) {
        Row({ space: 8 }) {
          Text('Offer状态:')
            .fontSize(12)
            .fontColor('#666666')

          Text(record.getOfferStatusText())
            .fontSize(12)
            .fontColor('#ffffff')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(record.getOfferStatusColor())
            .borderRadius(12)
        }
        .width('100%')
      }

      // 备注
      if (record.notes) {
        Text(record.notes)
          .fontSize(12)
          .fontColor('#999999')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .onClick(() => {
      this.navigateToEdit(record);
    })
  }

  @Builder
  buildEmptyState() {
    Column({ space: 16 }) {
      Image($r('app.media.icon_empty'))
        .width(58)
        .height(42)
        .opacity(0.5)

      Text('暂无面试记录')
        .fontSize(16)
        .fontColor('#999999')

      AppButton({
        buttonText: '添加面试记录',
        type: AppButtonType.PRIMARY,
        onButtonClick: () => {
          this.navigateToAdd();
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}