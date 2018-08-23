/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "";
static const char *ng1 = "C:/Users/Guille/ARQ_TP1_ALU/main_tb.v";
static unsigned int ng2[] = {32U, 0U};
static unsigned int ng3[] = {144U, 0U};
static unsigned int ng4[] = {1U, 0U};
static unsigned int ng5[] = {39U, 0U};
static unsigned int ng6[] = {34U, 0U};
static unsigned int ng7[] = {36U, 0U};
static unsigned int ng8[] = {37U, 0U};
static unsigned int ng9[] = {38U, 0U};
static unsigned int ng10[] = {2U, 0U};
static unsigned int ng11[] = {3U, 0U};

void Monitor_44_1(char *);
void Monitor_44_1(char *);


static void Monitor_44_1_Func(char *t0)
{
    char t1[16];
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t2 = xsi_vlog_time(t1, 1000.0000000000000, 1000.0000000000000);
    t3 = (t0 + 1584);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t0 + 1184U);
    t7 = *((char **)t6);
    xsi_vlogfile_write(1, 0, 3, ng0, 4, t0, (char)118, t1, 64, (char)118, t5, 6, (char)118, t7, 8);

LAB1:    return;
}

static void Initial_43_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;

LAB0:    t1 = (t0 + 2824U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(43, ng1);

LAB4:    xsi_set_current_line(44, ng1);
    Monitor_44_1(t0);
    xsi_set_current_line(46, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 1584);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 6);
    xsi_set_current_line(47, ng1);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 1744);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(48, ng1);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 1904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(51, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(51, ng1);
    t3 = ((char*)((ng5)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(52, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(52, ng1);
    t3 = ((char*)((ng6)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(53, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(53, ng1);
    t3 = ((char*)((ng7)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(54, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB8;
    goto LAB1;

LAB8:    xsi_set_current_line(54, ng1);
    t3 = ((char*)((ng8)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(55, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB9;
    goto LAB1;

LAB9:    xsi_set_current_line(55, ng1);
    t3 = ((char*)((ng9)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(56, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB10:    xsi_set_current_line(56, ng1);
    t3 = ((char*)((ng10)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    xsi_set_current_line(57, ng1);
    t2 = (t0 + 2632);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB11:    xsi_set_current_line(57, ng1);
    t3 = ((char*)((ng11)));
    t4 = (t0 + 1584);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 6);
    goto LAB1;

}

void Monitor_44_1(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 2880);
    t2 = (t0 + 3392);
    xsi_vlogfile_monitor((void *)Monitor_44_1_Func, t1, t2);

LAB1:    return;
}


extern void work_m_00000000003488065847_0750423891_init()
{
	static char *pe[] = {(void *)Initial_43_0,(void *)Monitor_44_1};
	xsi_register_didat("work_m_00000000003488065847_0750423891", "isim/main_tb_isim_beh.exe.sim/work/m_00000000003488065847_0750423891.didat");
	xsi_register_executes(pe);
}
