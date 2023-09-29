FROM ruby:3.1.4-slim

RUN apt-get update -qq && apt-get install -y build-essential

# Install dependencies
RUN gem install rest-client dotenv

WORKDIR /app

COPY . .

ENV TOKEN=''

CMD ["ruby", "main.rb"]
