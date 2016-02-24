FROM ruby
RUN apt-get update
RUN apt-get install vim -y
RUN mkdir /app
ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app
RUN bundle
RUN bash
