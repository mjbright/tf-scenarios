%{~ for idx, name in keys( vms ) }
${ idx }: ${ name } - ${ vm_infos[ name ] }
%{~ endfor }
