package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.projections.PageEntityInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface PageEntityRepository extends JpaRepository<PageEntity, Long> {

    @Query("select p from PageEntity p left join fetch p.pageBlocks pb left join fetch pb.data where p.id = ?1")
    Optional<PageEntityInfo> findProjectionById(Long id);
}