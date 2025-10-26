import express from 'express';
import { ensureDirs } from './pathHelper.js';
import { dbPing } from './postgres.js';

const app = express();
const port = parseInt(process.env.APP_PORT || '3000', 10);
ensureDirs();

app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

app.get('/db/ping', async (_req, res) => {
  try {
    const result = await dbPing();
    res.json({ ok: true, select: result });
  } catch (err: any) {
    res.status(500).json({ ok: false, error: String(err?.message || err) });
  }
});

app.listen(port, () => {
  console.log(`[starter-node-service] listening on :${port}`);
});
