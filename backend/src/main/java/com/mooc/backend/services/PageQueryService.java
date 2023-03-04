package com.mooc.backend.services;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageEntityRepository;
import com.mooc.backend.specifications.PageFilter;
import com.mooc.backend.specifications.PageSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
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

    @Cacheable(cacheNames = "pageCache", key = "{#id}")
    public PageEntity findById(Long id) {
        return pageEntityRepository.findById(id).orElseThrow(() -> new CustomException("页面不存在", "PageQueryService#findById", 404));
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

    public boolean existsByTitle(String title) {
        return pageEntityRepository.countByTitle(title) > 0L;
    }
}
