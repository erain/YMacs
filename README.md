# YMacs

This is erain@'s personal emacs configurations.

The configurations were heavily inspired by [prelude](https://github.com/bbatsov/prelude). If  you are looking for an out-of-the-box emacs configurations, my suggestion is to use that. I forked/rewrite of prelude simply because I want to learn, understand and control all my emacs configurations.

## Go mode setup

There are some extra toolings needed to be set up for Go programming.

``` bash
# Install go tools
GO111MODULE=on go get golang.org/x/tools/cmd/...
# Install gopls
GO111MODULE=on go get golang.org/x/tools/gopls@latest
```
