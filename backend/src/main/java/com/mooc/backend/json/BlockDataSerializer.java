package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.entities.blocks.ImageData;
import com.mooc.backend.entities.blocks.ProductData;

import java.io.IOException;

public class BlockDataSerializer extends JsonSerializer<BlockData> {
    @Override
    public void serialize(BlockData value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        if (value instanceof ImageData imageData) {
            gen.writeObject(imageData);
        }
        if (value instanceof ProductData productData) {
            gen.writeObject(productData);
        }
    }
}
