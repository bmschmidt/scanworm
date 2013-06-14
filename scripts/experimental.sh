

# Prints the running heads: some learning on this could get the actual volume numbers and breaks, for whatever that's worth.
find 100 | sort -n | xargs -n 1 head -1 | perl -pe "s/[^0-9 \n]//g; s/19[012][0-9]//g;s/ +/ /gi;


