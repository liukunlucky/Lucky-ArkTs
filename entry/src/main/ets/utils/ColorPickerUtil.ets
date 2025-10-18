/*
 * 颜色选择器工具类
 * 用于颜色计算和转换
 */

enum ColorAreaEnum {
  RED = 0,
  YELLOW = 1,
  GREEN = 2,
  CYAN = 3,
  BLUE = 4,
  FUCHSIA = 5,
}

export class ColorPickerUtil {
  // 颜色分段常量
  private static readonly COLOR_SEGMENTS = 6;
  private static readonly MAX_RGB_VALUE = 255;
  private static readonly FULL_OPACITY = 1.0;
  private static readonly RGB_PREFIX_LENGTH = 5;
  
  // 颜色分段边界
  public static readonly SEGMENT_1 = 1 / 6;
  public static readonly SEGMENT_2 = 2 / 6;
  public static readonly SEGMENT_3 = 3 / 6;
  public static readonly SEGMENT_4 = 4 / 6;
  public static readonly SEGMENT_5 = 5 / 6;
  public static readonly SEGMENT_6 = 6 / 6;

  /**
   * 创建RGBA颜色字符串
   * @param red 红色分量 (0-255)
   * @param green 绿色分量 (0-255)
   * @param blue 蓝色分量 (0-255)
   * @param opacity 透明度 (0.0-1.0)
   * @returns 格式化的RGBA字符串
   */
  public static setRgba(red: number, green: number, blue: number, opacity: number): string {
    return `rgba(${red},${green},${blue},${opacity})`;
  }

  /**
   * 根据滑块位置计算颜色
   * @param value 滑块值 (0-100)
   * @returns RGBA颜色字符串
   */
  public static getBlockColor(value: number): string {
    const colorPercent = value / 100 * ColorPickerUtil.COLOR_SEGMENTS;
    let selectedColor: string = '';
    const colorSegment: number = Math.trunc(colorPercent);
    const colorAreaPercent: number = colorPercent - colorSegment;
    
    switch (colorSegment) {
      case ColorAreaEnum.RED:
        selectedColor = ColorPickerUtil.setRgba(ColorPickerUtil.MAX_RGB_VALUE,
          Math.floor(colorAreaPercent * ColorPickerUtil.MAX_RGB_VALUE), 0, ColorPickerUtil.FULL_OPACITY);
        break;
      case ColorAreaEnum.YELLOW:
        selectedColor = ColorPickerUtil.setRgba(Math.floor(((1 - colorAreaPercent) * ColorPickerUtil.MAX_RGB_VALUE)),
          ColorPickerUtil.MAX_RGB_VALUE, 0, ColorPickerUtil.FULL_OPACITY);
        break;
      case ColorAreaEnum.GREEN:
        selectedColor = ColorPickerUtil.setRgba(0, ColorPickerUtil.MAX_RGB_VALUE,
          Math.floor(colorAreaPercent * ColorPickerUtil.MAX_RGB_VALUE), ColorPickerUtil.FULL_OPACITY);
        break;
      case ColorAreaEnum.CYAN:
        selectedColor = ColorPickerUtil.setRgba(0, Math.floor(((1 - colorAreaPercent) * ColorPickerUtil.MAX_RGB_VALUE)),
          ColorPickerUtil.MAX_RGB_VALUE, ColorPickerUtil.FULL_OPACITY);
        break;
      case ColorAreaEnum.BLUE:
        selectedColor = ColorPickerUtil.setRgba(Math.floor(colorAreaPercent * ColorPickerUtil.MAX_RGB_VALUE), 0,
          ColorPickerUtil.MAX_RGB_VALUE, ColorPickerUtil.FULL_OPACITY);
        break;
      case ColorAreaEnum.FUCHSIA:
        selectedColor = ColorPickerUtil.setRgba(ColorPickerUtil.MAX_RGB_VALUE, 0,
          Math.floor(((1 - colorAreaPercent) * ColorPickerUtil.MAX_RGB_VALUE)), ColorPickerUtil.FULL_OPACITY);
        break;
      default:
        selectedColor = ColorPickerUtil.setRgba(ColorPickerUtil.MAX_RGB_VALUE, 0, 0, ColorPickerUtil.FULL_OPACITY);
    }
    return selectedColor;
  }

