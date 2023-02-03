package com.mooc.backend.json;

import com.fasterxml.jackson.core.JacksonException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.entities.blocks.ImageData;
import com.mooc.backend.entities.blocks.ProductData;

import java.io.IOException;

public class BlockDataDeserializer extends JsonDeserializer<BlockData> {
    @Override
    public BlockData deserialize(JsonParser p, DeserializationContext ctxt) throws IOException, JacksonException {
        ObjectMapper mapper = (ObjectMapper) p.getCodec();
        ObjectNode root = mapper.readTree(p);
        if (root.has("product")) {
            return mapper.treeToValue(root, ProductData.class);
        }
        if (root.has("image")) {
            return mapper.treeToValue(root, ImageData.class);
        }
        return null;
    }
}
