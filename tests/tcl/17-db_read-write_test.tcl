set tcl_dir [file dirname [file normalize [info script]]]
set tests_dir [file dirname $tcl_dir]
set data_dir [file join $tests_dir "data"]
set opendb_dir [file dirname $tests_dir]
source [file join $tcl_dir "test_helpers.tcl"]

set db [dbDatabase_create]
odb_read_lef $db [file join $data_dir "gscl45nm.lef"]
odb_read_def $db [file join $data_dir "design.def"]

set db_file [file join $opendb_dir "build" "export.db"]
set write_result [odb_write_db $db $db_file]
if {!$write_result} {
    puts "Write DB failed"
    exit 1
}

set new_db [dbDatabase_create]
odb_read_db $new_db $db_file

if { [db_diff $db $new_db] } {
  puts "Differences found between exported and imported db"
  exit 1
}

exit 0
