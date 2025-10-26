import express from 'express';
import { ensureDirs } from './pathHelper.js';

const app = express();
const port = parseInt(process.env.APP_PORT || '3000', 10);

ensureDirs();

app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

app.listen(port, () => {
  console.log(`[starter-node-service] listening on :${port}`);
});
