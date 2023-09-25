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
exports.isAuthenticated = void 0;
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const isAuthenticated = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b;
    try {
        const { authorization } = req.headers;
        if (!authorization) {
            throw { code: 401, message: "unauthorized" };
        }
        const token = authorization.replace("Bearer ", "");
        yield firebase_admin_1.default.auth().verifyIdToken(token);
        next();
    }
    catch (e) {
        res.status((_a = e.code) !== null && _a !== void 0 ? _a : 500).send({ message: (_b = e.message) !== null && _b !== void 0 ? _b : "unknown error" });
    }
});
exports.isAuthenticated = isAuthenticated;
