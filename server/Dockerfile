FROM ruby:2.4.1-onbuild
MAINTAINER Codepace

# Housekeeping
#RUN apk update && apk upgrade
#RUN apk add ruby ruby-bundler
#RUN rm -rf /var/cache/apk/*

#RUN mkdir /usr/app
#WORKDIR /usr/app

#COPY Gemfile /usr/app/
#COPY Gemfile.lock /usr/app/
#RUN bundle install

#COPY . /usr/app

CMD ["./server.rb"]
