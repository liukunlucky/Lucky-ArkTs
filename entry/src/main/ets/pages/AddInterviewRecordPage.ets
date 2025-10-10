import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { InterviewRecordModel, InterviewStatus, InterviewRound } from '../model/InterviewRecordModel';
import { DatabaseManager } from '../common/DatabaseManager'

interface SelectOption<T> {
  label: string;
  value: T;
}

interface RouteParams {
  record?: InterviewRecordModel;
}

@Entry
@Component
struct AddInterviewRecordPage {
  @State companyName: string = '';
  @State jobPosition: string = '';
  @State interviewType: InterviewRound = InterviewRound.TECHNICAL;
  @State interviewDate: string = '';
  @State duration: number = 60;
  @State location: string = '';
  @State interviewer: string = '';
  @State questions: string = '';
  @State experience: string = '';
  @State feedback: string = '';
  @State status: InterviewStatus = InterviewStatus.SCHEDULED;
  @State difficulty: number = 3;
  
  // 选择器弹窗状态
  @State showInterviewTypeDialog: boolean = false;
  @State showStatusDialog: boolean = false;
  
  // 编辑模式相关
  @State isEditMode: boolean = false;
  @State editingRecord: InterviewRecordModel | null = null;

  private databaseManager: DatabaseManager = DatabaseManager.getInstance()

  private interviewTypeOptions: Array<SelectOption<InterviewRound>> = [
    { label: '技术面试', value: InterviewRound.TECHNICAL },
    { label: 'HR面试', value: InterviewRound.HR },
    { label: '主管面试', value: InterviewRound.MANAGER }
  ];

