m4_include([forloop.m4])

m4_define([_DTBS_EXPAND],[$1])

m4_define([DTB_COUNT],0)
m4_define([DTB], [m4_defn(m4_format([[DTB_%s]], [$1]))])
m4_define([DTB_DEFINE], [m4_define(m4_format([[DTB_%s]], [$1]), [$1, $2, $3])
                         m4_define(m4_format([[DTB_NAME_%s]], [$1]), [$1])
                         m4_define(m4_format([[DTB_CODE_%s]], [$1]), [$2])
                         m4_define(m4_format([[DTB_TYPE_%s]], [$1]), [$3])
                         m4_define([DTB_COUNT],m4_incr(DTB_COUNT))
                         m4_define([DTB_]DTB_COUNT,[$1])])

m4_define([DTBS],[forloop([i], 1, DTB_COUNT, [(DTB(DTB(i)))])])
m4_define([DTBS_FOREACH],[forloop([i], 1, DTB_COUNT, [m4_indir([$1],_DTBS_EXPAND(DTB(DTB(i))))])])

m4_define([DTB_GET_NAME], DTB_NAME_$1)
m4_define([DTB_GET_CODE], DTB_CODE_$1)
m4_define([DTB_GET_TYPE], DTB_TYPE_$1)


# (name, code, type)
DTB_DEFINE(uint8,   0x01, uint8_t)
DTB_DEFINE(uint16,  0x02, uint16_t)
DTB_DEFINE(uint32,  0x03, uint32_t)
DTB_DEFINE(uint64,  0x04, uint64_t)
DTB_DEFINE(int8,    0x11, int8_t)
DTB_DEFINE(int16,   0x12, int16_t)
DTB_DEFINE(int32,   0x13, int32_t)
DTB_DEFINE(int64,   0x14, int64_t)
DTB_DEFINE(float32, 0x23, float)