  /**
   * 从RGB字符串中提取RGB值
   * @param rgb rgba(0, 255, 1, 1.00)
   * @returns RGB值数组
   */
  public static getRgb(rgb: string): number[] {
    rgb = rgb.substring(ColorPickerUtil.RGB_PREFIX_LENGTH, rgb.length - 1);
    const rgbArray = rgb.split(',');
    const redArea: number = parseFloat(rgbArray[0]);
    const greenArea: number = parseFloat(rgbArray[1]);
    const blueArea: number = parseFloat(rgbArray[2]);
    return [redArea, greenArea, blueArea];
  }

  /**
   * 根据RGB值计算颜色位置
   * @param rgb rgba(0, 255, 1, 1.00)
   * @returns 颜色位置 (0-100)
   */
  public static getColorFromRgb(rgb: string): number {
    const rgbArray = ColorPickerUtil.getRgb(rgb);
    const redArea: number = rgbArray[0];
    const greenArea: number = rgbArray[1];
    const blueArea: number = rgbArray[2];
    let colorArea: number = 0.00;
    
    if (redArea === ColorPickerUtil.MAX_RGB_VALUE && blueArea === 0) {
      colorArea = ColorAreaEnum.RED + greenArea / ColorPickerUtil.MAX_RGB_VALUE;
    } else if (greenArea === ColorPickerUtil.MAX_RGB_VALUE && blueArea === 0) {
      colorArea = ColorAreaEnum.YELLOW + (redArea / ColorPickerUtil.MAX_RGB_VALUE);
    } else if (redArea === 0 && greenArea === ColorPickerUtil.MAX_RGB_VALUE) {
      colorArea = ColorAreaEnum.GREEN + (blueArea / ColorPickerUtil.MAX_RGB_VALUE);
    } else if (redArea === 0 && blueArea === ColorPickerUtil.MAX_RGB_VALUE) {
      colorArea = ColorAreaEnum.CYAN + (greenArea / ColorPickerUtil.MAX_RGB_VALUE);
    } else if (greenArea === 0 && blueArea === ColorPickerUtil.MAX_RGB_VALUE) {
      colorArea = ColorAreaEnum.BLUE + (redArea / ColorPickerUtil.MAX_RGB_VALUE);
    } else if (redArea === ColorPickerUtil.MAX_RGB_VALUE && greenArea === 0) {
      colorArea = ColorAreaEnum.FUCHSIA + (blueArea / ColorPickerUtil.MAX_RGB_VALUE);
    }
    
    const colorPercent = colorArea / ColorPickerUtil.COLOR_SEGMENTS * 100;
    return colorPercent;
  }

  /**
   * 将十六进制颜色转换为RGB
   * @param hex 十六进制颜色值 (如 #FF0000)
   * @returns RGBA字符串
   */
  public static hexToRgba(hex: string): string {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    if (result) {
      const r = parseInt(result[1], 16);
      const g = parseInt(result[2], 16);
      const b = parseInt(result[3], 16);
      return ColorPickerUtil.setRgba(r, g, b, 1.0);
    }
    return ColorPickerUtil.setRgba(0, 0, 0, 1.0);
  }

  /**
   * 将RGB转换为十六进制颜色
   * @param rgba RGBA字符串
   * @returns 十六进制颜色值
   */
  public static rgbaToHex(rgba: string): string {
    const rgbArray = ColorPickerUtil.getRgb(rgba);
    const r = Math.round(rgbArray[0]);
    const g = Math.round(rgbArray[1]);
    const b = Math.round(rgbArray[2]);
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
  }
}