#!/bin/sh
set -e
cd /app

if [ "$FIRST_RUN" = "true" ]; then
  ./nodebb setup "{
    \"url\": \"$FORUM_URL\",
    \"secret\": \"$FORUM_SECRET\",
    \"database\": \"mongo\",
    \"port\": \"${PORT:-10000}\",
    \"mongo:uri\": \"$MONGO_URI\",
    \"admin:username\": \"$ADMIN_USER\",
    \"admin:email\": \"$ADMIN_EMAIL\",
    \"admin:password\": \"$ADMIN_PASSWORD\",
    \"admin:password:confirm\": \"$ADMIN_PASSWORD\"
  }"
else
  cat > config.json <<EOF
{
  "url": "$FORUM_URL",
  "secret": "$FORUM_SECRET",
  "database": "mongo",
  "port": "${PORT:-10000}",
  "mongo": { "uri": "$MONGO_URI" }
}
EOF
fi

NODE_OPTIONS="--max-old-space-size=320" ./nodebb build --series
exec node loader.js --no-daemon --no-silent
