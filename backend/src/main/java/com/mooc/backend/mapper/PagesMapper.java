package com.mooc.backend.mapper;

import com.mooc.backend.domain.Pages;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

/**
* @author peng
* @description 针对表【mooc_pages】的数据库操作Mapper
* @createDate 2023-03-06 08:21:10
* @Entity com.mooc.backend.domain.Pages
*/
@Mapper
public interface PagesMapper {

    int deleteByPrimaryKey(Long id);

    int insert(Pages record);

    int insertSelective(Pages record);

    @Select("SELECT * FROM mooc_pages WHERE id = #{id}")
    Pages selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Pages record);

    int updateByPrimaryKey(Pages record);

}
