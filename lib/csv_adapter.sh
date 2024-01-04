add_entry_to_database_file() {
    debug "add_entry_to_database_file $*"
    echo "$*" >>${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
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
    cat ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} | tail -n +1 | sort >${temp_file}
    debug "TEMP_FILE : $(cat ${temp_file})"
    # on réécrit l'entete
    echo "libellé_unique;unité;emplacement;quantité;affectation;date_update" >${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    cat ${temp_file} >>${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    rm ${temp_file}
    debug "Le fichier inventaire est trié"
}

display_all_existing_labels() {
    debug "display_all_existing_labels $*"
}
