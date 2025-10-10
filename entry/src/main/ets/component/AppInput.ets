export enum AppInputType {
  TEXT = 'text',
  NUMBER = 'number',
  PASSWORD = 'password',
  EMAIL = 'email'
}

@Component
export struct AppInput {
  @Prop value: string = '';
  @Prop placeholder: string = '';
  @Prop type: AppInputType = AppInputType.TEXT;
  @Prop maxLength: number = -1;
  @Prop enabled: boolean = true;
  @Prop multiline: boolean = false;
  @Prop height: number = 40;
  onValueChange?: (value: string) => void;

  build() {
    if (this.multiline) {
      TextArea({
        text: this.value,
        placeholder: this.placeholder
      })
      .width('100%')
      .height(this.height)
      .backgroundColor('#ffffff')
      .borderRadius(8)
      .border({ width: 1, color: '#d9d9d9' })
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .fontSize(14)
      .fontColor('#333333')
      .enabled(this.enabled)
      .onChange((value: string) => {
        if (this.onValueChange) {
          this.onValueChange(value);
        }
      })
    } else {
      TextInput({
        text: this.value,
        placeholder: this.placeholder
      })
      .width('100%')
      .height(this.height)
      .backgroundColor('#ffffff')
      .borderRadius(8)
      .border({ width: 1, color: '#d9d9d9' })
      .padding({ left: 12, right: 12 })
      .fontSize(14)
      .fontColor('#333333')
      .type(this.getInputType())
      .maxLength(this.maxLength > 0 ? this.maxLength : undefined)
      .enabled(this.enabled)
      .onChange((value: string) => {
        if (this.onValueChange) {
          this.onValueChange(value);
        }
      })
    }
  }

  private getInputType(): InputType {
    switch (this.type) {
      case AppInputType.NUMBER:
        return InputType.Number;
      case AppInputType.PASSWORD:
        return InputType.Password;
      case AppInputType.EMAIL:
        return InputType.Email;
      default:
        return InputType.Normal;
    }
  }
}