/**
 * 面试文章模型
 */
export interface InterviewArticleModel {
  id: number;
  title: string;
  summary: string;
  content: string;
  author: string;
  publishDate: string;
  readTime: number; // 阅读时间（分钟）
  category: InterviewArticleCategory;
  tags: string[];
  viewCount: number;
  likeCount: number;
  isLiked: boolean;
  coverImage?: string;
}

/**
 * 面试文章分类
 */
export enum InterviewArticleCategory {
  PREPARATION = 'preparation', // 面试准备
  EXPERIENCE = 'experience', // 面试经验
  SKILLS = 'skills', // 面试技巧
  ALGORITHM = 'algorithm', // 算法面试
  SYSTEM_DESIGN = 'system_design', // 系统设计
  BEHAVIORAL = 'behavioral', // 行为面试
  COMPANY_SPECIFIC = 'company_specific', // 公司特定
  SALARY_NEGOTIATION = 'salary_negotiation' // 薪资谈判
}

/**
 * 获取分类显示名称
 */
export function getCategoryDisplayName(category: InterviewArticleCategory): string {
  switch (category) {
    case InterviewArticleCategory.PREPARATION:
      return '面试准备';
    case InterviewArticleCategory.EXPERIENCE:
      return '面试经验';
    case InterviewArticleCategory.SKILLS:
      return '面试技巧';
    case InterviewArticleCategory.ALGORITHM:
      return '算法面试';
    case InterviewArticleCategory.SYSTEM_DESIGN:
      return '系统设计';
    case InterviewArticleCategory.BEHAVIORAL:
      return '行为面试';
    case InterviewArticleCategory.COMPANY_SPECIFIC:
      return '公司特定';
    case InterviewArticleCategory.SALARY_NEGOTIATION:
      return '薪资谈判';
    default:
      return '未知分类';
  }
}

/**
 * 获取分类颜色
 */
export function getCategoryColor(category: InterviewArticleCategory): string {
  switch (category) {
    case InterviewArticleCategory.PREPARATION:
      return '#4A90E2';
    case InterviewArticleCategory.EXPERIENCE:
      return '#F5A623';
    case InterviewArticleCategory.SKILLS:
      return '#7ED321';
    case InterviewArticleCategory.ALGORITHM:
      return '#D0021B';
    case InterviewArticleCategory.SYSTEM_DESIGN:
      return '#9013FE';
    case InterviewArticleCategory.BEHAVIORAL:
      return '#50E3C2';
    case InterviewArticleCategory.COMPANY_SPECIFIC:
      return '#B8E986';
    case InterviewArticleCategory.SALARY_NEGOTIATION:
      return '#F8E71C';
    default:
      return '#666666';
  }
}