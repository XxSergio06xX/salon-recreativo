FROM php:8.3-apache
RUN docker-php-ext-install mysqli
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && sed -i 's/expose_php = On/expose_php = Off/' "$PHP_INI_DIR/php.ini"
RUN printf "ServerTokens Prod\nServerSignature Off\n" >> /etc/apache2/conf-available/security.conf
COPY src/ /var/www/html/
