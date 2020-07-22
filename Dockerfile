FROM bebit/python-mecab-builder:release-1.0 as builder

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -n -p /var/lib/mecab/dic/mecab-ipadic-neologd

FROM python:3.5-slim-stretch
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends default-libmysqlclient-dev mecab mecab-ipadic-utf8 libmecab-dev swig > /dev/null
RUN sed -i -r 's/^dicdir = .*$$/dicdir = \/var\/lib\/mecab\/dic\/mecab-ipadic-neologd/' /etc/mecabrc
COPY --from=builder /var/lib/mecab/dic/mecab-ipadic-neologd /var/lib/mecab/dic/mecab-ipadic-neologd