  private statusOptions: Array<SelectOption<InterviewStatus>> = [
    { label: '已安排', value: InterviewStatus.SCHEDULED },
    { label: '已完成', value: InterviewStatus.COMPLETED },
    { label: '已取消', value: InterviewStatus.CANCELLED },
    { label: '待定', value: InterviewStatus.PENDING }
  ];

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams() as RouteParams;
    if (params && params.record) {
      // 编辑模式
      this.isEditMode = true;
      this.editingRecord = params.record;
      this.loadRecordData(params.record);
    }
  }

  private loadRecordData(record: InterviewRecordModel) {
    this.companyName = record.company || '';
    this.jobPosition = record.position || '';
    this.interviewType = record.round || InterviewRound.TECHNICAL;
    this.interviewDate = record.interviewDate || '';
    this.duration = record.duration || 60;
    this.location = record.interviewType || ''; // 使用interviewType字段存储地址信息
    this.interviewer = record.interviewer || '';
    this.questions = record.questions || '';
    this.experience = record.experience || '';
    this.feedback = record.notes || '';
    this.status = record.status || InterviewStatus.SCHEDULED;
    this.difficulty = record.difficulty || 3;
  }

  build() {
    Column() {
      // 标题栏
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

        Text(this.isEditMode ? '编辑面试记录' : '添加面试记录')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text('保存')
            .fontSize(16)
            .fontColor('#007DFF')
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.saveInterviewRecord();
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .color('#F1F3F5')

      // 表单内容
      Scroll() {
        Column({ space: 16 }) {
          // 公司名称
          this.buildInputItem('公司名称', this.companyName, (value: string) => {
            this.companyName = value;
          }, true)

          // 职位
          this.buildInputItem('职位', this.jobPosition, (value: string) => {
          this.jobPosition = value;
          }, true)

          // 面试类型
          this.buildSelectItem('面试类型', this.interviewTypeOptions, (value: InterviewRound) => {
              this.interviewType = value;
            }, true)

            this.buildDateItem('面试日期', (value: string) => {
              this.interviewDate = value;
            }, true)

          // 面试时长
          this.buildNumberItem('面试时长(分钟)', this.duration, (value: number) => {
            this.duration = value;
          })

          // 面试地点
          this.buildInputItem('面试地点', this.location, (value: string) => {
            this.location = value;
          })

          // 面试官
          this.buildInputItem('面试官', this.interviewer, (value: string) => {
            this.interviewer = value;
          })

          // 面试状态
          this.buildSelectItem('面试状态', this.statusOptions, (value: InterviewStatus) => {
              this.status = value;
            })

          // 难度评级
          this.buildRatingItem('难度评级', (value: number) => {
            this.difficulty = value;
          })

          // 面试问题
          this.buildTextAreaItem('面试问题', this.questions, (value: string) => {
            this.questions = value;
          })

          // 面试体验
          this.buildTextAreaItem('面试体验', this.experience, (value: string) => {
            this.experience = value;
          })

          // 反馈建议
          this.buildTextAreaItem('反馈建议', this.feedback, (value: string) => {
            this.feedback = value;
          })
        }
        .padding(16)
        .bindSheet($$this.showStatusDialog, this.buildStatusSheet(), {
          height: 300,
          showClose: true,
          dragBar: true
        })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
    .bindSheet($$this.showInterviewTypeDialog, this.buildInterviewTypeSheet(), {
      height: 300,
      showClose: true,
      dragBar: true
    })
    

  }

  @Builder
  buildInputItem(label: string, value: string, onChange: (value: string) => void, required: boolean = false) {
    Column({ space: 8 }) {
      Row() {
        Text(label)
          .fontSize(14)
          .fontColor('#666666')
        
        if (required) {
          Text(' *')
            .fontSize(14)
            .fontColor('#FF4444')
        }
      }
      .alignSelf(ItemAlign.Start)

      TextInput({ placeholder: `请输入${label}`, text: value })
        .width('100%')
        .height(44)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          onChange(value);
        })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildNumberItem(label: string, value: number, onChange: (value: number) => void) {
    Column({ space: 8 }) {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)

      TextInput({ placeholder: `请输入${label}`, text: value.toString() })
        .width('100%')
        .height(44)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .type(InputType.Number)
        .onChange((value: string) => {
          const num = parseInt(value) || 0;
          onChange(num);
        })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildSelectItem<T>(label: string, options: Array<SelectOption<T>>, onChange: (value: T) => void, required: boolean = false) {
    Column({ space: 8 }) {
      Row() {
        Text(label)
          .fontSize(14)
          .fontColor('#666666')
        
        if (required) {
          Text(' *')
            .fontSize(14)
            .fontColor('#FF4444')
        }
      }
      .alignSelf(ItemAlign.Start)

      Row() {
        Text(label === '面试类型' ? 
          (options.find(option => option.value === this.interviewType)?.label || '请选择') :
          label === '面试状态' ? 
          (options.find(option => option.value === this.status)?.label || '请选择') :
          '请选择')
          .fontSize(16)
          .fontColor('#182431')
          .layoutWeight(1)

        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(16)
          .height(16)
          .fillColor('#999999')
      }
      .width('100%')
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .padding({ left: 12, right: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        if (label === '面试类型') {
          this.showInterviewTypeDialog = true;
        } else if (label === '面试状态') {
          this.showStatusDialog = true;
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildDateItem(label: string, onChange: (value: string) => void, required: boolean = false) {
    Column({ space: 8 }) {
      Row() {
        Text(label)
          .fontSize(14)
          .fontColor('#666666')
        
        if (required) {
          Text(' *')
            .fontSize(14)
            .fontColor('#FF4444')
        }
      }
      .alignSelf(ItemAlign.Start)

      Row() {
        Text(this.interviewDate || '请选择日期')
          .fontSize(16)
          .fontColor('#182431')
          .layoutWeight(1)

        Image($r('app.media.icon_rl'))
          .width(16)
          .height(16)
          .fillColor('#999999')
      }
      .width('100%')
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .padding({ left: 12, right: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        DatePickerDialog.show({
          start: new Date('2020-01-01'),
          end: new Date('2030-12-31'),
          selected: this.interviewDate ? new Date(this.interviewDate) : new Date(),
          onAccept: (value: DatePickerResult) => {
            // DatePickerResult的month实际上是从0开始的（与JavaScript Date一致）
            const date = new Date(value.year!, value.month!, value.day!);
            this.interviewDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
          }
        });
      })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildRatingItem(label: string, onChange: (value: number) => void) {
    Column({ space: 8 }) {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)

      Row({ space: 8 }) {
        ForEach([1, 2, 3, 4, 5], (star: number) => {
          Image($r('app.media.icon_like_full'))
            .width(24)
            .height(24)
            .fillColor(star <= this.difficulty ? '#FF6B35' : '#E5E5E5')
            .onClick(() => {
              onChange(star);
            })
        })

        Text(`${this.difficulty}星`)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ left: 8 })
      }
      .width('100%')
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .padding({ left: 12, right: 12 })
      .alignItems(VerticalAlign.Center)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildTextAreaItem(label: string, value: string, onChange: (value: string) => void) {
    Column({ space: 8 }) {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)

      TextArea({ placeholder: `请输入${label}`, text: value })
        .width('100%')
        .height(100)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding(12)
        .onChange((value: string) => {
          onChange(value);
        })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildInterviewTypeSheet() {
    Column({ space: 16 }) {
      Text('选择面试类型')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 16, bottom: 8 })

      ForEach(this.interviewTypeOptions, (option: SelectOption<InterviewRound>) => {
        Row() {
          Text(option.label)
            .fontSize(16)
            .fontColor('#182431')
            .layoutWeight(1)
          
          if (this.interviewType === option.value) {
            Image($r('sys.media.ohos_ic_public_ok'))
              .width(20)
              .height(20)
              .fillColor('#007DFF')
          }
        }
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.interviewType = option.value;
          this.showInterviewTypeDialog = false;
        })
      })
    }
    .width('100%')
    .padding(16)
  }

  @Builder
  buildStatusSheet() {
    Column({ space: 16 }) {
      Text('选择面试状态')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 16, bottom: 8 })

      ForEach(this.statusOptions, (option: SelectOption<InterviewStatus>) => {
        Row() {
          Text(option.label)
            .fontSize(16)
            .fontColor('#182431')
            .layoutWeight(1)
          
          if (this.status === option.value) {
            Image($r('sys.media.ohos_ic_public_ok'))
              .width(20)
              .height(20)
              .fillColor('#007DFF')
          }
        }
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.status = option.value;
          this.showStatusDialog = false;
        })
      })
    }
    .width('100%')
    .padding(16)
  }

  private async saveInterviewRecord() {
    // 验证必填项
    const missingFields: string[] = [];
    
    if (!this.companyName.trim()) {
      missingFields.push('公司名称');
    }
    if (!this.jobPosition.trim()) {
      missingFields.push('职位名称');
    }
    if (!this.interviewDate) {
      missingFields.push('面试日期');
    }
    
    if (missingFields.length > 0) {
      promptAction.showToast({
        message: `请填写必填项：${missingFields.join('、')}`,
        duration: 3000
      });
      return;
    }

    try {
      if (this.isEditMode && this.editingRecord) {
        // 编辑模式：更新现有记录
        this.editingRecord.company = this.companyName.trim();
        this.editingRecord.position = this.jobPosition.trim();
        this.editingRecord.round = this.interviewType;
        this.editingRecord.interviewDate = this.interviewDate;
        this.editingRecord.duration = this.duration;
        this.editingRecord.interviewType = this.location.trim(); // 使用interviewType字段存储地址信息
        this.editingRecord.interviewer = this.interviewer.trim();
        this.editingRecord.questions = this.questions.trim();
        this.editingRecord.experience = this.experience.trim();
        this.editingRecord.notes = this.feedback.trim();
        this.editingRecord.status = this.status;
        this.editingRecord.difficulty = this.difficulty;
        this.editingRecord.updatedAt = new Date().toISOString();

        await this.databaseManager.updateInterviewRecord(this.editingRecord);
        
        promptAction.showToast({
          message: '面试记录更新成功',
          duration: 2000
        });
      } else {
        // 新增模式：创建新记录
        const newRecord = new InterviewRecordModel();
        newRecord.id = Date.now(); // 简单的ID生成
        newRecord.company = this.companyName.trim();
        newRecord.position = this.jobPosition.trim();
        newRecord.round = this.interviewType;
        newRecord.interviewDate = this.interviewDate;
        newRecord.duration = this.duration;
        newRecord.interviewType = this.location.trim(); // 使用interviewType字段存储地址信息
        newRecord.interviewer = this.interviewer.trim();
        newRecord.questions = this.questions.trim();
        newRecord.experience = this.experience.trim();
        newRecord.notes = this.feedback.trim();
        newRecord.status = this.status;
        newRecord.difficulty = this.difficulty;
        newRecord.createdAt = new Date().toISOString();
        newRecord.updatedAt = new Date().toISOString();

        // 保存到数据库
        await this.databaseManager.insertInterviewRecord(newRecord);
        
        promptAction.showToast({
          message: '面试记录保存成功',
          duration: 2000
        });
      }
      
      // 返回上一页
      router.back();
    } catch (error) {
      console.error('保存面试记录失败:', error);
      promptAction.showToast({
        message: '保存失败，请重试',
        duration: 2000
      });
    }
  }
}