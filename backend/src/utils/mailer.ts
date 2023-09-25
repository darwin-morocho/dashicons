/* eslint-disable @typescript-eslint/no-explicit-any */
import nodemailer from 'nodemailer';

export interface SendEmailData {
  to: string;
  subject: string;
  html: string;
}

export default class Mailer {
  private transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST as any,
    port: process.env.SMTP_PORT as any,
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASSWORD,
    },
  });

  sendEmail = async (data: SendEmailData): Promise<void> => {
    try {
      const mailOptions = {
        from: 'MEEDU.APP <no-reply@meedu.app>',
        to: data.to,
        subject: data.subject,
        html: data.html,
      };
      await this.transporter.sendMail(mailOptions);
    } catch (e) {
      console.warn('Error sendEmail', e);
    }
  };
}
