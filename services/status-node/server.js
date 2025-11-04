import express from 'express';

const app = express();
const PORT = process.env.PORT || 5051;

app.get('/health', (_req, res) => {
	res.json({ status: 'ok', ts: Math.floor(Date.now() / 1000) });
});

app.get('/ready', (_req, res) => {
	res.json({ ready: true });
});

app.get('/', (_req, res) => {
	res.json({
		service: 'status-node',
		version: '1.0.0',
		endpoints: ['/health', '/ready']
	});
});

app.listen(PORT, () => {
	console.log(`Status service listening on port ${PORT}`);
});
