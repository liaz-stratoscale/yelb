FROM bitnami/ruby:2.4.2-r1
MAINTAINER omer.kushmaro@stratoscale.com

################## BEGIN INSTALLATION ######################

# Set the working directory to /app
WORKDIR /app

COPY yelb-appserver.rb yelb-appserver.rb

ENV LANG=en_us.UTF-8
ENV LC_ALL=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update \
 && apt-get install libpq-dev -y \
 && gem install sinatra --no-ri --no-rdoc \
 && gem install pg --no-ri --no-rdoc

##################### INSTALLATION END #####################

EXPOSE 4567

CMD /bin/sh -c "ruby yelb-appserver.rb -o 0.0.0.0"