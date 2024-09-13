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
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const crypto_js_1 = require("crypto-js");
class AuthMiddleware {
    constructor(db) {
        this.isAuthenticated = (req, res, next) => __awaiter(this, void 0, void 0, function* () {
            var _a, _b;
            try {
                const apiKey = req.headers['api-key'];
                const { authorization } = req.headers;
                if (!apiKey && !authorization) {
                    throw { code: 401, message: 'unauthorized' };
                }
                if (apiKey) {
                    const json = JSON.parse(crypto_js_1.AES.decrypt(apiKey, process.env.CRYPTO_JS_SECRET).toString(crypto_js_1.enc.Utf8));
                    const snapshot = yield this.db
                        .collection('apiKeys')
                        .where('key', '==', apiKey)
                        .get();
                    if (snapshot.empty) {
                        throw { code: 401, message: 'Invalid API key' };
                    }
                    req.uid = json.uid;
                    next();
                    return;
                }
                const token = authorization.replace('Bearer ', '');
                const decodedIdToken = yield firebase_admin_1.default.auth().verifyIdToken(token);
                req.uid = decodedIdToken.uid;
                next();
            }
            catch (e) {
                res.status((_a = e.code) !== null && _a !== void 0 ? _a : 500).send({ message: (_b = e.message) !== null && _b !== void 0 ? _b : 'unknown error' });
            }
        });
        this.db = db;
    }
}
exports.default = AuthMiddleware;
