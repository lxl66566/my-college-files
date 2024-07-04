movie = fopen(
    "/fd/project_soc/TP/TPQ/Sw/mjpeg_seq/images/ice _age_256x144_444.mjpeg",
    " r"); // 在fetch.h中修改路径

volatile unsigned long int *timer = (unsigned long int *)0xC2000000;
// 在dispath.c中修改基地址与timer和framebuffer模块一致
memcpy((void *)0xC4000000, picture, SOF_section.width *SOF _section.height * 2);

data : ORIGIN = 0x20000000,
       LENGTH = 0x01000000 // 修改mips中基地址与data基地址一致
                    .semram 0xc1000000 : {} // 修改mips中基地址与locks基地址一致

PLATFORM CLOCK BASE =.;
// 修改硬件抽象层基地址
LONG(0xC2000000)
__SBRIDGEFS DEVICES =.;
LONG(0xc3000000)
