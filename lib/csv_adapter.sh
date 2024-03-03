add_entry_to_database_file() {
    debug "add_entry_to_database_file $*"
    echo "$*" >>${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    sort_inventory
}



display_inventory_sum_up() {
    label=$1
    debug "display_inventory_sum_up $*"
    if [[ -z ${label} ]]; then
        print_title "Inventaire complet"
    else
        print_title "Labels de pièces"
    fi
    {
        read # ignore la premiere ligne
        label_id=0
        while read -r line; do
            label_id=$(( $label_id + 1 ))
            if [[ -z ${label} ]]; then
                display_record ${line}
            else
                libelle_unique=$(echo ${line} | cut -f1 -d ";")
                print " = ${libelle_unique} ${ORANGE_STYLE} ID: ${label_id} "
            fi
        done
    } <${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
}

search_for_entry() {
    debug "search_for_entry $* ($#)"

    # transforms the parameter array into grep 'or' regex syntax
    for ((pattern_index = 1; pattern_index <= $#; pattern_index++)); do #pattern_index=1 because $!pattern_index 0 is the caller script
        if [[ ${pattern_index} = 1 ]]; then
            formatted_pattern_to_be_searched="${!pattern_index}" # gets the first element of the args array ! is the syntax for ${$index}
        else
            formatted_pattern_to_be_searched="${formatted_pattern_to_be_searched}|${!pattern_index}"
        fi
    done

    # search
    {
        read # ignore la premiere ligne
        line=0
        while read line_from_db_file; do
            line=$(($line + 1))
            anything_found=
            anything_found=$(echo "${line_from_db_file}" | egrep -i ${formatted_pattern_to_be_searched})
            if [[ -z ${anything_found} ]]; then
                debug "Nothing found line ${line}"
            else
                print "Record found : ${ORANGE_STYLE}ID = ${line}" # id is line number - 1
                display_record ${line_from_db_file}
            fi
        done
    } <${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}

}

sort_inventory() {
    debug "sort_inventory $*"
    temp_file="fichier_temporaire_sans_entete.csv"
    # on copie tout sauf l'entete dans un fichier temporaire
    # cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | tail -n +1 | sort > ${temp_file}
    write_data_and_not_header_to_temp_file ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${temp_file}
    # on réécrit l'entete
    echo "${HEADER_CSV}" >${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${temp_file} >>${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    rm ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${temp_file}
    debug "Le fichier inventaire est trié"
}
write_data_and_not_header_to_temp_file() {
    debug "write_data_and_not_header_to_temp_file $*"
    target_file="$1"
    number_of_lines=$(cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | wc -l)
    number_of_last_lines=$((${number_of_lines} - 1))
    debug "number_of_lines=${number_of_lines} number_of_last_lines=${number_of_last_lines}"
    cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | tail -n ${number_of_last_lines} | sort >${target_file}
}

display_record() {
    value="$*"

    libelle_unique=$(echo ${value} | cut -f1 -d ";")
    unite=$(echo ${value} | cut -f2 -d ";")
    emplacement=$(echo ${value} | cut -f3 -d ";")
    quantite=$(echo ${value} | cut -f4 -d ";")
    affectation=$(echo ${value} | cut -f5 -d ";")
    date_update=$(echo ${value} | cut -f6 -d ";")

    print "${ORANGE_STYLE}${libelle_unique} - ${BLUE_STYLE}${quantite} ${unite}\n${ORANGE_STYLE}${emplacement} \t ${BLUE_STYLE}[${affectation} ${date_update}]"
    print_separator NO_BREAK_LINE
}
