#include "vci_fd_access.h"
#include "vci_framebuffer.h"
#include "vci_locks.h" //添加头文件
#include "vci_timer.h"

#define FBUFFER WIDTH 256 // 宏定义
#define FBUFFER HEIGHT 144

maptab.add(Segment("reset", RESET_BASE, RESET_SIZE, IntTab(1), true));
maptab.add(Segment("excep", EXCEP_BASE, EXCEP_SIZE, IntTab(1), true));
maptab.add(Segment("text", TEXT_BASE, TEXT_SIZE, IntTab(1), true));
maptab.add(Segment("data", DATA_BASE, DATA_SIZE, IntTab(1), true));
maptab.add(Segment("semlocks_seg", SEMLOCKS_BASE, SEMLOCKS_SIZE, IntTab(3),
                   false));
maptab.add(Segment("timer", TIMER BASE, TIMER SIZE, IntTab(4), false));
maptab.add(Segment("fd_access", FD_ACCESS BASE, FD ACCESs_SIZE, IntTab(5),
                   false));
maptab.add(Segment("frame buffer", FBUFFER BASE, FBUFFERl SIZE, IntTab(6),
                   false));
// 修改互连结构参数
soclib::caba::VciVgmn<vci_param> vgmn("vgmn", maptab, 3, 7, 2, 8);
// 添加设备模块
soclib::caba::VciLocks<vci_param> semlocks("semlocks", IntTab(3), maptab)
    soclib::caba::VciTimer<vci_param> timer("timer", IntTab(4), maptab, 1);
soclib::caba::VciFdAccess<vci_param> fd_access("fdaccess", maptab, IntTab(2),
                                               IntTab(5));
soclib::caba::VciFrameBuffer<vci_param> fbuffer("fbuffer", IntTab(6), maptab,
                                                FBUFFER MIDTH, FBUFFER HEITOHr);

soclib::caba::VciSignals<vci_param> signal_vci_semlocks("signal_vci_semlocks");
soclib::caba::VciSignals<vci_param>
    signal_vci_timer("signal_vci_timer"); // 添加相关singals
sc_signal<bool> signal_timer_it("signal_timer_it");
soclib::caba::VciSignals<vci_param>
    signal_vci_fd_access("signal_vci_fd_ access");
soclib::caba::VciSignals<vci_param>
    signal_vci_inv_fd_access("signal_vci_inv_fd_access");
sc signal<bool> signal_fd _access_it("signal_fd_access_it");
soclib::caba::VciSignals<vci_param> signal_vci_fbuffer("signal_vci_fbuffer");

vgmn.p_to_initiator[2](signal_vci_inv_fd_access); // 添加总线
vgmn.p_to_target[3](signal_vci_semlocks);
vgmn.p_to_target[4](signal_vci_timer);
vgmn.p_to_target[5](signal_vci_fd_access);
vgmn.p_to_target[6](signal_vci_fbuffer);

semlocks.p_clk(signal_clk);
semlocks.p_resetn(signal_resetn);
semlocks.p_vci(signal_vci_semlocks);
timer.p_clk(signal_clk);
timer.p_resetn(signal_resetn);
timer.p_vci(signal_vci_timer);
timer.p_irq[0](signal_timer_it);
fd_access.p_clk(signal_clk);
fd_access.p_resetn(signal_resetn);
fd_access.p_vci_target(signal_vci_fd_access);
fd_access.p_vci initiator(signal_vci_inv_fd_access);
fd_access.p_irq(signal_fd_access_it);
fbuffer.p_clk(signal_clk);
fbuffer.p_resetn(signal_resetn);
fbuffer.p_vci(signal_vci_fbuffer);

#define SEMLOCKS BASE 0xc1000000 // 在segmentation.h中添加设备模块的寻址地址
#define SEMLOCKS SIZE 0x00000400
#define TIMER BASE 0xC2000000
#define TIMER SIZE 0x00000100
#define FD ACCESS BASE 0xC3000000
#define FD ACCESS SIZE 0x00001000
#define FBUFFER BASE 0xC4000000
#define FBUFFER SIZE 0x01000000

// 在platform_desc中注册添加的设备模块
Uses('vci_timer'), Uses('vci_fd access'), Uses('vci_framebuffer'),
    Uses('vci_locks'),
