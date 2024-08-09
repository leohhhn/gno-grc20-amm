package dex

import (
	"std"
	"strings"

	"gno.land/p/demo/ufmt"
	pusers "gno.land/p/demo/users"
	"gno.land/r/demo/foo20"
	"gno.land/r/demo/wugnot"
)

var (
	bucket = make(map[string]uint64)
	dex    = std.CurrentRealm()
)

// Please approve tokens beforehand
func AddLP(token1sym, token2sym string, token1amt, token2amt uint64) string {
	if token1amt == 0 || token2amt == 0 {
		panic("you need to provide both tokens to the LP bucket!")
	}

	token1sym = strings.TrimSpace(token1sym)
	token2sym = strings.TrimSpace(token2sym)

	if token1sym == "" || token2sym == "" {
		panic("symbols cannot be empty")
	}

	if token1sym == token2sym {
		panic("symbols cannot be the same")
	}

	caller := std.PrevRealm().Addr() // std.Address

	// todo: whitelist foo20 and wugnot for swap
	foo20.TransferFrom(pusers.AddressOrName(caller.String()), pusers.AddressOrName(dex.Addr().String()), token1amt)
	wugnot.TransferFrom(pusers.AddressOrName(caller.String()), pusers.AddressOrName(dex.Addr().String()), token2amt)
	// DEX has balances now.

	bucket[token1sym] += token1amt
	bucket[token2sym] += token2amt

	return ufmt.Sprintf("deposited %d $%s & %d $%s", token1amt, token1sym, token2amt, token2sym)
}

func Swap() {

}

func Render(_ string) string {
	return ufmt.Sprintf("bucket: %d $%s & %d $%s", bucket["wugnot"], "wugnot", bucket["FOO"], "FOO")
}
