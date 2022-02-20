# docker-monetdb

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/watchdg/monetdb)

## Plugins

* embedded R

### Embedded R

#### example

```sql
create or replace function r_seq("from" integer, length integer) returns table (i integer) language r 'seq(from, length);';
```
##### query

```sql
select * from r_seq(1,15) where i > 10;
```
##### result

| i   |
|:----|
| 11  |
| 12  |
| 13  |
| 14  |
| 15  |
