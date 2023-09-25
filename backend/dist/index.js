"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const body_parser_1 = require("body-parser");
const dotenv_1 = __importDefault(require("dotenv"));
const cors_1 = __importDefault(require("cors"));
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const helmet_1 = __importDefault(require("helmet"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const auth_middleware_1 = require("./middlewares/auth-middleware");
const svg_parser_controller_1 = require("./controllers/svg-parser-controller");
const serviceAccount = require("../firebase-admin.json");
dotenv_1.default.config();
const app = (0, express_1.default)();
firebase_admin_1.default.initializeApp({
    credential: firebase_admin_1.default.credential.cert(serviceAccount),
    storageBucket: "gs://meedu-app.appspot.com",
});
app.use((0, cors_1.default)()); // enable cors
app.use((0, body_parser_1.json)()); // convert the incomming request to json
app.use((0, helmet_1.default)());
app.use(helmet_1.default.permittedCrossDomainPolicies());
app.use((0, body_parser_1.urlencoded)({ extended: false })); // urlencoded to false
app.disable("x-powered-by");
const limiter = (0, express_rate_limit_1.default)({
    windowMs: 60 * 1000,
    max: 30, // limit each IP to 60 requests per windowMs
});
//  apply to all requests
app.use(limiter);
app.get("/", (_, res) => res.send("😅 welcome to 1.0.0"));
app.post("/api/v1/parse-svgs", auth_middleware_1.isAuthenticated, svg_parser_controller_1.parseSvgs);
app.listen(process.env.PORT, () => console.log("Running ✅"));
