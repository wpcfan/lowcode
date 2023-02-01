package com.mooc.backend.repositories;

import com.mooc.backend.dtos.CategoryRecord;
import com.mooc.backend.entities.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long>, JpaSpecificationExecutor<Category> {
    Optional<Category> findByCode(String code);

    @Query("SELECT c FROM Category c LEFT JOIN FETCH c.children WHERE c.parent is null")
    List<Category> findRoots();

    @Query("SELECT c FROM Category c LEFT JOIN FETCH c.children WHERE c.id = :id")
    Optional<Category> findByIdWithChildren(@Param("id") Long id);

    @Query("SELECT c FROM Category c LEFT JOIN FETCH c.children")
    List<Category> findAllWithChildren();

    @Query("SELECT new com.mooc.backend.dtos.CategoryRecord(c.id, c.name, c.code, c.parent.id) FROM Category c")
    List<CategoryRecord> findAllCategoryPlainDTOs();

    @Query("SELECT c FROM Category c LEFT JOIN FETCH c.children")
    <T> List<T> findAll(Class<T> type);
}