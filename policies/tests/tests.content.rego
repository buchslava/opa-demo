package tests.content

import data.content

secret := opa.runtime().env.JWT_SIGNING_SECRET
header := {"typ": "JWT", "alg": "HS256"}

test_ContentAllowReadAndWrite {
  mockInput := {
    "token": io.jwt.encode_sign(header,{
      "role": "admin",
      "exp": round(time.add_date(time.now_ns(), 0, 0, 31) / 1e9),
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := content with input as mockInput
  res.allow_read
  res.allow_write
}

test_ContentAllowReadOnly {
  mockInput := {
    "token": io.jwt.encode_sign({"typ": "JWT", "alg": "HS256"},{
      "role": "user",
      "exp": round(time.add_date(time.now_ns(), 0, 0, 31) / 1e9),
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := content with input as mockInput
  res.allow_read
  not res.allow_write
}

test_ContentDenied {
  mockInput := {
    "token": io.jwt.encode_sign({"typ": "JWT", "alg": "HS256"},{
      "role": "alien",
      "exp": round(time.add_date(time.now_ns(), 0, 0, 31) / 1e9),
    }, {"kty": "oct", "k": base64url.encode_no_pad(secret)}),
  }

  res := content with input as mockInput
  not res.allow_read
  not res.allow_write
}
