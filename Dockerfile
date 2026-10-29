FROM node:22-slim
RUN apt-get update && apt-get install -y git build-essential imagemagick \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# כדאי לבדוק מהו הענף היציב העדכני ב-github.com/NodeBB/NodeBB
ARG NODEBB_BRANCH=v4.x
RUN git clone --depth 1 --branch ${NODEBB_BRANCH} https://github.com/NodeBB/NodeBB.git .
RUN cp install/package.json package.json && npm install --omit=dev
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]
