
fetch_and_create_branch() {
    debug "fetch_and_create_branch $*"
}
push_and_remove_branch() {
    debug "push_and_remove_branch $*"
}
init_if_absent_repo() {
    debug "init_if_absent_repo $*"

    if [[ -z ${REMOTE_URL} ]]; then
        print "Ce script a besoin des informations déclarées dans configuration.conf"
        print "Arrêt du traitement, merci de valoriser les properties git"
        exit_ok
    fi 


    if [[ ! -e ${DOT_GIT_PATH} ]]; then
        debug "${DOT_GIT_PATH} n'existe pas"
        mkdir -p ${LOCAL_REPO_PATH} && debug "${LOCAL_REPO_PATH} créé"
        clone_and_check_if_csv_exists
    else 
        debug "${DOT_GIT_PATH} existe"
    fi
}
clone_and_check_if_csv_exists() {
    debug "clone_and_check_if_csv_exists $*"
}
update_inventory_sum_up() {
    debug "update_inventory_sum_up $*"
}