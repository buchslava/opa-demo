package tests.auth

import data.auth

secret := auth.runtime.env.JWT_SIGNING_SECRET

test_AuthValid {
  mockInput := {
    "token": io.jwt.encode_sign({"typ": "JWT", "alg": "HS256"},{
      "foo": "bar",
      "exp": round(time.add_date(time.now_ns(), 0, 0, 31) / 1e9),
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := auth with input as mockInput
  count(res.denial_reasons) == 0
}

test_AuthTokenExpired {
  mockInput := {
    "token": io.jwt.encode_sign({"typ": "JWT", "alg": "HS256"},{
      "foo": "bar",
      "exp": round(time.add_date(time.now_ns(), 0, 0, 101) / 1e9),
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := auth with input as mockInput
  res.denial_reasons == {"Token exp is too far in the future"}
}

test_AuthExpMissing {
  mockInput := {
    "token": io.jwt.encode_sign({"typ": "JWT", "alg": "HS256"},{
      "foo": "bar",
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := auth with input as mockInput
  res.denial_reasons == {"Token does not have an exp claim"}
}

test_AuthTokenInvalid {
  mockInput := {
    "token": "some strange thing",
  }

  res := auth with input as mockInput
  res.denial_reasons == {"Token is not valid"}
}
