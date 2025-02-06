
yes_or_repeat() {
    # $* est la fonction passée en parametre et executee dans le cas "non"
    select yes_no in "oui" "non"; do
        case $REPLY in
            1|"oui")
                break
            ;;
            2|"non")
                $*
                break
            ;;
            *)
                continue
            ;;
        esac
    done
}

exit_if_error() {
    echo -e "${RED_STYLE}Une erreur non gérée est survenue, arrêt du traitement${RAZ_STYLE}"
    exit 1
}

move_to_local_folder() {
    debug "move_to_local_folder $*"
    cd ${LOCAL_REPO_PATH} || exit_if_error
    cd ${LOCAL_FOLDER_NAME} || exit_if_error
}
clean() {
    move_to_local_folder
    rm -f *.tmp
}
