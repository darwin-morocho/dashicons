"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const url_1 = __importDefault(require("url"));
const querystring_1 = __importDefault(require("querystring"));
const mailer_1 = __importDefault(require("../utils/mailer"));
class CliController {
    constructor(auth, db) {
        this.createSignInLink = (req, res) => __awaiter(this, void 0, void 0, function* () {
            var _a;
            try {
                const { email } = req.body;
                if (!email || email.length === 0) {
                    throw { code: 400, message: 'Missing or empty email in body' };
                }
                const user = yield this.auth.getUserByEmail(email);
                if (!user) {
                    throw { code: 404, message: `User with the email ${email} not found` };
                }
                const link = yield this.auth.generateSignInWithEmailLink(user.email, {
                    url: `https://icons.meedu.app/cli-auth-success`,
                    handleCodeInApp: false,
                });
                const queryParams = url_1.default.parse(link);
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                const query = querystring_1.default.parse(queryParams.query);
                const mailer = new mailer_1.default();
                yield mailer.sendEmail({
                    to: user.email,
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
            }
            catch (e) {
                console.log(e);
                let code = 500;
                if (Number.isInteger(e.code)) {
                    code = e.code;
                }
                res.status(code).send({ message: (_a = e.message) !== null && _a !== void 0 ? _a : 'unknown error' });
            }
        });
        this.getUserPackages = (req, res) => __awaiter(this, void 0, void 0, function* () {
            var _b;
            try {
                const snapshot = yield this.db
                    .collection('packages')
                    .where('userId', '==', req.uid)
                    .get();
                res.send({ packages: snapshot.docs.map((e) => e.data()) });
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
            }
            catch (e) {
                let code = 500;
                if (Number.isInteger(e.code)) {
                    code = e.code;
                }
                res.status(code).send({ message: (_b = e.message) !== null && _b !== void 0 ? _b : 'unknown error' });
            }
        });
        this.getPackage = (req, res) => __awaiter(this, void 0, void 0, function* () {
            var _c;
            try {
                const { packageId } = req.params;
                if (!packageId || packageId.length === 0) {
                    throw { code: 400, message: 'Missing or empty packageId in params' };
                }
                const snapshot = yield this.db
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
            }
            catch (e) {
                console.log(e);
                let code = 500;
                if (Number.isInteger(e.code)) {
                    code = e.code;
                }
                res.status(code).send({ message: (_c = e.message) !== null && _c !== void 0 ? _c : 'unknown error' });
            }
        });
        this.auth = auth;
        this.db = db;
    }
}
exports.default = CliController;
