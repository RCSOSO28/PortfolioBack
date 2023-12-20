package com.soso.project.repository;

import java.util.Collection;

import com.soso.project.domain.User;

public interface UserRepository<T extends User>{
    
    T create(T user);
    Collection<T> list(int page, int pageSize);
    T get(Long id);
    T update(T user);
    Boolean delete(Long id);
}
