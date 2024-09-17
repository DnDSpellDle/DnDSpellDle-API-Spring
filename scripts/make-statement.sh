#!/bin/bash

# On se déplace dans le répertoire contenant les sujets.
cd tp

# S'il n'y a pas de paramètres, on compile tous les sujets.
if [ $# -eq 0 ]
then
    set -- TP*/
fi

# On compile maintenant tous les sujets demandés.
for sujet in "$@"
do
    (
        cd "$sujet"
        pandoc --template "../../templates/statement/statement.pandoc" \
               --lua-filter "../../templates/statement/blocks.lua" \
               --lua-filter "../../templates/statement/gitlab-math.lua" \
               "../metadata.md" "index.md" \
               --output "../$(basename "$sujet").pdf"
    )
done
