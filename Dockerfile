FROM php:7.3-fpm

# Update packages and install composer and PHP dependencies.
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # sqlite3-dev \
  # postgresql-client \
  # libpq-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  # libpng12-dev \
  libbz2-dev \
  imagemagick \
  cron \
  && pecl channel-update pecl.php.net \
  && pecl install apcu

# PHP Extensions
RUN docker-php-ext-install \
  # curl \
  iconv \
  mbstring \
  pdo \
  # pdo_mysql \
  # pdo_pgsql \
  # pdo_sqlite \
  pcntl \
  # tokenizer \
  # xml \
  gd \
  # zip \
  bcmath
# RUN docker-php-ext-install mcrypt zip bz2 mbstring pdo pdo_pgsql pcntl \
#   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#   && docker-php-ext-install gd

# Memory Limit
RUN echo "memory_limit=2048M" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "max_execution_time=900" >> $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/apcu.ini
RUN echo "post_max_size=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "upload_max_filesize=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Display errors in stderr
RUN echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini

# Disable PathInfo
RUN echo "cgi.fix_pathinfo=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Disable expose PHP
RUN echo "expose_php=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN . /root/.nvm/nvm.sh \
  && nvm install lts/dubnium \
  && nvm use lts/dubnium

ADD . /var/www/html
WORKDIR /var/www/html

# RUN touch storage/logs/laravel.log

# RUN composer install
# #RUN php artisan cache:clear
# #RUN php artisan view:clear
# #RUN php artisan route:cache

# RUN chmod -R 777 /var/www/html/storage

# RUN touch /var/log/cron.log

# # ADD deploy/cron/artisan-schedule-run /etc/cron.d/artisan-schedule-run
# # RUN chmod 0644 /etc/cron.d/artisan-schedule-run
# # RUN chmod +x /etc/cron.d/artisan-schedule-run
# # RUN touch /var/log/cron.log

# CMD ["/bin/sh", "-c", "php-fpm -D | tail -f storage/logs/laravel.log"]
