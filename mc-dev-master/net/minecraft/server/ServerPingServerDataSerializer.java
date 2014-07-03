package net.minecraft.server;

import java.lang.reflect.Type;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class ServerPingServerDataSerializer implements JsonDeserializer, JsonSerializer {

    public ServerPingServerDataSerializer() {}

    public ServerPingServerData a(JsonElement jsonelement, Type type, JsonDeserializationContext jsondeserializationcontext) {
        JsonObject jsonobject = ChatDeserializer.l(jsonelement, "version");

        return new ServerPingServerData(ChatDeserializer.h(jsonobject, "name"), ChatDeserializer.m(jsonobject, "protocol"));
    }

    public JsonElement a(ServerPingServerData serverpingserverdata, Type type, JsonSerializationContext jsonserializationcontext) {
        JsonObject jsonobject = new JsonObject();

        jsonobject.addProperty("name", serverpingserverdata.a());
        jsonobject.addProperty("protocol", Integer.valueOf(serverpingserverdata.b()));
        return jsonobject;
    }

    public JsonElement serialize(Object object, Type type, JsonSerializationContext jsonserializationcontext) {
        return this.a((ServerPingServerData) object, type, jsonserializationcontext);
    }

    public Object deserialize(JsonElement jsonelement, Type type, JsonDeserializationContext jsondeserializationcontext) {
        return this.a(jsonelement, type, jsondeserializationcontext);
    }
}
