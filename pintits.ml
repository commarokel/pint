
open PintTypes
open AutomataNetwork
open An_export

let usage_msg = "pint-its [opts] <local state> -- [its opts] # symbolic model-checking with ITS tools [http://ddd.lip6.fr/itstools.php]"

let tools = ["reach";"ctl"]
and opt_tool = ref "reach"
and opt_witness = ref false
and opt_extra = ref []
and opt_verbose = ref false

let cmdopts = An_cli.common_cmdopts @ An_cli.input_cmdopts @ [
	("--tool", Arg.Symbol (tools, (fun t -> opt_tool := t)),
		"\tITS tool (default: reach)");
	("--witness", Arg.Set opt_witness,
		"\tEnable witness computation (used by: reach)");
	("--verbose", Arg.Set opt_verbose,
		"\tDrop --quiet option");
	("--", Arg.Rest (fun arg -> opt_extra := !opt_extra @ [arg]),
		"Extra options for the ITS tool");
]

let args, abort = An_cli.parse cmdopts usage_msg

let an, ctx = An_cli.process_input ()

let goal = match args with
	  [str_ls] -> An_cli.parse_local_state an str_ls
	| _ -> abort ()

let map = Hashtbl.create 50

let data = romeo_of_an ~map:(Some map) an ctx

let itsfile, itsfile_out = Filename.open_temp_file "pint" ".xml"
let _ = output_string itsfile_out data;
		close_out itsfile_out

let place_of_ls ls =
	let (label, idx) = Hashtbl.find map ls
	in
	"P_"^(string_of_int idx)^label

let do_reach () =
	let cmdline = "its-reach -i "^itsfile^" -t ROMEO"
		^" -reachable \""^(place_of_ls goal)^"=1\""
		^(if !opt_verbose then "" else " --quiet")
		^(if !opt_witness then "" else " --nowitness")
		^" "^String.concat " " !opt_extra
	in
	prerr_endline ("# "^cmdline);
	ignore(Unix.system cmdline)

let do_ctl () =
	let itsctl, itsctl_out = Filename.open_temp_file "pint" ".ctl"
	in
	output_string itsctl_out ("EF ("^place_of_ls goal^"=1);\n");
	close_out itsctl_out;
	let cmdline = "its-ctl -i "^itsfile^" -ctl "^itsctl
		^(if !opt_verbose then "" else " --quiet")
		^" "^String.concat " " !opt_extra
	in
	prerr_endline ("# "^cmdline);
	ignore(Unix.system cmdline);
	Unix.unlink itsctl

let _ = at_exit (fun () -> Unix.unlink itsfile)

let _ = if !opt_tool = "reach" then do_reach ()
		else if !opt_tool = "ctl" then do_ctl ()

