package com.mooc.backend.services;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.projections.PageEntityInfo;
import com.mooc.backend.repositories.PageEntityRepository;
import com.mooc.backend.specifications.PageFilter;
import com.mooc.backend.specifications.PageSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class PageQueryService {

    private final PageEntityRepository pageEntityRepository;

    public Optional<PageEntityInfo> findById(Long id) {
        return pageEntityRepository.findProjectionById(id);
    }

    public Page<PageEntity> findSpec(PageFilter filter, Pageable pageable) {
        // 函数的 apply 方法，会执行函数的 body
        var specification = PageSpecs.pageSpec.apply(filter);
        return pageEntityRepository.findAll(specification, pageable);
    }

    /**
     * 使用 JPA 返回的 Stream，必须在事务中执行，如果不加 @Transactional 注解，会报错
     * 
     * @param platform 平台
     * @param pageType 页面类型
     * @return 页面
     */
    @Transactional(readOnly = true)
    public Optional<PageEntity> findPublished(Platform platform, PageType pageType) {
        var now = LocalDateTime.now();
        try (var stream = pageEntityRepository.streamPublishedPage(now, platform, pageType)) {
            return stream.findFirst();
        }
    }
}
