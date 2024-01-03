
main_menu() {
    debug "main_menu $*"
    init_if_absent_repo
    MENU=( 
        "Visualiser_état_courant_du_stock"
        "Modifier_une_entrée"
        "Ajouter_une_entrée"
        "Rechercher_une_entrée"
        "EXIT"
        )
    select choice in ${MENU[@]}; do 
        case $REPLY in 
        1)
            synchronize
            display_inventory_sum_up
            break
        ;;
        2)
            synchronize
            update_entry
            break
        ;;
        3) 
            synchronize
            create_entry
            break
        ;;
        4) 
            synchronize
            read_entry
            break
        ;;
        5) 
            exit_ok
        ;;
        *) 
            print "valeur inconnue : $REPLY"
        ;;
        esac
    done
    main_menu
}

display_inventory() {
    debug "display_inventory $*"
}

synchronize() {
    debug "synchronize $*"
    move_to_local_folder
    git fetch 
    git checkout -b origin/${default_main_branch}
}
create_entry() {
    debug "create_entry $*"
    # saisie dirigée
    print "Saisissez un libellé unique de la pièce : "
    read -p "--> " libelle_unique 
    libelle_unique=${libelle_unique^^}
    libelle_unique=${libelle_unique// /_}
    print "Saisissez une unité : "
    select unite in ${UNITS[*]}; do
        break;
    done 
    print "Saisissez un emplacement : "
    select emplacement in ${EMPLACEMENTS[*]}; do
        break;
    done 
    print "Saisissez une quantité : "
    read -p "--> " quantite 
    print "Saisissez une affectation (ou vide): "
    read -p "--> " affectation 
    print_separator
    print "Confirmez la saisie : ${ORANGE_STYLE}${libelle_unique} ${quantite} ${unite} "
    print "Optionnel : emplacement=${emplacement}"
    if [[ ! -z ${affectation} ]]; then 
    print "Optionnel : affecté à ${affectation}"
    fi 
    # confirmation utilisateur
    # TODO ajouter une lecture au cas ou le libellé unique existe
    yes_or_repeat "create_entry"
    # manip git pour le transactionnel
    reference_date=$(date +"%Y_%m_%d_%H_%M")
    add_entry "${libelle_unique};${unite};${emplacement};${quantite};${affectation};${reference_date}"
    temp_branch_name="move_${reference_date}"
    commit_merge_and_delete ${temp_branch_name}
}
read_entry() {
    debug "read_entry $*"
}
update_entry() {
    debug "update_entry $*"
}

