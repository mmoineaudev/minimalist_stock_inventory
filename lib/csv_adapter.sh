add_entry_to_database_file() {
    debug "add_entry_to_database_file $*"
    echo "$*" >> ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    sort_inventory
}
set_mesurement_unit() {
    debug "set_mesurement_unit $*"
}
get_entry() {
    debug "get_entry $*"
}
modify_entry() {
    debug "modify_entry $*"
}
display_inventory_sum_up() {
    debug "display_inventory_sum_up $*"
    {
        read # ignore la premiere ligne
        while read -r line; do
            display_record ${line}
        done
    } <${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
}

search_for_entry() {
    debug "search_for_entry $* ($#)"
    #shifting for avoiding caller script name 
    pattern_to_be_searched=( $@ )

    for (( pattern_index=1 ; pattern_index <= $# ; pattern_index++ )) ; do #pattern_index=1 because $!pattern_index 0 is the caller script
        if [[ ${pattern_index} = 1 ]]; then
            formatted_pattern_to_be_searched="${!pattern_index}" # gets the first element of the args array ! is the syntax for ${$index}
        else 
            formatted_pattern_to_be_searched="$formatted_pattern_to_be_searched|${!pattern_index}"
        fi
    done
    
    {
        read # ignore la premiere ligne
        line=0
        while read line_from_db_file; do
            line=$(($line + 1))
            anything_found=
            anything_found=` echo "${line_from_db_file}" | egrep -i ${formatted_pattern_to_be_searched} ` # | egrep '(${formatted_pattern_to_be_searched})'
            if [[ -z ${anything_found}  ]]; then 
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
    echo "${HEADER_CSV}" > ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${temp_file} >> ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    rm ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${temp_file}
    debug "Le fichier inventaire est trié"
}
write_data_and_not_header_to_temp_file() {
    debug "write_data_and_not_header_to_temp_file $*"
    target_file="$1"
    number_of_lines=$(cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | wc -l)
    number_of_last_lines=$(( ${number_of_lines} - 1 ))
    debug "number_of_lines=${number_of_lines} number_of_last_lines=${number_of_last_lines}"
    cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | tail -n ${number_of_last_lines} | sort  > ${target_file}
}

display_all_existing_labels() {
    debug "display_all_existing_labels $*"
}
