FROM gliderlabs/alpine:3.1

RUN apk update \
  && apk add build-base git go nginx supervisor \
  && GOPATH=/go go get github.com/hashicorp/consul-template \
  && cd /bin \
  && GOPATH=/go go build github.com/hashicorp/consul-template \
  && rm -rf /go \
  && apk del build-base git go \
  && rm -rf /var/cache/apk/*

ADD proxy_params /etc/nginx/proxy_params
ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /tmp/nginx

VOLUME ["/etc/consul-template/"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
