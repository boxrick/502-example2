FROM php:7.3-apache

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# General install libs/apps
RUN apt-get update && \
    apt-get install -y wget ssl-cert net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite ssl && \
# Make the log directory writable
    chmod ugo+w /var/log
# Copy ENV set port
RUN sed -i 's/443/${PORT}/g' /etc/apache2/sites-available/default-ssl.conf /etc/apache2/ports.conf && \
    sed -i 's/KeepAlive On/KeepAlive Off/g' /etc/apache2/apache2.conf && \
    ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# TINI
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy local code to the container image.
COPY ./src/* /var/www/html/

# Expose ports
EXPOSE 443
ENV PORT=443

# Create entrypoint and start Apache2
ENTRYPOINT [ "/tini", "--" ]
CMD [ "apache2-foreground" ]
