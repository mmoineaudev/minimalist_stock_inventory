
yes_or_repeat() {
    # $* est la fonction passée en parametre et executee dans le cas "non"
    select yes_no in "oui" "non"; do
        case $yes_no in
            "oui")
                break
            ;;
            "non")
                $*
                break
            ;;
            *)
                continue
            ;;
        esac
    done
}