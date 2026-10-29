#!/bin/sh
set -e
cd /app
cat > config.json <<EOF
{
  "url": "$FORUM_URL",
  "secret": "$FORUM_SECRET",
  "database": "mongo",
  "port": "${PORT:-10000}",
  "mongo": { "uri": "$MONGO_URI" }
}
EOF
exec node loader.js --no-daemon --no-silent
