#!/bin/bash
######################################
#
# WIP gestionnaire de stock
#
######################################

######################################
# Imports
######################################
BASEDIR=$(dirname "$0")
# Déclaration des noms de fichiers dans le répertoire des dépendances 
IMPORTS=(
    csv_adapter.sh 
    git_as_database_adapter.sh 
    IHM.sh 
    style.sh 
    utility.sh
    ../configuration.conf
) # l'ordre d'import n'importe pas, une fois les fichiers sourcés chacunes des fonctions appelées depuis $0 peut utiliser chacune des dépendances, 
# attention à la surcharge de noms de variables !

# Import des fonctions et variables de ces fichiers avec arrêt du script en cas d'erreur
for dependancy in ${IMPORTS[@]}; do
    echo -n "Importing ${BASEDIR}/lib/${dependancy}"
    source ${BASEDIR}/lib/${dependancy}
    status="$?"
    if [ $status -ne "0" ]; then
        echo -e "\e[91m ${BASEDIR}/lib/${dependancy} could not be sourced !
        Stopping $0. \e[0m"
        exit 1
    fi
    echo "... Status : [${status}]"
done

# Pour vérifier quelles fonctions sont accessibles : 
print_avalaible_functions() {
    print_title "Fonctions disponibles"
    VAR=()
    VAR+=$(declare -F)
    print "${VAR//'declare -f'/}"
    print_separator
}
######################################

title
main_menu
exit_ok
