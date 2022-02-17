package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/open-policy-agent/opa/rego"
)

// https://jwt.io/
func main() {
	ctx := context.Background()

	r := rego.New(
		rego.Query(os.Args[2]),
		rego.Load([]string{os.Args[1]}, nil))

	query, err := r.PrepareForEval(ctx)
	if err != nil {
		log.Fatal(err)
	}

	raw := fmt.Sprintf(`{
    "endpoint": "authorize",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.drt_po6bHhDOF_FJEHTrK-KD8OGjseJZpHwHIgsnoTM",
    "secret": "%s"
  }`, os.Getenv("JWT_SIGNING_SECRET"))

	d := json.NewDecoder(bytes.NewBufferString(raw))
	d.UseNumber()
	var input interface{}
	if err := d.Decode(&input); err != nil {
		panic(err)
	}

	// var input interface{}
	// dec := json.NewDecoder(os.Stdin)
	// dec.UseNumber()
	// if err := dec.Decode(&input); err != nil {
	// 	log.Fatal(err)
	// }

	rs, err := query.Eval(ctx, rego.EvalInput(input))
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(rs)
}
