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
Object.defineProperty(exports, "__esModule", { value: true });
const crypto_js_1 = require("crypto-js");
class AuthController {
    constructor(db) {
        this.generateApiKey = (req, res) => __awaiter(this, void 0, void 0, function* () {
            var _a;
            try {
                const createdAt = new Date().toISOString();
                const json = {
                    uid: req.uid,
                    createdAt,
                };
                const key = crypto_js_1.AES.encrypt(JSON.stringify(json), process.env.CRYPTO_JS_SECRET).toString();
                yield this.db.collection('apiKeys').add({
                    key,
                    uid: req.uid,
                    createdAt,
                });
                res.send({
                    key,
                });
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
        this.db = db;
    }
}
exports.default = AuthController;
