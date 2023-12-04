void lwip_comm_default_ip_set(__lwip_dev *lwipx) {
  // ...
  lwipx->remoteip[0] = 192;
  lwipx->remoteip[1] = 168;
  lwipx->remoteip[2] = 1;
  lwipx->remoteip[3] = 130;
  // ...
}
