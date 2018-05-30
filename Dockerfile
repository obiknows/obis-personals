# Using alpine as builder container (builder box)
FROM alpine as builder

# Set the Work Directory
WORKDIR /obi-site
COPY . .
# set the env
ENV HUGO_VERSION 0.37.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit
# Install pygments (for syntax highlighting) and bash
RUN apk update && apk add py-pygments && apk add bash && apk add ca-certificates && rm -rf /var/cache/apk/*
# Download and Install hugo
RUN mkdir /usr/local/hugo
ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
  && ln -s /usr/local/hugo/hugo /usr/local/bin/hugo \
  && rm /usr/local/hugo/${HUGO_BINARY}.tar.gz
# Build the site
RUN hugo

# ...Then...Run NGINX with the compiled static site
FROM nginx:alpine
COPY --from=builder /obi-site/public /usr/share/nginx/html
