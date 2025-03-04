
Container Report
================

A total of ${ length( keys(cs) ) } containers were created.

%{~ for name in keys(cs) ~}

- Container "${ name }"
Exposing internal port 80 on host addresses on port ${ cs[ name ][1] + ext_base }
Using image number ${ cs[ name ][0] } => "${ images[ cs[ name ][0] ].name }"

%{~ endfor ~}

