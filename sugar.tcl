package provide sugar 0.4
package require Tcl 8.6
package require http

proc throwError {action\
{env cmdline}\
{msg "Error while $action."}\
{details $::errorInfo}} {
	if {$env eq "tk"} {
		tk_messageBox\
			-icon error\
			-type ok\
			-title "$action"\
			-message "$msg"\
			-detail "$details"
	} else {puts stderr "$msg\n$details"}
}

proc getHttp {url} {return [http::data [http::geturl $url]]}
	
proc head {lst} {return [lindex $lst 0]}
proc tail {lst} {return [lrange $lst 1 end]}
proc last {lst} {return [lindex $lst end]}

proc . {args} {
	# if first argument is a tcl file, set directory as relative to the calling script,
	# otherwise source files in specified directory
	if {[string match {*.tcl} [head $args]]} {
		set dirname [file dirname [info script]]
	} else {
		set dirname [head $args]
		set args [tail $args]
	}
	foreach filename $args {
		try {
			source [file join $dirname $filename]
		} trap {POSIX ENOENT} {} {
			puts "Error: $filename: No such file or directory"
		}
	}
}

proc readFile {path} {
	set token [open "$path" r]
	set file_data {read $token}
	close $token
	return $file_data
}
