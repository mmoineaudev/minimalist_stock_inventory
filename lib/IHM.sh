main_menu() {
    debug "main_menu $*"
    init_if_absent_repo
    MENU=(
        "Visualiser_état_courant_du_stock"
        "Modifier_une_entrée"
        "Ajouter_une_entrée"
        "Rechercher_une_entrée"
        "Supprimer_une_entrée"
        "EXIT"
    )
    select choice in ${MENU[@]}; do
        case $REPLY in
        1 | "Visualiser_état_courant_du_stock")
            synchronize
            display_inventory_sum_up
            break
            ;;
        2 | "Modifier_une_entrée")
            synchronize
            update_entry
            break
            ;;
        3 | "Ajouter_une_entrée")
            synchronize
            create_and_add_entry_to_database_file_and_then_push_it
            break
            ;;
        4 | "Rechercher_une_entrée")
            synchronize
            read_entry
            break
            ;;
        5 | "Supprimer_une_entrée")
            synchronize
            delete_entry
            break
            ;;
        6 | "EXIT")
            exit_ok
            ;;
        *)
            print "valeur inconnue : $REPLY"
            ;;
        esac
    done
    clean
    main_menu
}

display_inventory() {
    debug "display_inventory $*"
}

synchronize() {
    debug "synchronize $*"
    move_to_local_folder
    git fetch
    git checkout ${default_main_branch}
    git branch --set-upstream-to=origin/${default_main_branch} ${default_main_branch}
    git pull
}

create_and_add_entry_to_database_file_and_then_push_it() {
    debug "create_and_add_entry_to_database_file_and_then_push_it $*"

    # saisie dirigée
    display_inventory_sum_up LABELS_ONLY
    print "Saisissez un libellé unique de la pièce : "
    read -p "--> " libelle_unique
    libelle_unique=${libelle_unique^^}
    libelle_unique=${libelle_unique// /_}
    print "Saisissez une unité : "
    select unite in ${UNITS[*]}; do
        break
    done
    print "Saisissez une quantité : "
    read -p "--> " quantite
    print "Saisissez un emplacement : "
    select emplacement in ${EMPLACEMENTS[*]}; do
        break
    done

    print "Saisissez une affectation (ou vide): "
    read -p "--> " affectation
    print_separator
    print "Confirmez la saisie : ${ORANGE_STYLE}${libelle_unique} ${quantite} ${unite} "
    print "Optionnel : emplacement=${emplacement}"
    if [[ ! -z ${affectation} ]]; then
        print "Optionnel : affecté à ${affectation}"
    fi

    # confirmation utilisateur
    yes_or_repeat "create_and_add_entry_to_database_file_and_then_push_it"
    # manip git pour le transactionnel
    reference_date=$(date +"%Y_%m_%d_%H_%M_%S")
    add_entry_to_database_file "${libelle_unique};${unite};${emplacement};${quantite};${affectation};${reference_date}"
    temp_branch_name="move_${reference_date}"
    commit_merge_and_delete ${temp_branch_name}
}

read_entry() {
    debug "read_entry $*"
    print "Saisissez les valeurs que vous souhaitez chercher, espacées par des espaces :"
    read -r -p "# " patterns
    search_for_entry ${patterns[@]}
}

update_entry() {
    debug "update_entry $*"
    display_inventory_sum_up ONLY_LABELS
    print "Saisissez l'ID de la ligne que vous souhaitez modifier :"
    read -p " # " id
    print ${id}
    all_lines_temp_file=temp_all_lines_without_header.tmp
    
    write_data_and_not_header_to_temp_file ${all_lines_temp_file}

    total_lines=$( cat ${all_lines_temp_file} | wc -l )
    head_count=$(( $id-1 ))
    debug "head_count" ${head_count}
    tail_count=$(( $total_lines - $id ))
    debug "tail_count" ${tail_count}
    line_to_be_updated=$( cat ${all_lines_temp_file} | head -n $id | tail -n 1 )
    display_record ${line_to_be_updated}
    grep -v "${line_to_be_updated}" ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} > update.tmp
    cat update.tmp > ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    print "Saisissez les nouvelles valeurs pour $(echo ${line_to_be_updated}) :"
    create_and_add_entry_to_database_file_and_then_push_it
    
}

delete_entry() {
    debug "delete_entry $*"
    display_inventory_sum_up ONLY_LABELS
    print "Saisissez l'ID de la ligne que vous souhaitez supprimer :"
    read -p " # " id
    print ${id}
    all_lines_temp_file=temp_all_lines_without_header.tmp
    
    write_data_and_not_header_to_temp_file ${all_lines_temp_file}

    total_lines=$( cat ${all_lines_temp_file} | wc -l )
    head_count=$(( $id-1 ))
    debug "head_count" ${head_count}
    tail_count=$(( $total_lines - $id ))
    debug "tail_count" ${tail_count}
    line_to_be_deleted=$( cat ${all_lines_temp_file} | head -n $id | tail -n 1 )
    display_record ${line_to_be_deleted}
    grep -v "${line_to_be_deleted}" ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} > delete.tmp
    cat delete.tmp > ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
}

