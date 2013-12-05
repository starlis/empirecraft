package net.minecraft.server;

enum EnumProtocol$3 {

   EnumProtocol$3(String var1, int var2, int var3) {
      this.a(0, PacketStatusInStart.class);
      this.b(0, PacketStatusOutServerInfo.class);
      this.a(1, PacketStatusInPing.class);
      this.b(1, PacketStatusOutPong.class);
   }
}
