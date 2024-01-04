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
            echo "${line}"
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
