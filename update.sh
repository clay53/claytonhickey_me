git_output=$(git pull)
no_update_str="Already up to date."

if [ "$git_output" != "$no_update_str" ]; then
	ocaml ./bin/main.ml
fi
