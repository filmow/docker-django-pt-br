FROM avelino/docker-opps:latest
MAINTAINER Thiago Avelino <avelino@filmow.com>

# set pt-br
RUN aptitude update \
	&& aptitude install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

# install lessc
ENV RUBY_MAJOR 2.0
ENV RUBY_VERSION 2.0.0-p647
ENV RUBY_DOWNLOAD_SHA256 c88aaf5b4ec72e2cb7d290ff854f04d135939f6134f517002a9d65d5fc5e5bec
ENV RUBYGEMS_VERSION 2.4.8
RUN echo 'install: --no-document\nupdate: --no-document' > "$HOME/.gemrc"
RUN apt-get update \
	&& apt-get install -y bison libgdbm-dev ruby \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
	&& tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.gz \
	&& cd /usr/src/ruby \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	&& apt-get purge -y --auto-remove bison libgdbm-dev ruby \
	&& gem update --system $RUBYGEMS_VERSION \
    && /usr/local/bin/gem install therubyracer \
    && /usr/local/bin/gem install less
