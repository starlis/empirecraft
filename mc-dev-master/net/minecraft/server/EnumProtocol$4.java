package net.minecraft.server;

enum EnumProtocol$4 {

   EnumProtocol$4(String var1, int var2, int var3) {
      this.b(0, PacketLoginOutDisconnect.class);
      this.b(1, PacketLoginOutEncryptionBegin.class);
      this.b(2, PacketLoginOutSuccess.class);
      this.a(0, PacketLoginInStart.class);
      this.a(1, PacketLoginInEncryptionBegin.class);
   }
}
