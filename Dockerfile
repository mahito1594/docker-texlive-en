FROM frolvlad/alpine-glibc:latest

LABEL maintainer="Mahito Tanno <pb94.mahito@gmail.com>"

ARG TL_VERSION="2016"
ARG TL_REPO="ftp://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${TL_VERSION}"
ARG TEXMFLOCAL="/usr/local/texlive/texmf-local"

ENV PATH /usr/local/texlive/${TL_VERSION}/bin/x86_64-linux:$PATH

WORKDIR /tmp/install-tl-unx

RUN set -x && \
    apk update && apk add --no-cache perl fontconfig-dev freetype-dev make && \
    apk add --no-cache --virtual .build-tool gnupg wget tar xz && \
    # Download installer
    wget -qO - "${TL_REPO}/install-tl-unx.tar.gz" | \
    tar xz -C /tmp/install-tl-unx --strip-components 1 && \
    # Install TeXLive
    echo -e "selected_scheme scheme-basic\n\
option_doc 0\n\
option_src 0" > texlive.profile && \
    ./install-tl -profile ./texlive.profile -repository "${TL_REPO}/tlnet-final/" && \
    tlmgr install \
        collection-latexrecommended collection-latexextra \
        collection-fontsrecommended \
        latexmk latexdiff && \
    # Download the arXiv bibstyles which support eprint field:
    #   see https://arxiv.org/help/hypertex/bibstyles
    mkdir -p "${TEXMFLOCAL}/bibtex/bst/arxiv" && \
    wget -qO - https://static.arxiv.org/static/arxiv.marxdown/0.1/help/hypertex/bibstyles/bibstyles.tar.gz | \
    tar xvz -C "${TEXMFLOCAL}/bibtex/bst/arxiv" --strip-components 1 && \
    mktexlsr && \
    # Clean up
    rm -rf /tmp/* && \
    apk del .build-tool

WORKDIR /work
CMD ["/bin/sh"]
