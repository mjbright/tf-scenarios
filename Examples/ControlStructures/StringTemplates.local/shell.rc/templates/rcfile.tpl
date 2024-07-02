%{for key in keys(vars)}
export ${key}="${vars[key]}"
%{endfor}

