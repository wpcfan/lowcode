package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PageEntityRepository extends JpaRepository<PageEntity, Long> {
}