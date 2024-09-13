/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-namespace */
import express from 'express';
import { json, urlencoded } from 'body-parser';
import dotenv from 'dotenv';
import cors from 'cors';
import admin from 'firebase-admin';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import AuthMiddleware from './middlewares/auth-middleware';
import { svgsToFont } from './controllers/svg-parser-controller';
import CliController from './controllers/cli-controller';
import AuthController from './controllers/auth-controller';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const serviceAccount = require('../firebase-admin.json');

declare global {
  namespace Express {
    export interface Request {
      uid?: string;
      data?: any;
    }
  }
}

process.on('uncaughtException', (error, origin) => {
  console.log('----- Uncaught exception -----');
  console.log(error);
  console.log('----- Exception origin -----');
  console.log(origin);
});

process.on('unhandledRejection', (reason, promise) => {
  console.log('----- Unhandled Rejection at -----');
  console.log(promise);
  console.log('----- Reason -----');
  console.log(reason);
});

dotenv.config();
const app = express();

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'gs://meedu-app.appspot.com',
  databaseURL: 'https://meedu-icons.firebaseio.com',
});

const db = admin.firestore();
admin.firestore.FieldValue.serverTimestamp();
const cliController = new CliController(admin.auth(), db);
const authMiddleware = new AuthMiddleware(db);
const authController = new AuthController(db);

app.use(cors()); // enable cors
app.use(json({ limit: '10mb' })); // convert the incomming request to json
app.use(helmet());
app.use(helmet.permittedCrossDomainPolicies());
app.use(urlencoded({ extended: false, limit: '10mb', parameterLimit: 10000 })); // urlencoded to false
app.disable('x-powered-by');

const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 30, // limit each IP to 60 requests per minute
});

//  apply to all requests
app.use(limiter);

app.get('/', (_, res) => res.send('😅 welcome to 1.0.0'));
// app.post("/api/v1/parse-svgs", isAuthenticated, parseSvgs);
app.post('/api/v1/parse-svgs', authMiddleware.isAuthenticated, svgsToFont);
app.post('/api/v1/cli/link', cliController.createSignInLink);
app.get(
  '/api/v1/cli/get-projects',
  authMiddleware.isAuthenticated,
  cliController.getUserPackages
);
app.get(
  '/api/v1/cli/get-project/:packageId',
  authMiddleware.isAuthenticated,
  cliController.getPackage
);

app.get(
  '/api/v1/auth/generate-api-key',
  authMiddleware.isAuthenticated,
  authController.generateApiKey
);

app.listen(process.env.PORT ?? 9000, () => console.log('Running ✅'));
