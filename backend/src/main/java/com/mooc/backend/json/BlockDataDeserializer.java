package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.ProductAdminDTO;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.entities.blocks.ImageDTO;

import java.io.IOException;

public class BlockDataDeserializer extends JsonDeserializer<BlockData> {
    @Override
    public BlockData deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        ObjectMapper mapper = (ObjectMapper) p.getCodec();
        ObjectNode root = mapper.readTree(p);
        if (root.has("price")) {
            return mapper.treeToValue(root, ProductAdminDTO.class);
        }
        if (root.has("image")) {
            return mapper.treeToValue(root, ImageDTO.class);
        }
        if (root.has("code")) {
            return mapper.treeToValue(root, CategoryDTO.class);
        }
        return null;
    }
}
