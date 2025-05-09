FROM php:7.4-apache
RUN apt update
RUN apt-get install -y libmcrypt-dev zip unzip libzip-dev libssl-dev
RUN apt-get install -y \
                libfreetype6-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
        && docker-php-ext-install -j$(nproc) iconv \
        && docker-php-ext-configure gd --with-jpeg-dir \
        && docker-php-ext-install -j$(nproc) gd \ 
        && docker-php-ext-install pdo pdo_mysql \
        && docker-php-ext-install zip \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install exif \
        && docker-php-ext-install ctype \
        && docker-php-ext-install bcmath \
        && docker-php-ext-install exif \
        && docker-php-ext-install opcache
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite
RUN a2enmod headers
RUN service apache2 restart
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN composer self-update --2
RUN apt-get install -y git
