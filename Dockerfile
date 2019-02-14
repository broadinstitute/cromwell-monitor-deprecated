FROM python:alpine

WORKDIR /opt

ADD requirements.txt ./

RUN apk add --no-cache \
      build-base \
      libstdc++ \
      linux-headers \
    && \
    pip install -r requirements.txt && \
    wget http://cloudpricingcalculator.appspot.com/static/data/pricelist.json && \
    apk del \
      build-base \
      linux-headers

ADD monitor.py ./

ENTRYPOINT ["./monitor.py"]
