/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { Auth } from 'firebase-admin/lib/auth/auth';
import { Firestore } from 'firebase-admin/lib/firestore';
import { Request, Response } from 'express';
import url from 'url';
import querystring from 'querystring';
import Mailer from '../utils/mailer';

export default class CliController {
  constructor(auth: Auth, db: Firestore) {
    this.auth = auth;
    this.db = db;
  }
  private auth: Auth;
  private db: Firestore;

  createSignInLink = async (req: Request, res: Response): Promise<void> => {
    try {
      const { email }: { email?: string } = req.body;
      if (!email || email.length === 0) {
        throw { code: 400, message: 'Missing or empty email in body' };
      }

      const user = await this.auth.getUserByEmail(email);

      if (!user) {
        throw { code: 404, message: `User with the email ${email} not found` };
      }

      const link = await this.auth.generateSignInWithEmailLink(user.email!, {
        url: `https://icons.meedu.app/cli-auth-success`,
        handleCodeInApp: false,
      });

      const queryParams = url.parse(link);
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      const query = querystring.parse(queryParams.query!);

      const mailer = new Mailer();
      await mailer.sendEmail({
        to: user.email!,
        html: `
        Hi ${user.displayName},<br/>
        Here you have your credentials to sign in using the CLI<br/><br/>
        apiKey: <strong>${query.apiKey}</strong><br/>
        oobCode: <strong>${query.oobCode}</strong><br/>
        `,
        subject: 'icons.meedu.app CLI authentication',
      });

      res.send({ message: 'success' });

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (e: any) {
      console.log(e);
      let code = 500;
      if (Number.isInteger(e.code)) {
        code = e.code;
      }
      res.status(code).send({ message: e.message ?? 'unknown error' });
    }
  };

  getUserPackages = async (req: Request, res: Response): Promise<void> => {
    try {
      const snapshot = await this.db
        .collection('packages')
        .where('userId', '==', req.uid)
        .get();

      res.send({ packages: snapshot.docs.map((e) => e.data()) });
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (e: any) {
      let code = 500;
      if (Number.isInteger(e.code)) {
        code = e.code;
      }
      res.status(code).send({ message: e.message ?? 'unknown error' });
    }
  };

  getPackage = async (req: Request, res: Response): Promise<void> => {
    try {
      const { packageId }: { packageId?: string } = req.params;
      if (!packageId || packageId.length === 0) {
        throw { code: 400, message: 'Missing or empty packageId in params' };
      }
      const snapshot = await this.db
        .collection('packages')
        .where('userId', '==', req.uid)
        .where('id', '==', packageId)
        .get();

      if (snapshot.empty) {
        throw {
          code: 404,
          message: `Package ${packageId} not found or you are not authorized to get it`,
        };
      }

      res.send({ package: snapshot.docs.map((e) => e.data())[0] });
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (e: any) {
      console.log(e);
      let code = 500;
      if (Number.isInteger(e.code)) {
        code = e.code;
      }
      res.status(code).send({ message: e.message ?? 'unknown error' });
    }
  };
}
