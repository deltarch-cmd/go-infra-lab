# Base
FROM golang:1.25-bookworm

# If it is needed to run something before deploying
RUN apt-get update \
    && apt-get upgrade -y \
    && mkdir -p /usr/local/app

# Set working directory
WORKDIR /usr/local/app

# To copy files from host-path to image-path
COPY . /usr/local/app

EXPOSE 8080

# Setup an app user so the container does not run as root
RUN useradd app
USER app

CMD ["go", "run", "main.go"]
