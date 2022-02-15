package auth

runtime := opa.runtime()

token := {"valid": valid, "claims": payload} {
  [valid, _, payload] := io.jwt.decode_verify(input.token, {"secret": runtime.env.JWT_SIGNING_SECRET})
}

denial_reasons["Token is not valid"] {
 not token.valid
}

denial_reasons["Token does not have an exp claim"] {
  token.valid
  not token.claims.exp
}

denial_reasons["Token exp is too far in the future"] {
  token.claims.exp > round(time.add_date(time.now_ns(), 0, 0, 91) / 1e9)
}
