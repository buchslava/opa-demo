# OPA integration demo

## Install

```
npm i
```
Also, install OPA

`curl -L -o opa https://openpolicyagent.org/downloads/v0.35.0/opa_linux_amd64_static` for Linux

or

`curl -L -o opa https://openpolicyagent.org/downloads/v0.35.0/opa_darwin_amd64` for MacOS

And `chmod 775 ./opa` after that.


## Run servers

Opa server: `npm run opa:server`

Demo Microservice: `npm start`

## Run examples

```
cd scripts
./admin
./expire
./user
```

### Test OPA rule via Docker

```
./test
```

or

```
npm run opa:test
```

<!--
https://aws.amazon.com/blogs/opensource/creating-a-custom-lambda-authorizer-using-open-policy-agent/
https://golangissues.com/issues/437371
https://spacelift.io/blog/what-is-open-policy-agent-and-how-it-works
-->
