FROM node:20.19.5-alpine3.22
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install 
ENV MONGO="true"\
    MONGO_URL="mongodb://mongodb:27017/catalogue"
CMD ["node","server.js"]