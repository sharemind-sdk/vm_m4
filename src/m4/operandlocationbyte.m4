m4_include([forloop.m4])

m4_define([_OLBS_EXPAND],[$1])

m4_define([OLB_COUNT],0)
m4_define([OLB], [m4_defn(m4_format([[OLB_%s]], [$1]))])
m4_define([OLB_DEFINE], [m4_define(m4_format([[OLB_%s]], [$1]), [$1, $2, $3])
                         m4_define(m4_format([[OLB_NAME_%s]], [$1]), [$1])
                         m4_define(m4_format([[OLB_CODE_%s]], [$1]), [$2])
                         m4_define(m4_format([[OLB_ARGS_%s]], [$1]), [$3])
                         m4_define([OLB_COUNT],m4_incr(OLB_COUNT))
                         m4_define([OLB_]OLB_COUNT,[$1])])

#m4_define([OLBS],[forloop([i], 1, OLB_COUNT, [(OLB(OLB(i)))])])
m4_define([OLBS_FOREACH],[forloop([i], 1, OLB_COUNT, [m4_indir([$1],_OLBS_EXPAND(OLB(OLB(i))))])])

m4_define([OLB_GET_NAME], OLB_NAME_$1)
m4_define([OLB_GET_CODE], OLB_CODE_$1)
m4_define([OLB_GET_ARGS], OLB_ARGS_$1)

OLB_DEFINE(imm,     0x01, 1)
OLB_DEFINE(reg,     0x02, 1)
OLB_DEFINE(stack,   0x03, 1)
OLB_DEFINE(mem_rr,  0x10, 2)
OLB_DEFINE(mem_rs,  0x11, 2)
OLB_DEFINE(mem_ri,  0x12, 2)
OLB_DEFINE(mem_sr,  0x13, 2)
OLB_DEFINE(mem_ss,  0x14, 2)
OLB_DEFINE(mem_si,  0x15, 2)
OLB_DEFINE(cref_rr, 0x20, 2)
OLB_DEFINE(cref_rs, 0x21, 2)
OLB_DEFINE(cref_ri, 0x22, 2)
OLB_DEFINE(cref_sr, 0x23, 2)
OLB_DEFINE(cref_ss, 0x24, 2)
OLB_DEFINE(cref_si, 0x25, 2)
OLB_DEFINE(cref_ii, 0x26, 2)
OLB_DEFINE(ref_rr,  0x30, 2)
OLB_DEFINE(ref_rs,  0x31, 2)
OLB_DEFINE(ref_ri,  0x32, 2)
OLB_DEFINE(ref_sr,  0x33, 2)
OLB_DEFINE(ref_ss,  0x34, 2)
OLB_DEFINE(ref_si,  0x35, 2)
OLB_DEFINE(ref_ii,  0x36, 2)
