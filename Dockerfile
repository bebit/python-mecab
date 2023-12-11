FROM ghcr.io/bebit/python-mecab-builder-dev:pr-18 as builder
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -n -p /var/lib/mecab/dic/mecab-ipadic-neologd

FROM python:3.10-slim-bookworm
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev=1.1.0 \
    mecab=0.996-14+b14 \
    mecab-ipadic-utf8=2.7.0-20070801+main-3 \
    libmecab-dev=0.996-14+b14 \
    swig=4.1.0-0.2 > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -r 's/^dicdir = .*$$/dicdir = \/var\/lib\/mecab\/dic\/mecab-ipadic-neologd/' /etc/mecabrc
COPY --from=builder /var/lib/mecab/dic/mecab-ipadic-neologd /var/lib/mecab/dic/mecab-ipadic-neologd
