FROM alpine:3.22

RUN apk upgrade --no-cache && apk add --no-cache curl ca-certificates nginx
RUN apk add --no-cache php84 php84-xml php84-exif php84-fpm php84-session php84-soap php84-openssl php84-gmp php84-pdo_odbc php84-dom php84-pdo php84-zip php84-mysqli php84-sqlite3 php84-pdo_pgsql php84-bcmath php84-gd php84-odbc php84-pdo_mysql php84-pdo_sqlite php84-gettext php84-xmlreader php84-bz2 php84-iconv php84-pdo_dblib php84-curl php84-ctype php84-phar php84-fileinfo php84-mbstring php84-tokenizer php84-simplexml
# fail the build if PHP is older than the release fixing CVE-2026-109618/109619 (8.4.27)
RUN php84 -r 'exit(version_compare(PHP_VERSION, "8.4.27", ">=") ? 0 : 1);' || (echo "PHP too old, vulnerable to CVE-2026-109618/109619" >&2; exit 1)
COPY --from=composer:latest  /usr/bin/composer /usr/bin/composer

USER container
ENV  USER container
ENV HOME /home/container

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh


CMD ["/bin/ash", "/entrypoint.sh"]
