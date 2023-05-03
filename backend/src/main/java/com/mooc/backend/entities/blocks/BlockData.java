package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.enumerations.BlockDataType;
import com.mooc.backend.json.BlockDataDeserializer;
import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;

@Schema(name = "BlockData", description = "区块数据", subTypes = {ImageDTO.class, CategoryDTO.class, ProductDataDTO.class})
@JsonDeserialize(using = BlockDataDeserializer.class)
public interface BlockData extends Serializable {
    BlockDataType getDataType();
}
