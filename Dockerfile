# ─── STAGE 1: Builder ───────────────────────────────────────────────
FROM ruby:3.2.0-slim AS builder

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  curl \
  git \
  libvips \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN bundle config set --local without 'development test' \
  && bundle install --jobs 4 --retry 3

RUN mkdir -p app/assets/images/camaleon_cms && \
    printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\x0f\x00\x00\x01\x01\x00\x05\x18\xd8N\x00\x00\x00\x00IEND\xaeB`\x82' \
    > app/assets/images/camaleon_cms/theturtlefoundation-logo.png

RUN SECRET_KEY_BASE=dummykey RAILS_ENV=production bundle exec rails assets:precompile

# ─── STAGE 2: Runtime ───────────────────────────────────────────────
FROM ruby:3.2.0-slim AS runtime

RUN apt-get update -qq && apt-get install -y \
  libpq-dev \
  postgresql-client \
  libvips \
  curl \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash rails
WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

RUN mkdir -p /app/tmp/pids /app/tmp/cache /app/tmp/sockets
RUN chown -R rails:rails /app

USER rails
EXPOSE 3000

COPY --chown=rails:rails docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]