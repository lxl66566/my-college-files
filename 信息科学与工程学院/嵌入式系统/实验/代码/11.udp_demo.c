void draw(u16 center, u16 length) {
  // 根据中心点与边长绘制矩形
  u16 temp = length >> 1;
  LCD_DrawRectangle(center - temp, center - temp, center + temp, center + temp);
}
u16 stoi(const u8 *s) {
  // 字符串转整数
  u16 temp = 0;
  for (u8 i = 0; s[i] != '\0'; ++i) {
    temp += s[i] - '0';
    temp *= 10;
  }
  return temp;
}
// UDP测试
void udp_demo_test(void) {
  // ... 省略了创建 UDP 客户端的代码
  while (res == 0) {
    key = KEY_Scan(0);
    if (key == WKUP_PRES)
      break;
    if (key == KEY0_PRES) // KEY0按下了,发送数据
    {
      udp_demo_senddata(udppcb);
    }
    if (udp_demo_flag & 1 << 6) // 是否收到数据?
    {
      LCD_Clear(99999);                  // 清屏
      draw(230, stoi(udp_demo_recvbuf)); // 根据收到的数据画不同边长的矩形
      udp_demo_flag &= ~(1 << 6); // 标记数据已经被处理了.
    }
    lwip_periodic_handle();
    delay_ms(2);
  }
  udp_demo_connection_close(udppcb);
  myfree(SRAMIN, tbuf);
}
