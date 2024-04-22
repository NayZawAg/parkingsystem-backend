# see: https://docs.docker.com/compose/rails/
FROM --platform=linux/x86_64 ruby:3.0.3

ENV TZ=Asia/Tokyo

ARG DEBIAN_FRONTEND=noninteractive

# For Macbook pro with M1 Chip
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN set -x && apt-get update -y -qq \
            && apt-get upgrade -y \
            && apt-get install -y \
                yarn  \
                nodejs \
                vim \
                curl \
                apt-utils \
                locales \
                locales-all \
                freetds-dev \
                freetds-common \
                freetds-bin \
                build-essential \
                libc6-dev \
                cron \
            && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
            && mkdir /app

RUN apt-get install -y nodejs npm && npm install n -g && n 14.17.0

# For Macbook pro with Intel Chip
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -\
#     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -a\
#     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#     && apt-get update -qq \
#     && apt-get upgrade -y \
#     && apt-get install -y \
#         yarn  \
#         nodejs \
#         vim \
#         curl \
#         apt-utils \
#         locales \
#         locales-all \
#         freetds-dev \
#         freetds-common \
#         freetds-bin \
#         build-essential \
#         libc6-dev \
#         cron \
#     && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
#     && mkdir /app

RUN locale-gen ja_JP.UTF-8

ENV ROOT="/app"
WORKDIR ${ROOT}

EXPOSE 3000
