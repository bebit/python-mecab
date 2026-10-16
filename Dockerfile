FROM ghcr.io/bebit/python-mecab-builder:5.2 as builder
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -n -p /var/lib/mecab/dic/mecab-ipadic-neologd

FROM python:3.12-slim-bookworm
RUN apt-get update > /dev/null && apt-get upgrade -y > /dev/null \
    && apt-get install -y --no-install-recommends \
    libexpat1 \
    libncursesw6 \
    ncurses-base \
    ncurses-bin \
    libgcrypt20 \
    libgnutls30 \
    libgssapi-krb5-2 \
    libk5crypto3 \
    libkrb5-3 \
    libkrb5support0 \
    libssl3 \
    openssl \
    libmariadb3 \
    mecab=0.996-14+b14 \
    mecab-ipadic-utf8=2.7.0-20070801+main-3 \
    libmecab-dev=0.996-14+b14 \
    swig > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -r 's/^dicdir = .*$$/dicdir = \/var\/lib\/mecab\/dic\/mecab-ipadic-neologd/' /etc/mecabrc
COPY --from=builder /var/lib/mecab/dic/mecab-ipadic-neologd /var/lib/mecab/dic/mecab-ipadic-neologd
