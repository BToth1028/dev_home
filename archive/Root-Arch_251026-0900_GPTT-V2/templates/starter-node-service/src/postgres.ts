import pg from 'pg';
const { Client } = pg;

export async function dbPing(): Promise<number> {
  const url = process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/postgres';
  const client = new Client({ connectionString: url });
  await client.connect();
  const res = await client.query('SELECT 1 as one');
  await client.end();
  return res.rows[0].one;
}
