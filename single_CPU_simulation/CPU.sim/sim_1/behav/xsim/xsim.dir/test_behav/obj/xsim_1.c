/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_3097(char*, char *);
extern void execute_3098(char*, char *);
extern void execute_9383(char*, char *);
extern void execute_9384(char*, char *);
extern void execute_3095(char*, char *);
extern void execute_3096(char*, char *);
extern void execute_9362(char*, char *);
extern void execute_9364(char*, char *);
extern void execute_9365(char*, char *);
extern void execute_9366(char*, char *);
extern void execute_9367(char*, char *);
extern void execute_9368(char*, char *);
extern void execute_9369(char*, char *);
extern void execute_9370(char*, char *);
extern void execute_9371(char*, char *);
extern void execute_9372(char*, char *);
extern void execute_9373(char*, char *);
extern void execute_9374(char*, char *);
extern void execute_9375(char*, char *);
extern void execute_9376(char*, char *);
extern void execute_9377(char*, char *);
extern void execute_9378(char*, char *);
extern void execute_9379(char*, char *);
extern void execute_9380(char*, char *);
extern void execute_9381(char*, char *);
extern void execute_9382(char*, char *);
extern void execute_4(char*, char *);
extern void execute_3103(char*, char *);
extern void execute_3104(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_3105(char*, char *);
extern void execute_3106(char*, char *);
extern void execute_3107(char*, char *);
extern void execute_3108(char*, char *);
extern void execute_3109(char*, char *);
extern void execute_3110(char*, char *);
extern void execute_3111(char*, char *);
extern void execute_3112(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_19(char*, char *);
extern void execute_20(char*, char *);
extern void execute_21(char*, char *);
extern void execute_3170(char*, char *);
extern void execute_9127(char*, char *);
extern void execute_26(char*, char *);
extern void execute_9123(char*, char *);
extern void execute_9124(char*, char *);
extern void execute_3171(char*, char *);
extern void execute_3176(char*, char *);
extern void execute_3172(char*, char *);
extern void execute_3173(char*, char *);
extern void execute_9125(char*, char *);
extern void execute_9128(char*, char *);
extern void execute_9129(char*, char *);
extern void execute_9130(char*, char *);
extern void execute_9263(char*, char *);
extern void execute_9264(char*, char *);
extern void execute_9265(char*, char *);
extern void execute_9266(char*, char *);
extern void execute_9288(char*, char *);
extern void execute_9290(char*, char *);
extern void execute_9291(char*, char *);
extern void execute_9267(char*, char *);
extern void execute_9268(char*, char *);
extern void execute_9271(char*, char *);
extern void execute_9272(char*, char *);
extern void execute_9275(char*, char *);
extern void execute_9276(char*, char *);
extern void execute_9279(char*, char *);
extern void execute_9280(char*, char *);
extern void execute_9283(char*, char *);
extern void execute_9284(char*, char *);
extern void execute_9287(char*, char *);
extern void execute_9289(char*, char *);
extern void execute_3076(char*, char *);
extern void execute_3077(char*, char *);
extern void execute_9292(char*, char *);
extern void execute_9293(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_9360(char*, char *);
extern void execute_3100(char*, char *);
extern void execute_3101(char*, char *);
extern void execute_3102(char*, char *);
extern void execute_9385(char*, char *);
extern void execute_9386(char*, char *);
extern void execute_9387(char*, char *);
extern void execute_9388(char*, char *);
extern void execute_9389(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[90] = {(funcp)execute_3097, (funcp)execute_3098, (funcp)execute_9383, (funcp)execute_9384, (funcp)execute_3095, (funcp)execute_3096, (funcp)execute_9362, (funcp)execute_9364, (funcp)execute_9365, (funcp)execute_9366, (funcp)execute_9367, (funcp)execute_9368, (funcp)execute_9369, (funcp)execute_9370, (funcp)execute_9371, (funcp)execute_9372, (funcp)execute_9373, (funcp)execute_9374, (funcp)execute_9375, (funcp)execute_9376, (funcp)execute_9377, (funcp)execute_9378, (funcp)execute_9379, (funcp)execute_9380, (funcp)execute_9381, (funcp)execute_9382, (funcp)execute_4, (funcp)execute_3103, (funcp)execute_3104, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_3105, (funcp)execute_3106, (funcp)execute_3107, (funcp)execute_3108, (funcp)execute_3109, (funcp)execute_3110, (funcp)execute_3111, (funcp)execute_3112, (funcp)execute_16, (funcp)execute_17, (funcp)execute_19, (funcp)execute_20, (funcp)execute_21, (funcp)execute_3170, (funcp)execute_9127, (funcp)execute_26, (funcp)execute_9123, (funcp)execute_9124, (funcp)execute_3171, (funcp)execute_3176, (funcp)execute_3172, (funcp)execute_3173, (funcp)execute_9125, (funcp)execute_9128, (funcp)execute_9129, (funcp)execute_9130, (funcp)execute_9263, (funcp)execute_9264, (funcp)execute_9265, (funcp)execute_9266, (funcp)execute_9288, (funcp)execute_9290, (funcp)execute_9291, (funcp)execute_9267, (funcp)execute_9268, (funcp)execute_9271, (funcp)execute_9272, (funcp)execute_9275, (funcp)execute_9276, (funcp)execute_9279, (funcp)execute_9280, (funcp)execute_9283, (funcp)execute_9284, (funcp)execute_9287, (funcp)execute_9289, (funcp)execute_3076, (funcp)execute_3077, (funcp)execute_9292, (funcp)execute_9293, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_9360, (funcp)execute_3100, (funcp)execute_3101, (funcp)execute_3102, (funcp)execute_9385, (funcp)execute_9386, (funcp)execute_9387, (funcp)execute_9388, (funcp)execute_9389, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 90;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/test_behav/xsim.reloc",  (void **)funcTab, 90);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/test_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/test_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/test_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/test_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/test_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
