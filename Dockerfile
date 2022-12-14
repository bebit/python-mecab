FROM ghcr.io/bebit/python-mecab-builder-dev:pr-14 as builder
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -n -p /var/lib/mecab/dic/mecab-ipadic-neologd

FROM python:3.10-slim-buster
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev=1.0.5 \
    mecab=0.996-6 \
    mecab-ipadic-utf8=2.7.0-20070801+main-2.1 \
    libmecab-dev=0.996-6 \
    swig=3.0.12-2 > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -r 's/^dicdir = .*$$/dicdir = \/var\/lib\/mecab\/dic\/mecab-ipadic-neologd/' /etc/mecabrc
COPY --from=builder /var/lib/mecab/dic/mecab-ipadic-neologd /var/lib/mecab/dic/mecab-ipadic-neologd
