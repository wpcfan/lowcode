package com.mooc.backend.json;

import com.fasterxml.jackson.core.JacksonException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mooc.backend.entities.blocks.*;

import java.io.IOException;

public class PageBlockDeserializer extends JsonDeserializer<PageBlock> {
    @Override
    public PageBlock deserialize(JsonParser p, DeserializationContext ctxt) throws IOException, JacksonException {
        ObjectMapper mapper = (ObjectMapper) p.getCodec();
        ObjectNode root = mapper.readTree(p);
        if (root.has("type")) {
            String type = root.get("type").asText();
            switch (type) {
                case "pinned_header" -> {
                    return mapper.treeToValue(root, PinnedHeaderPageBlock.class);
                }
                case "image_row" -> {
                    return mapper.treeToValue(root, ImageRowPageBlock.class);
                }
                case "product_row" -> {
                    return mapper.treeToValue(root, ProductRowPageBlock.class);
                }
                case "slider" -> {
                    return mapper.treeToValue(root, SliderPageBlock.class);
                }
                case "waterfall" -> {
                    return mapper.treeToValue(root, WaterfallPageBlock.class);
                }
                default -> {
                }
            }
        }
        return null;
    }
}
