FROM r-base
FROM node

WORKDIR /usr/src/app
COPY . .
RUN npm install --production --silent

EXPOSE 5000
CMD [ "node", "./backend/index.js" ]
