import { mkdirSync } from 'fs';
import { homedir } from 'os';
import { resolve } from 'path';

function getEnvOrDefault(name: string, fallback: string) {
  return process.env[name] || fallback;
}

export function ensureDirs() {
  const dataDir = resolve(getEnvOrDefault('APP_DATA_DIR', resolve(homedir(), '.local/share/starter-node-service')));
  const logDir  = resolve(getEnvOrDefault('APP_LOG_DIR',  resolve(homedir(), '.cache/starter-node-service/logs')));
  const cacheDir= resolve(getEnvOrDefault('APP_CACHE_DIR',resolve(homedir(), '.cache/starter-node-service')));
  [dataDir, logDir, cacheDir].forEach(d => mkdirSync(d, { recursive: true }));
}
