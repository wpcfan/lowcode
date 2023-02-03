package com.mooc.backend.services;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.repositories.PageEntityRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageEntityRepository pageEntityRepository;


}
