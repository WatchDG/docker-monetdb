# docker-monetdb

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/watchdg/monetdb)

## Plugins

* embedded Python 3
* embedded R

### Embedded Python 3 

#### example

```sql
CREATE FUNCTION py_version ()
RETURNS STRING
LANGUAGE python3 {
  import sys
  return sys.version
};
```

##### query

```sql
SELECT py_version();
```

##### result

```text
3.9.10 (main, Jan 16 2022, 17:12:18) 
[GCC 11.2.0]
```

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
