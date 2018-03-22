FROM node:8.10

WORKDIR /usr/src

RUN git clone http://192.168.1.75/themanzi/testExpress.git

COPY . .

EXPOSE 3000

WORKDIR /usr/src/testExpress
CMD ["npm", "start"]