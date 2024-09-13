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
exports.svgsToFont = void 0;
const fs_1 = __importDefault(require("fs"));
const os_1 = __importDefault(require("os"));
const svgicons2svgfont_1 = __importDefault(require("svgicons2svgfont"));
const svg2ttf_1 = __importDefault(require("svg2ttf"));
const rimraf_1 = __importDefault(require("rimraf"));
const svgsToFont = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    let responseSent = false;
    try {
        const { data, fontName } = req.body;
        if (!data || data.length === 0) {
            throw { code: 400, message: 'Missing or empty svgs in body' };
        }
        if (!fontName) {
            throw { code: 400, message: 'Missing fontName or packageId in body' };
        }
        const baseDir = `${os_1.default.tmpdir}/${req.uid}/${Date.now().valueOf()}`;
        const inputDir = `${baseDir}/input`;
        yield fs_1.default.promises.mkdir(inputDir, { recursive: true });
        const fontStream = new svgicons2svgfont_1.default({
            fontName,
            normalize: true,
            fontHeight: 500,
            centerHorizontally: true,
            centerVertically: true,
            fixedWidth: true,
            // eslint-disable-next-line @typescript-eslint/no-empty-function, @typescript-eslint/no-unused-vars
            log: (_) => { },
        });
        // save files
        for (const item of data) {
            const filePath = `${inputDir}/${item.id}.svg`;
            yield fs_1.default.promises.writeFile(filePath, item.svg);
            const glyph = fs_1.default.createReadStream(filePath);
            glyph.metadata = {
                name: `icon-${item.id}`,
                unicode: [String.fromCharCode(0xe000 + item.id)],
            };
            fontStream.write(glyph);
        }
        fontStream.end();
        yield waitUntilFinish(fontStream);
        const filePath = `${inputDir}/icons-${Date.now()}.svg`;
        fs_1.default.writeFileSync(filePath, fontStream.read());
        const svgFont = fs_1.default.readFileSync(filePath, 'utf8');
        const ttf = (0, svg2ttf_1.default)(svgFont, {});
        res.setHeader('Content-Type', 'application/octet-stream');
        res.setHeader('Content-Disposition', `attachment; filename=${fontName}.ttf`);
        res.send(Buffer.from(ttf.buffer));
        responseSent = true;
        yield (0, rimraf_1.default)(inputDir);
    }
    catch (e) {
        console.error(e);
        if (responseSent) {
            return;
        }
        responseSent = true;
        let code = 500;
        if (Number.isInteger(e.code)) {
            code = e.code;
        }
        res.status(code).send({ message: (_a = e.message) !== null && _a !== void 0 ? _a : 'unknown error' });
    }
});
exports.svgsToFont = svgsToFont;
const waitUntilFinish = (fontStream) => {
    return new Promise((resolve, reject) => {
        fontStream.on('finish', () => {
            resolve();
        });
        fontStream.on('error', (err) => {
            reject(err);
        });
    });
};
