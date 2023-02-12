package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.json.BlockDataDeserializer;

import java.io.Serializable;

@JsonDeserialize(using = BlockDataDeserializer.class)
public interface BlockData extends Serializable {

    Integer getSort();

    <T> T getData();
}
