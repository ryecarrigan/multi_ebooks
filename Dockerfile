FROM ruby:2.4-stretch

RUN gem install twitter_ebooks \
 && useradd -ms /bin/bash ebooks

WORKDIR /home/ebooks
ADD . .
RUN chown -R ebooks:ebooks /home/ebooks

USER ebooks
ENTRYPOINT /usr/local/bundle/bin/ebooks start
