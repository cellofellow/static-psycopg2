#!/bin/bash
set -e
POSTGRES=postgresql-${PGVERSION:-"9.4.7"}
PSYCOPG=psycopg2-${PSYCOVERSION:-"2.6.1"}
export PREFIX=$PWD/$POSTGRES
curl -O https://ftp.postgresql.org/pub/source/v9.4.7/$POSTGRES.tar.bz2 >&2
curl -O http://initd.org/psycopg/tarballs/PSYCOPG-2-6/$PSYCOPG.tar.gz >&2
tar xf $POSTGRES.tar.bz2 >&2
cd $POSTGRES >&2
./configure --prefix=$PREFIX --without-readline --without-zlib >&2
make -j $(nproc) >&2
make install >&2
cd ..
tar xf $PSYCOPG.tar.gz >&2
cd $PSYCOPG >&2
echo "pg_config=$PREFIX/bin/pg_config" >> setup.cfg
echo "static_libpq=1" >> setup.cfg
python setup.py build >&2
cd build/lib.linux-x86_64-2.7/ >&2
tar cz psycopg2
