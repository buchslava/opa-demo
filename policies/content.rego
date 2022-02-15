package content

import input
import future.keywords.in
import data.auth

default allow_read = false
allow_read = true {
  count(auth.denial_reasons) == 0
  auth.token.claims.role in ["admin", "user"]
}

default allow_write = false
allow_write = true {
  count(auth.denial_reasons) == 0
  auth.token.claims.role == "admin"
}
