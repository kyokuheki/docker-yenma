# docker-yenma

Dockernized YENMA

## docker
```shell
docker build -t kyokuheki/yenma .
docker run -itd --restart=always -h $HOSTNAME -p127.0.0.1:10025:10025/tcp \
  -v/srv/yenma:/etc/yenma:ro \
  -name yenma kyokuheki/yenma
```


## build
```shell
docker build . -t kyokuheki/yenma
```

tag:ubuntu

```shell
docker build . -t kyokuheki/yenma:ubuntu -f Dockerfile.ubuntu
```

## control

see https://github.com/iij/yenma/blob/master/yenma/yenmactrl.c#L53

### reload

```shell
echo reload | socat stdin tcp4-connect:0.0.0.0:20025
```

### graceful shutdown

```shell
echo graceful | socat stdin tcp4-connect:0.0.0.0:20025
```

## References
- https://github.com/iij/yenma/
- http://enma.sourceforge.net/
- https://www.nic.ad.jp/ja/materials/iw/2011/proceedings/s03/s03-04.pdf
- DomainKeys Identified Mail (DKIM) Authorized Third-Party Signatures
  - https://www.ietf.org/rfc/rfc6541.txt
- https://eng-blog.iij.ad.jp/archives/1234
- http://winserver.com/public/wcdmarc/default.wct
- https://github.com/iij/yenma/blob/master/example/yenma-ja.conf
