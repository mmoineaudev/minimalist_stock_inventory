wait_for_user_confirmation() {
    OK=
    read OK
}
print_separator() {
    ## Affiche un séparateur
    echo -e "  ${UDERLINE_STYLE}                                                ${RAZ_STYLE}"
    echo
}
print_title() {
    ## Affiche un titre, prends le titre en paramètre
    print_separator
    echo -e " ${PROMPT_STYLE}         $1         $RAZ_STYLE "
    print_separator
}
print() {
    echo -e "${PROMPT_STYLE}$*${RAZ_STYLE}"
}

debug() {
    if [[ ${DEBUG} == 1 ]]; then 
        echo -e "${RED_STYLE}[DEBUG] : $* ${RAZ_STYLE}"
    fi
}

# pour normaliser l'affichage menu, prends deux paramètres, le numéro de l'item, et le label
prompt_menu_item() {
    if [[ $2 ]]; then 
        echo -e "${ORANGE_STYLE} $1 \t ${BLUE_STYLE} -->  $2 ${RAZ_STYLE}"
    else 
        echo -e "${ORANGE_STYLE} --> $1 ${RAZ_STYLE}"
    fi
}

exit_ok() {
    print "Bonne journée !"
    exit 0
}

title() {
    echo -e ${BLUE_STYLE}
    echo -e ' 
 _ _|   \ | \ \   / __|   \ | __ __| _ \  _ \ \ \  / 
   |   .  |  \ \ /  _|   .  |    |  (   |   /  \  /  
 ___| _|\_|   \_/  ___| _|\_|   _| \___/ _|_\   _|   
'
    echo -e ${RAZ_STYLE}
}


