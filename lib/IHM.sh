
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
            export_inventory_sum_up
            display_inventory
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
}
create_entry() {
    debug "create_entry $*"
}
read_entry() {
    debug "read_entry $*"
}
update_entry() {
    debug "update_entry $*"
}