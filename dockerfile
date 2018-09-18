FROM node:10.10.0-slim
LABEL maintainer "Marc J. Greenberg <codemarc@gmail.com>"

ENV TZ=America/New_York

RUN cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
    echo "America/New_York" > /etc/timezone 

RUN  apt-get update \
     # See https://crbug.com/795759
     && apt-get install -yq libgconf-2-4 \
     # Install latest chrome dev package, which installs the necessary libs to
     # make the bundled version of Chromium that Puppeteer installs work.
     && apt-get install -y wget --no-install-recommends \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y dos2unix vim \
     && apt-get install -y google-chrome-unstable --no-install-recommends \
     && rm -rf /var/lib/apt/lists/*

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json yarn.lock /
RUN yarn install

ENV  PATH="${PATH}:/node_modules/.bin"

WORKDIR /app

# Add your stuff...

CMD [ "/bin/bash"]