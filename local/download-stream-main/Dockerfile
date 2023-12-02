FROM alpine:3.18.4
WORKDIR /app
COPY ./app.sh ./
RUN apk update && \
    apk add bash curl && \
    chmod +x ./* && \
    mkdir /output
CMD ./app.sh
