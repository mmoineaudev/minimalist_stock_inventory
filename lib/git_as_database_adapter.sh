create_branch() {
    debug "create_branch $*"
    branch_name="$1"
    git checkout -b ${branch_name}
}
commit_temporary_branch() {
    debug "commit_temporary_branch $*"
    branch_name="$1"
    git add ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    git commit -m "Mouvement ${branch_name}"
    git push --set-upstream origin ${branch_name}
}

commit_merge_and_delete() {
    debug "commit_merge_and_delete $*"
    temp_branch_name="$1"
    create_branch "${temp_branch_name}"
    commit_temporary_branch "${temp_branch_name}"
    debug "$(git log --graph)"
    git checkout origin/${default_main_branch}
    git pull
    git merge ${temp_branch_name} || exit_if_error
    git push -u origin ${default_main_branch} || exit_if_error
    debug "$(git log --graph)"
    git status
}

init_if_absent_repo() {
    debug "init_if_absent_repo $*"

    if [[ -z ${REMOTE_URL} ]]; then
        print "Ce script a besoin des informations déclarées dans configuration.conf"
        print "Arrêt du traitement, merci de valoriser les properties git"
        exit_if_error
    fi

    if [[ -e ${DOT_GIT_PATH} ]]; then
        debug "${DOT_GIT_PATH} existe"
    else
        debug "${DOT_GIT_PATH} n'existe pas"
        mkdir -p ${LOCAL_REPO_PATH} && debug "${LOCAL_REPO_PATH} créé"
        clone_database_repo
    fi
    check_if_csv_exists_and_create_it
}

clone_database_repo() {
    debug "clone_and_check_if_csv_exists $*"
    cd ${LOCAL_REPO_PATH}
    git clone ${REMOTE_URL} ${LOCAL_FOLDER_NAME} || exit_if_error
    move_to_local_folder
}

check_if_csv_exists_and_create_it() {
    debug "check_if_csv_exists_and_create_it $*"
    if [[ -e ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} ]]; then
        debug "Le fichier ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} a été trouvé"
    else
        debug "Le fichier ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} est introuvable"
        init_csv_file
    fi
}

init_csv_file() {
    debug "init_csv_file $*"
    # On écrit l'entête
    echo ${HEADER_CSV} >${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    # On cree la branche et on push
    move_to_local_folder
    git checkout -b ${default_main_branch}
    git add ${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME}
    git commit -m "Initialisation du fichier ${DATABASE_FILE_NAME}"
    git push -f origin ${default_main_branch} || exit_if_error
    git status
    debug "${LOCAL_REPO_PATH}/${LOCAL_FOLDER_NAME}/${DATABASE_FILE_NAME} a été initialisé"
}

update_inventory_sum_up() {
    debug "update_inventory_sum_up $*"
}
