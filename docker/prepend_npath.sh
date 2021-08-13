#!/bin/bash

set -e

cd /opt/app



# Find and replace code to add NETWORK_PATH
# NETWORK_PATH must not have / at the end
if [[ -z "$NETWORK_PATH" ]]; then
    echo "NETWORK_PATH env variable is not set. Will not prepend anything"
else
    echo "Prepending $NETWORK_PATH"

    # Prepend Network Path to @current_path in html templates
    find apps/block_scout_web/lib/block_scout_web/templates/ -name "*.html.eex" -type f -exec sed -i 's/%= @current_path %/%= "\'$NETWORK_PATH'" <> @current_path %/g' {} +

    # Preprend Network Path to new_path in checksum controller
    sed -i 's/to: new_path/to: "\'$NETWORK_PATH'" <> new_path/g' apps/block_scout_web/lib/block_scout_web/checksum_address.ex

    # Prepend Network Path to layout.js
    sed -i 's/window.location.href = `\/search?q=${value}`/window.location.href = "\'$NETWORK_PATH'" + `\/search?q=${value}`/g' apps/block_scout_web/assets/js/pages/layout.js
    
    # Prepend Network Path to autocomplete.js
    sed -i 's/`\/token-autocomplete?q=${query}`/`\'"$NETWORK_PATH"'\/token-autocomplete?q=${query}`/g' apps/block_scout_web/assets/js/lib/autocomplete.js
    sed -i 's/window.location = `\/tokens\/${selectionValue.contract_address_hash}`/window.location = "\'$NETWORK_PATH'" + `\/tokens\/${selectionValue.contract_address_hash}`/g' apps/block_scout_web/assets/js/lib/autocomplete.js 
    sed -i 's/window.location = `\/address\/${selectionValue.contract_address_hash}`/window.location = "\'$NETWORK_PATH'" + `\/address\/${selectionValue.contract_address_hash}`/g' apps/block_scout_web/assets/js/lib/autocomplete.js 

    # Prepend Network Path to footer
    sed -i 's/<a href="\/" rel="noreferrer" class="footer-link">/<a href="\'"$NETWORK_PATH"'\/" rel="noreferrer" class="footer-link">/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_footer.html.eex
    sed -i 's/<a href="\/blocks" rel="noreferrer" class="footer-link">/<a href="\'"$NETWORK_PATH"'\/blocks" rel="noreferrer" class="footer-link">/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_footer.html.eex
    sed -i 's/<a href="\/txs" rel="noreferrer" class="footer-link">/<a href="\'"$NETWORK_PATH"'\/txs" rel="noreferrer" class="footer-link">/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_footer.html.eex
    sed -i 's/<a href="\/accounts" rel="noreferrer" class="footer-link">/<a href="\'"$NETWORK_PATH"'\/accounts" rel="noreferrer" class="footer-link">/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_footer.html.eex
    sed -i 's/<a href="\/tokens" rel="noreferrer" class="footer-link">/<a href="\'"$NETWORK_PATH"'\/tokens" rel="noreferrer" class="footer-link">/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_footer.html.eex

    # Prepend Network Path to graphiql
    sed -i 's/to: api_url() <> "\/graphiql"/to: api_url() <> "\'$NETWORK_PATH'" <> "\/graphiql"/g' apps/block_scout_web/lib/block_scout_web/templates/layout/_topnav.html.eex
fi