package example

output := opa.runtime()

authorize_token = {"valid": valid, "payload": payload} {
  [valid, header, payload] := io.jwt.decode_verify(input.token, {
          "secret": output.env.JWT_SIGNING_SECRET
  })
}

default allow = false
allow = true {
        input.endpoint = "authorize"
        authorize_token.valid == true
        authorize_token.payload["sub"]
}
