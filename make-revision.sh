#!/bin/bash

BASENAME=buildproblems
CUR=$1
LIST=`git tag -l | grep -E "^$CUR\$" -B1 | head -n2`
LIST=( $LIST )
LIST_COUNT=${#LIST[@]}

git checkout $CUR

DATE_AS_STRING=`git log -1 --format=%cd $CUR --date=format:'%B \\\\nth{%d}, %Y'`


cp main.tex input.tex
sed -i 's/\\today/'"$DATE_AS_STRING"'/' input.tex
sed -i 's/RedefineRevision/RedefineRevision\n\\renewcommand{\\revision}{'"{$CUR}"'}/' input.tex

make current INPUT=input.tex
mv input.pdf ${BASENAME}-$CUR.pdf


if [[ $LIST_COUNT == "2" ]]

then
	PREV=( ${LIST[0]} )
	cp main.tex new.tex
	git checkout $PREV
	cp main.tex old.tex
	latexdiff old.tex new.tex > input.tex
	rm new.tex
	rm old.tex
	
	sed -i 's/change_description_here/change_description_here\nContent added since last revision is written in \\DIFaddbegin  \\DIFadd{blue text with curly underline} \\DIFaddend while content removed is written in \\DIFdelbegin \\DIFdel{red text with strike through}.\\DIFdelend/' input.tex

	sed -i 's/\\today/'"$DATE_AS_STRING"'/' input.tex
	sed -i 's/RedefineRevision/RedefineRevision\n\\renewcommand{\\revision}{'"{$CUR}"'}/' input.tex
	
	make current INPUT=input.tex
	mv input.pdf ${BASENAME}-$PREV-to-$CUR-with-changes.pdf

elif [[ $LIST_COUNT == "1" ]]
then
	echo "Nop"
else
	echo "Makes nuffin"
	exit 1
fi
rm -f input.tex
make clean INPUT=input.tex
git reset --hard
git checkout master
