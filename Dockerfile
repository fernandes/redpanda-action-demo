FROM ruby:3-alpine

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN bundle install --path vendor/bundle
CMD ["bundle", "exec", "rake"]


