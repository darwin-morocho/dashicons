/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { Request, Response, NextFunction } from 'express';
import admin from 'firebase-admin';
import { Firestore } from 'firebase-admin/firestore';
import { AES } from 'crypto-js';

export default class AuthMiddleware {
  constructor(db: Firestore) {
    this.db = db;
  }
  private db: Firestore;

  isAuthenticated = async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const apiKey = req.headers['api-key'] as string | undefined;

      if (apiKey) {
        const json = JSON.parse(
          AES.decrypt(apiKey, process.env.CRYPTO_JS_SECRET!).toString(
            CryptoJS.enc.Utf8
          )
        );

        const snapshot = await this.db
          .collection('apiKeys')
          .where('key', '==', apiKey)
          .get();
        if (snapshot.empty) {
          throw { code: 401, message: 'Invalid API key' };
        }

        req.uid = json.uid;
      }

      const { authorization } = req.headers;
      if (!authorization) {
        throw { code: 401, message: 'unauthorized' };
      }
      const token = authorization.replace('Bearer ', '');
      const decodedIdToken = await admin.auth().verifyIdToken(token);
      req.uid = decodedIdToken.uid;
      next();
    } catch (e: any) {
      res.status(e.code ?? 500).send({ message: e.message ?? 'unknown error' });
    }
  };
}
