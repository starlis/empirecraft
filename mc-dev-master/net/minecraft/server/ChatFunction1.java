package net.minecraft.server;

import java.util.Iterator;

import com.google.common.base.Function;

final class ChatFunction1 implements Function {

    ChatFunction1() {}

    public Iterator a(IChatBaseComponent ichatbasecomponent) {
        return ichatbasecomponent.iterator();
    }

    public Object apply(Object object) {
        return this.a((IChatBaseComponent) object);
    }
}
