# A Docker TeX Live Image
For example, this image will be used before submitting to [arXiv](https://arxiv.org) to check compiled PDF.
You can use `latexmk` and `latexdiff`.
For more details on installed packages, please refer [Dockerfile](./Dockerfile).

## Remark
This image contains *TeX Live 2016* because [arXiv runs TeX Live 2016 since 2017-02-09](https://arxiv.org/help/faq/texlive).
Moreover, this contains some "simple extensions of the basic bibstyles to allow an eprint field",
see [BibTeX and Eprints](https://arxiv.org/help/hypertex/bibstyles).

However, this is *NOT* a full installed TeX Live.
If you want to use not-installed packages, you should install them by using `tlmgr`,
or you should make another Docker image by modifying this Dockerfile.

## Usage

``` shell
$ docker run --rm -v $PWD:/work mahito1594/texlive-en latexmk your-document
```

If you want to install some packages before compile,

``` shell
$ docker run --rm -it -v $PWD:/work mahito1594/texlive-en
$ tlmgr install some-packages
$ latexmk your-document
$ exit
```

## License
MIT Licensed, see [LICENCE](./LICENSE).
