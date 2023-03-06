package com.mooc.backend.mapper;

import com.mooc.backend.domain.Page;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

/**
* @author peng
* @description 针对表【mooc_pages】的数据库操作Mapper
* @createDate 2023-03-06 08:21:10
* @Entity com.mooc.backend.domain.Pages
*/
@Mapper
public interface PageMapper {

    int deleteByPrimaryKey(Long id);

    @Insert(value = """
INSERT INTO mooc_pages (platform, page_type, config, title, status, created_at, updated_at) 
VALUES (#{platform}, #{pageType}, #{config}, #{title}, #{status}, now(), now())
""")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Page record);

    int insertSelective(Page record);

    @Select("SELECT * FROM mooc_pages WHERE id = #{id}")
    Page selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Page record);

    int updateByPrimaryKey(Page record);

}
