::cisco::eem::event_register_none
#
# *********
# This script no shut all the listed interaces
# *********
#
# errorInfo gets set by namespace if any of the auto_path directories do not
# contain a valid tclIndex file.  It is not an error just left over stuff.
# So we set the errorInfo value to null so that we don't have left
# over errors in it.
#
set errorInfo ""


namespace import ::cisco::eem::*
namespace import ::cisco::lib::*

#
# errorInf gets set by namespace if any of the auto_path directories do not
# contain a valid tclIndex file.  It is not an error just left over stuff.
# So we set the errorInfo value to null so that we don't have left
# over errors in it.
#
set errorInfo ""
#Notify users that we're collecting
set output_msg "EEM noshut.tcl kicks in"
action_syslog priority info msg $output_msg

#query the event info
#array set arr_einfo [event_reqinfo]

set intf_list {
  Te0/1/0/0
  Te0/1/0/1
	Te0/2/0/0
	Te0/2/0/1
	Te0/2/0/2
}

if {$_cerrno != 0} {
    set result [format "component=%s; subsys err=%s; posix err=%s;\n%s" \
        $_cerr_sub_num $_cerr_sub_err $_cerr_posix_err $_cerr_str]
    error $result
}

#Extract the message from the event info and append it to the email body
#set syslog_msg $arr_einfo(msg)


#open a cli connection

if [catch {cli_open} result] {
    error $result $errorInfo
} else {
    array set cli1 $result
}


set location ""

# if {[regexp {.* (.*0/.*/.*/[0-9]*).*} $syslog_msg match location]} {
#if [catch {cli_exec $cli1(fd) "int $location"} result] {
#error $result $errorInfo
#}

#if [catch {cli_exec $cli1(fd) "interface loopback0"} result] {
#error $result $errorInfo
#}
#if [catch {cli_exec $cli1(fd) "shut"} result] {
#error $result $errorInfo
#}
#if [catch {cli_exec $cli1(fd) "commit"} result] {
#error $result $errorInfo
#}



#set output_msg "Sleeping for 180s..."
#after 180000
#set output_msg "admin shutdown card 0/1 now by EEM..."
action_syslog priority info msg $output_msg

#if [catch {cli_write $cli1(fd) "admin hw-module location 0/1 shutdown"} result] {
#error $result $errorInfo
#}
#cli_read_pattern $cli1(fd) "Take hardware module offline"
#cli_read_pattern $cli1(fd) "Shutdown hardware module"
#cli_write $cli1(fd) "yes"
#cli_write $cli1(fd) "\r"




set output_msg "delay 5s in EEM noshut.tcl ..."
action_syslog priority info msg $output_msg
after 5000

set output_msg "Now EEM noshut.tcl no shutdown all specified interfaces ..."
action_syslog priority info msg $output_msg

if [catch {cli_exec $cli1(fd) "conf t"} result] {
error $result $errorInfo
}

foreach intf $intf_list {

   if [catch {cli_exec $cli1(fd) "interface ${intf}" } result] {
   error $result $errorInfo
   }
   if [catch {cli_exec $cli1(fd) "no shut"} result] {
   error $result $errorInfo
   }


}



if [catch {cli_exec $cli1(fd) "commit"} result] {
error $result $errorInfo
}





#close the cli connection
if [catch {cli_close $cli1(fd) $cli1(tty_id)} result] {
    error $result $errorInfo
}
action_syslog priority emergencies msg "End of EEM noshut.tcl execution "
action_syslog priority info msg $output_msg


