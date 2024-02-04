export interface Mail {
    sender: string;
    subject: string;
    message: string;
    mailid: number;
    read: number;
    date: number;
    button?: ButtonContent;
}

export interface ButtonContent {
    buttonEvent: string;
    enabled: boolean;
    buttonData?: any;
}