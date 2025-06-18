FROM ghcr.io/bebit/python-mecab-builder-dev:pr-21 as builder
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -n -p /var/lib/mecab/dic/mecab-ipadic-neologd

FROM python:3.12-slim-bookworm
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends \
    libexpat1=2.5.0-1+deb12u1 \
    libncursesw6=6.4-4 \
    ncurses-base=6.4-4 \
    ncurses-bin=6.4-4 \
    default-libmysqlclient-dev=1.1.0 \
    mecab=0.996-14+b14 \
    mecab-ipadic-utf8=2.7.0-20070801+main-3 \
    libmecab-dev=0.996-14+b14 \
    swig=4.1.0-0.2 > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -r 's/^dicdir = .*$$/dicdir = \/var\/lib\/mecab\/dic\/mecab-ipadic-neologd/' /etc/mecabrc
COPY --from=builder /var/lib/mecab/dic/mecab-ipadic-neologd /var/lib/mecab/dic/mecab-ipadic-neologd
