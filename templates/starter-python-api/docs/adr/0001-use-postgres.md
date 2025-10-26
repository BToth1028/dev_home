# ADR 0001: Use Postgres

Date: 2025-10-26
Status: Accepted

Context:
We need a reliable relational database with strong tooling.

Decision:
Use PostgreSQL 16 in dev and prod.

Consequences:
+ Mature ecosystem; easy local setup with Docker
- Requires migrations and backups
