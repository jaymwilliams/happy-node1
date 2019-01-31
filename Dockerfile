FROM node:10.13

RUN mkdir -p /application
WORKDIR /application

COPY package.json package-lock.json /application/
RUN npm -q install --only=prod && npm -q cache clean --force
COPY app/ /application/app/

EXPOSE 3000

ENTRYPOINT ["npm", "start"]
