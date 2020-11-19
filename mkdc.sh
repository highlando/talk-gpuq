MDFILE=slides.md

pandoc $MDFILE -o slides.html \
    --mathjax --filter pandoc-citeproc -t revealjs --slide-level=2 -s \
    -V theme=solarized \
    -V viewDistance=15 -V width=1280 -V height=880 -V margin=0.05
