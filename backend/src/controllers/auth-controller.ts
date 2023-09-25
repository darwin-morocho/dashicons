/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { Request, Response } from 'express';
import { AES } from 'crypto-js';
import { Firestore } from 'firebase-admin/firestore';

export default class AuthController {
  constructor(db: Firestore) {
    this.db = db;
  }

  private db: Firestore;

  generateApiKey = async (req: Request, res: Response): Promise<void> => {
    try {
      const createdAt = new Date().toISOString();
      const json = {
        uid: req.uid,
        createdAt,
      };

      const key = AES.encrypt(
        JSON.stringify(json),
        process.env.CRYPTO_JS_SECRET!
      ).toString();

      await this.db.collection('apiKeys').add({
        key,
        uid: req.uid,
        createdAt,
      });

      res.send({
        key,
      });

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
