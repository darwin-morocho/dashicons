"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseSvgs = void 0;
const fs_1 = __importDefault(require("fs"));
const os = __importStar(require("os"));
const svgicons2svgfont_1 = __importDefault(require("svgicons2svgfont"));
const svg2ttf_1 = __importDefault(require("svg2ttf"));
const parseSvgs = (req, res) => {
    var _a, _b;
    try {
        const { data, fontName } = req.body;
        if (!data || data.length === 0) {
            throw { code: 400, message: "Missing or empty svgs in body" };
        }
        if (!fontName) {
            throw { code: 400, message: "Missing fontName in body" };
        }
        const fontStream = new svgicons2svgfont_1.default({
            fontName,
            normalize: true,
            fontHeight: 1000,
        });
        data.forEach((item, index) => {
            const tempDir = os.tmpdir();
            const filePath = `${tempDir}/${Date.now()}.svg`;
            fs_1.default.writeFileSync(filePath, item.svg);
            const glyph = fs_1.default.createReadStream(filePath);
            glyph.metadata = {
                name: `icon_${item.unicode}`,
                unicode: [String.fromCharCode(item.unicode)],
            };
            fontStream.write(glyph);
        });
        fontStream.end();
        console.log("ready");
        fontStream.on("finish", () => {
            const tempDir = os.tmpdir();
            const filePath = `${tempDir}/${Date.now()}.svg`;
            fs_1.default.writeFileSync(filePath, fontStream.read());
            const svgFont = fs_1.default
                .readFileSync(filePath, "utf8")
                .replace(/<glyph/g, '<glyph fill="black"');
            console.log(svgFont);
            var ttf = (0, svg2ttf_1.default)(svgFont, {});
            res.setHeader("Content-Type", "application/octet-stream");
            res.setHeader("Content-Disposition", "attachment; filename=font.ttf");
            res.send(Buffer.from(ttf.buffer));
        });
        // Handle any errors that occur during the font stream processing
        fontStream.on("error", (err) => {
            console.error(err);
            res.status(500).send("Error generating icon font");
        });
    }
    catch (e) {
        console.error(e);
        res.status((_a = e.code) !== null && _a !== void 0 ? _a : 500).send({ message: (_b = e.message) !== null && _b !== void 0 ? _b : "unknown error" });
    }
};
exports.parseSvgs = parseSvgs;
