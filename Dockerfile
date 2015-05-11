FROM seapy/ruby:2.1.2
MAINTAINER Marian Ignev <m.ignev@gmail.com>

# Intall software-properties-common for add-apt-repository
RUN apt-get update
RUN apt-get install -qq -y software-properties-common

# Install nodejs
RUN apt-get install -qq -y nodejs

# Install mysql client
RUN apt-get install -qq -y mysql-client libmysqlclient-dev libmysqld-dev libmysql++-dev libmysql-cil-dev

# Install Nginx.
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -qq -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
# Add default nginx config
ADD ./conf/container/nginx-sites.conf /etc/nginx/sites-enabled/default

# Install foreman
RUN gem install foreman

RUN apt-get install -qq -y memcached

# Install Rails App
WORKDIR /app
ADD ./Gemfile /app/Gemfile
ADD ./Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test --path /tmp/bundle

ADD . /app

# Add default unicorn config
ADD ./conf/container/unicorn.rb /app/config/unicorn.rb

# Add default foreman config
ADD Procfile /app/Procfile

RUN mkdir -p /app/tmp && mkdir -p /app/log

EXPOSE 8015

RUN bundle install --without development test --path /tmp/bundle
RUN cd /app && bundle exec rake staytus:build
RUN cd /app && chown -R www-data:www-data public/
CMD cd /app && bundle exec foreman start -f Procfile
