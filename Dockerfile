FROM python:3.7.4-alpine3.10

ENV APP_DIR=/usr/src/snappass

RUN addgroup --gid 1000 snappass && \
    cat /etc/passwd && \
    adduser -D --uid 1000 -G snappass snappass && \
    mkdir -p $APP_DIR

WORKDIR $APP_DIR

COPY ["setup.py", "MANIFEST.in", "README.rst", "AUTHORS.rst", "$APP_DIR/"]
COPY ["./snappass", "$APP_DIR/snappass"]

RUN apk --no-cache add --virtual .deps make gcc musl-dev libffi-dev openssl-dev && \
    python setup.py install && \
    chown -R snappass $APP_DIR && \
    chgrp -R snappass $APP_DIR && \
    apk del .deps

USER snappass

# Default Flask port
EXPOSE 5000

CMD ["snappass"]
