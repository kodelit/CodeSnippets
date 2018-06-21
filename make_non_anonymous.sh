#!/bin/sh

SCRIPTPATH="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPTPATH}"

for filename in *.codesnippet; do
	name="${filename%.*}"
    name="${name##*/}"
    shortcut=$(grep $proj)
    rename 's/name/safe/g' *.jpg
done

while read p; do
    if [[ -n $p ]] && [[ ! $p = ${comment_sufix}* ]] ; then
        echo $p

        # input
        variable_name="SCRIPT_INPUT_FILE_${count}"
        printf -v $variable_name "${SCRIPT_INPUT_DIR}/$p"
        export $variable_name

        # output
        variable_name="SCRIPT_OUTPUT_FILE_${count}"
        printf -v $variable_name "${SCRIPT_OUTPUT_DIR}/$p"
        export $variable_name

        count=$(($count + 1))
    fi
done < "${__DEPENDENCIES_DIR}/Carthage-CopyFrameworks-List"