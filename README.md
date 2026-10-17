# vim-jin-test

A [jj](https://github.com/jj-vcs/jj) repository to try
[vim-jin](https://github.com/lambdalisue/vim-jin) on, made the same every
time by a script, down to its change IDs. The
[vim-jin tutorial](https://github.com/lambdalisue/vim-jin/wiki/Tutorial)
walks through it.

## Make it

```sh
git clone https://github.com/lambdalisue/vim-jin-test
cd vim-jin-test
./setup.sh            # makes ./playground; ./setup.sh DIR makes DIR
cd playground/repo
vim +JinLog           # or nvim +JinLog
```

It needs jj 0.46 and Git on `PATH`. Your own jj configuration takes no part in
making it, so the IDs below are the same for everyone; once made, jj and
vim-jin run with your configuration as usual.

To start over, remove the directory and run `./setup.sh` again.

## What it holds

`playground/repo` is a colocated jj repository of a tiny Python module:

| Change | Description | There to try |
| --- | --- | --- |
| `qpvuntsm` | feat: add hello module | immutable history, pushed as `main` |
| `zsuskuln` | docs: add a README | the `main` bookmark, also on `origin` |
| `royxmykx` | feat: greet loudly | a line of changes to reshape |
| `znkkpsqq` | docs: add notes about greetings | |
| `kmkuslsw` | feat: say goodbye to a name | the `topic` bookmark; rewritten several times, for the evolog |
| `uyznsvlq` | feat: greet in French | one side of a conflict |
| `xtnwkqum` | feat: greet in Japanese | the other side |
| `tlkvzzqu` | merge: both greetings | a merge left in conflict |
| `nlrtlrxv` | (the working copy) | edits not yet described |

Next to it, `playground/second` is a second workspace of the same repository,
and `playground/remote.git` the remote it pushes to.

## License

MIT
