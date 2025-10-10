/**
 * 面试状态枚举
 */
export enum InterviewStatus {
  SCHEDULED = 'scheduled',    // 已安排
  COMPLETED = 'completed',    // 已完成
  CANCELLED = 'cancelled',    // 已取消
  PENDING = 'pending'         // 待定
}

/**
 * 面试轮次枚举
 */
export enum InterviewRound {
  HR = 'hr',                  // HR面试
  TECHNICAL = 'technical',    // 技术面试
  MANAGER = 'manager',        // 主管面试
  FINAL = 'final',           // 终面
  ONSITE = 'onsite'          // 现场面试
}

/**
 * 面试结果枚举
 */
export enum InterviewResult {
  PASS = 'pass',             // 通过
  FAIL = 'fail',             // 未通过
  PENDING = 'pending',       // 待定
  UNKNOWN = 'unknown'        // 未知
}

/**
 * Offer状态枚举
 */
export enum OfferStatus {
  NO_OFFER = 'no_offer',     // 无offer
  PENDING = 'pending',       // offer待定
  RECEIVED = 'received',     // 已收到offer
  ACCEPTED = 'accepted',     // 已接受offer
  REJECTED = 'rejected'      // 已拒绝offer
}

/**
 * 面试记录模型
 */
export class InterviewRecordModel {
  id: number = 0;
  company: string = '';              // 公司名称
  position: string = '';             // 职位名称
  interviewDate: string = '';        // 面试日期
  interviewTime: string = '';        // 面试时间
  round: InterviewRound = InterviewRound.TECHNICAL;  // 面试轮次
  status: InterviewStatus = InterviewStatus.SCHEDULED;  // 面试状态
  result: InterviewResult = InterviewResult.PENDING;   // 面试结果
  offerStatus: OfferStatus = OfferStatus.NO_OFFER;     // offer状态
  
  // 面试详情
  interviewType: string = '';        // 面试类型（线上/线下）
  interviewer: string = '';          // 面试官
  duration: number = 0;              // 面试时长（分钟）
  
  // 面试内容
  questions: string = '';            // 面试问题
  answers: string = '';              // 回答内容
  techStack: string = '';            // 技术栈要求
  
  // 个人感受
  difficulty: number = 3;            // 难度评分（1-5）
  experience: string = '';           // 面试体验
  notes: string = '';                // 备注
  
  // 时间戳
  createdAt: string = '';
  updatedAt: string = '';

  constructor() {
    const now = new Date().toISOString();
    this.createdAt = now;
    this.updatedAt = now;
  }

  /**
   * 获取面试状态显示文本
   */
  getStatusText(): string {
    switch (this.status) {
      case InterviewStatus.SCHEDULED:
        return '已安排';
      case InterviewStatus.COMPLETED:
        return '已完成';
      case InterviewStatus.CANCELLED:
        return '已取消';
      case InterviewStatus.PENDING:
        return '待定';
      default:
        return '未知';
    }
  }

  /**
   * 获取面试轮次显示文本
   */
  getRoundText(): string {
    switch (this.round) {
      case InterviewRound.HR:
        return 'HR面试';
      case InterviewRound.TECHNICAL:
        return '技术面试';
      case InterviewRound.MANAGER:
        return '主管面试';
      case InterviewRound.FINAL:
        return '终面';
      case InterviewRound.ONSITE:
        return '现场面试';
      default:
        return '未知';
    }
  }

  /**
   * 获取面试结果显示文本
   */
  getResultText(): string {
    switch (this.result) {
      case InterviewResult.PASS:
        return '通过';
      case InterviewResult.FAIL:
        return '未通过';
      case InterviewResult.PENDING:
        return '待定';
      case InterviewResult.UNKNOWN:
        return '未知';
      default:
        return '未知';
    }
  }

  /**
   * 获取Offer状态显示文本
   */
  getOfferStatusText(): string {
    switch (this.offerStatus) {
      case OfferStatus.NO_OFFER:
        return '无offer';
      case OfferStatus.PENDING:
        return 'offer待定';
      case OfferStatus.RECEIVED:
        return '已收到offer';
      case OfferStatus.ACCEPTED:
        return '已接受offer';
      case OfferStatus.REJECTED:
        return '已拒绝offer';
      default:
        return '未知';
    }
  }

  /**
   * 获取难度星级显示
   */
  getDifficultyStars(): string {
    return '★'.repeat(this.difficulty) + '☆'.repeat(5 - this.difficulty);
  }

  /**
   * 获取状态颜色
   */
  getStatusColor(): string {
    switch (this.status) {
      case InterviewStatus.SCHEDULED:
        return '#1890ff';
      case InterviewStatus.COMPLETED:
        return '#52c41a';
      case InterviewStatus.CANCELLED:
        return '#ff4d4f';
      case InterviewStatus.PENDING:
        return '#faad14';
      default:
        return '#d9d9d9';
    }
  }

  /**
   * 获取结果颜色
   */
  getResultColor(): string {
    switch (this.result) {
      case InterviewResult.PASS:
        return '#52c41a';
      case InterviewResult.FAIL:
        return '#ff4d4f';
      case InterviewResult.PENDING:
        return '#faad14';
      case InterviewResult.UNKNOWN:
        return '#d9d9d9';
      default:
        return '#d9d9d9';
    }
  }

  /**
   * 获取Offer状态颜色
   */
  getOfferStatusColor(): string {
    switch (this.offerStatus) {
      case OfferStatus.NO_OFFER:
        return '#d9d9d9';
      case OfferStatus.PENDING:
        return '#faad14';
      case OfferStatus.RECEIVED:
        return '#1890ff';
      case OfferStatus.ACCEPTED:
        return '#52c41a';
      case OfferStatus.REJECTED:
        return '#ff4d4f';
      default:
        return '#d9d9d9';
    }
  }

  /**
   * 格式化面试日期时间
   */
  getFormattedDateTime(): string {
    if (!this.interviewDate) return '';
    const date = this.interviewDate;
    const time = this.interviewTime || '';
    return time ? `${date} ${time}` : date;
  }

  /**
   * 检查是否是今天的面试
   */
  isToday(): boolean {
    if (!this.interviewDate) return false;
    const today = new Date().toISOString().split('T')[0];
    return this.interviewDate === today;
  }

  /**
   * 检查是否是即将到来的面试（7天内）
   */
  isUpcoming(): boolean {
    if (!this.interviewDate || this.status !== InterviewStatus.SCHEDULED) return false;
    const interviewTime = new Date(this.interviewDate).getTime();
    const now = new Date().getTime();
    const sevenDaysLater = now + 7 * 24 * 60 * 60 * 1000;
    return interviewTime >= now && interviewTime <= sevenDaysLater;
  }
}