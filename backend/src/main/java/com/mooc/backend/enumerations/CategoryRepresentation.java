package com.mooc.backend.enumerations;

public enum CategoryRepresentation {
    /**
     * 所有类目平铺，不含子类目嵌套，但有父类目Id
     */
    BASIC("basic"),
    /**
     * 所有类目都返回，且每个类目嵌套子类目信息，注意：子类目同时也在平铺的列表中
     */
    WITH_CHILDREN("with_children"),
    /**
     * 只返回根节点列表，但每个节点都嵌套子类目信息
     */
    ROOT_ONLY("root_only"),
    ;

    private final String value;

    CategoryRepresentation(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
