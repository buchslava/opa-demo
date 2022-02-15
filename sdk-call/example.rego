package example

output := opa.runtime()

# https://golangissues.com/issues/922307
# has_key(x, k) { _ = x[k] }

authorize_token = {"valid": valid, "payload": payload} {
  [valid, header, payload] := io.jwt.decode_verify(input.token, {
          # "secret": input.secret
          # The following approach (opa.runtime()) does't work by unknown reason :(
          "secret": output.env.JWT_SIGNING_SECRET
          # "secret": opa.runtime()["env"]["JWT_SIGNING_SECRET"]
          # "secret": "mysecret"
  })
}

default allow = false
allow {
        input.endpoint = "authorize"
        authorize_token.valid == true
        authorize_token.payload["foo.bar"]
}
