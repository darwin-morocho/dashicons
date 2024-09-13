"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-namespace */
const express_1 = __importDefault(require("express"));
const body_parser_1 = require("body-parser");
const dotenv_1 = __importDefault(require("dotenv"));
const cors_1 = __importDefault(require("cors"));
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const helmet_1 = __importDefault(require("helmet"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const auth_middleware_1 = __importDefault(require("./middlewares/auth-middleware"));
const svg_parser_controller_1 = require("./controllers/svg-parser-controller");
const cli_controller_1 = __importDefault(require("./controllers/cli-controller"));
const auth_controller_1 = __importDefault(require("./controllers/auth-controller"));
// eslint-disable-next-line @typescript-eslint/no-var-requires
const serviceAccount = require('../firebase-admin.json');
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
dotenv_1.default.config();
const app = (0, express_1.default)();
firebase_admin_1.default.initializeApp({
    credential: firebase_admin_1.default.credential.cert(serviceAccount),
    storageBucket: 'gs://meedu-app.appspot.com',
    databaseURL: 'https://meedu-icons.firebaseio.com',
});
const db = firebase_admin_1.default.firestore();
firebase_admin_1.default.firestore.FieldValue.serverTimestamp();
const cliController = new cli_controller_1.default(firebase_admin_1.default.auth(), db);
const authMiddleware = new auth_middleware_1.default(db);
const authController = new auth_controller_1.default(db);
app.use((0, cors_1.default)()); // enable cors
app.use((0, body_parser_1.json)({ limit: '10mb' })); // convert the incomming request to json
app.use((0, helmet_1.default)());
app.use(helmet_1.default.permittedCrossDomainPolicies());
app.use((0, body_parser_1.urlencoded)({ extended: false, limit: '10mb', parameterLimit: 10000 })); // urlencoded to false
app.disable('x-powered-by');
const limiter = (0, express_rate_limit_1.default)({
    windowMs: 60 * 1000,
    max: 30, // limit each IP to 60 requests per minute
});
//  apply to all requests
app.use(limiter);
app.get('/', (_, res) => res.send('😅 welcome to 1.0.0'));
// app.post("/api/v1/parse-svgs", isAuthenticated, parseSvgs);
app.post('/api/v1/parse-svgs', authMiddleware.isAuthenticated, svg_parser_controller_1.svgsToFont);
app.post('/api/v1/cli/link', cliController.createSignInLink);
app.get('/api/v1/cli/get-projects', authMiddleware.isAuthenticated, cliController.getUserPackages);
app.get('/api/v1/cli/get-project/:packageId', authMiddleware.isAuthenticated, cliController.getPackage);
app.get('/api/v1/auth/generate-api-key', authMiddleware.isAuthenticated, authController.generateApiKey);
app.listen(process.env.PORT, () => console.log('Running ✅'));
