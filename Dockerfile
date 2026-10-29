FROM node:22-slim
RUN apt-get update && apt-get install -y git build-essential imagemagick \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ARG NODEBB_BRANCH=v4.x
RUN git clone --depth 1 --branch ${NODEBB_BRANCH} https://github.com/NodeBB/NodeBB.git .
RUN cp install/package.json package.json && npm install --omit=dev
# הבנייה צריכה גישה למסד. הסוד קיים רק בזמן ההרצה ונמחק באותו שלב
RUN --mount=type=secret,id=mongo_uri \
    printf '{"url":"http://localhost:4567","secret":"build-only","database":"mongo","mongo":{"uri":"%s"}}' "$(cat /run/secrets/mongo_uri)" > config.json \
    && ./nodebb build \
    && rm -f config.json
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]
