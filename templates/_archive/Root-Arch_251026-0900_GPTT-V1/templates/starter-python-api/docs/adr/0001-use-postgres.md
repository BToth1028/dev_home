# ADR 0001: Use Postgres

Date: 2025-10-24
Status: Accepted

Context:
We need a reliable relational database with strong tooling.

Decision:
Use PostgreSQL 16 in dev (via Docker) and production.

Consequences:
+ Mature ecosystem; easy local setup with Docker
- Requires migrations tooling and backups
