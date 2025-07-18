FROM python:3.13-alpine

ARG user=adr
ARG group=pyops
ARG CACHE_BREAKER=1

# Install dependencies, tools and install the gh CLI
RUN apk update
RUN apk add --no-cache \
    cmake \
    apache-arrow-dev \
    build-base \
    bash \
    curl

# In order for the gh CLI to work in the environment, we need to set the PATH
# This way, we can invoke it from the command line from anywhere
# The gh CLI is installed in /root/.local/bin by default
ENV PATH="/root/.local/bin:${PATH}"
ENV PORT=8080
ENV HOST="0.0.0.0"

RUN addgroup ${group}
RUN adduser -D ${user} -G ${group}

WORKDIR /app
COPY . .
RUN chown -R ${user}:${group} /app \
    && chmod 755 /app/docker/entrypoint.sh

# Set the user to the one we created
USER ${user}

RUN pip install --upgrade pip && pip install -r /app/docker/production.txt
EXPOSE ${PORT}

ENTRYPOINT ["/app/docker/entrypoint.sh"]
