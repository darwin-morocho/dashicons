/* eslint-disable @typescript-eslint/no-explicit-any */
import { Request, Response } from 'express';
import fs from 'fs';
import os from 'os';
import SVGIcons2SVGFontStream from 'svgicons2svgfont';
import svg2ttf from 'svg2ttf';
import rimraf from 'rimraf';

interface SvgData {
  id: number;
  svg: string;
}

export const svgsToFont = async (
  req: Request,
  res: Response
): Promise<void> => {
  let responseSent = false;
  try {
    const { data, fontName }: { data?: SvgData[]; fontName?: string } =
      req.body;

    if (!data || data.length === 0) {
      throw { code: 400, message: 'Missing or empty svgs in body' };
    }

    if (!fontName) {
      throw { code: 400, message: 'Missing fontName or packageId in body' };
    }

    const baseDir = `${os.tmpdir}/${req.uid}/${Date.now().valueOf()}`;
    const inputDir = `${baseDir}/input`;

    await fs.promises.mkdir(inputDir, { recursive: true });

    const fontStream = new SVGIcons2SVGFontStream({
      fontName,
      normalize: true,
      fontHeight: 500,
      centerHorizontally: true,
      centerVertically: true,
      fixedWidth: true,
      // eslint-disable-next-line @typescript-eslint/no-empty-function, @typescript-eslint/no-unused-vars
      log: (_) => {},
    });

    // save files
    for (const item of data) {
      const filePath = `${inputDir}/${item.id}.svg`;
      await fs.promises.writeFile(filePath, item.svg);
      const glyph = fs.createReadStream(filePath);

      (glyph as any).metadata = {
        name: `icon-${item.id}`,
        unicode: [String.fromCharCode(0xe000 + item.id)],
      };
      fontStream.write(glyph);
    }

    fontStream.end();
    await waitUntilFinish(fontStream);

    const filePath = `${inputDir}/icons-${Date.now()}.svg`;
    fs.writeFileSync(filePath, fontStream.read());
    const svgFont = fs.readFileSync(filePath, 'utf8');

    const ttf = svg2ttf(svgFont, {});

    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader(
      'Content-Disposition',
      `attachment; filename=${fontName}.ttf`
    );
    res.send(Buffer.from(ttf.buffer));

    responseSent = true;
    await rimraf(inputDir);
  } catch (e: any) {
    console.error(e);

    if (responseSent) {
      return;
    }
    responseSent = true;
    let code = 500;
    if (Number.isInteger(e.code)) {
      code = e.code;
    }
    res.status(code).send({ message: e.message ?? 'unknown error' });
  }
};

const waitUntilFinish = (fontStream: SVGIcons2SVGFontStream): Promise<void> => {
  return new Promise((resolve, reject) => {
    fontStream.on('finish', () => {
      resolve();
    });
    fontStream.on('error', (err) => {
      reject(err);
    });
  });
};
