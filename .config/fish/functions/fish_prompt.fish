function fish_prompt --description 'Write out the prompt'
	if test -z $WINDOW
        printf '%s%s%s@%s%s%s %s%s: %s' (set_color ef5959 --bold) (whoami) (set_color brgreen) (set_color brblue) (prompt_hostname) (set_color 8659ef) (prompt_pwd) (set_color normal)
    else
        printf '%s%s%s@%s%s%s(%s)%s %s:%s ' (set_color bryellow --bold) (whoami) (set_color brgreen) (set_color brblue) (prompt_hostname) (set_color brwhite) (echo $WINDOW) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    end
end
