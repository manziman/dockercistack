FROM golang

WORKDIR /go/src/
COPY . .

RUN git clone http://192.168.1.75/themanzi/testWeb.git
RUN go install testWeb