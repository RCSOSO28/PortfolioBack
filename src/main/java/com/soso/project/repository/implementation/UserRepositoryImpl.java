package com.soso.project.repository.implementation;

import java.util.Collection;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.soso.project.domain.User;
import com.soso.project.exception.APIException;
import com.soso.project.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import static java.util.Objects.requireNonNull;

@Repository
@RequiredArgsConstructor
@Slf4j
public class UserRepositoryImpl implements UserRepository<User>{
    
    private static final String BOOLEAN_USER_EMAIL_QUERY = null;
    private static final String INSERT_USER_QUERY = null;
    public final NamedParameterJdbcTemplate jdbc;

    @Override
    public User create(User user) {
        
        if (getBooleanEmail(user.getEmail()) == false) throw new APIException("Email already in use. Please use a different email and try again");
            KeyHolder holder = new GeneratedKeyHolder();
            SqlParameterSource parameters = getSqlParameterSource(user);
            jdbc.update(INSERT_USER_QUERY, parameters, holder);
            user.setId(requireNonNull(holder.getKey()).longValue());
            roleRepository.addRoleToUser(user.getId(), ROLE_USER.name());
        try {
            
        } catch (EmptyResultDataAccessException e) {

        } catch (Exception e)
    }

    private SqlParameterSource getSqlParameterSource(User user) {
        return null;
    }

    private boolean getBooleanEmail(String email) {
        return jdbc.queryForObject(BOOLEAN_USER_EMAIL_QUERY, Map.of("email", email), Boolean.class);
    }

    @Override
    public Collection<User> list(int page, int pageSize) {
        throw new UnsupportedOperationException("Unimplemented method 'list'");
    }

    @Override
    public User get(Long id) {
        throw new UnsupportedOperationException("Unimplemented method 'get'");
    }

    @Override
    public User update(User user) {
        throw new UnsupportedOperationException("Unimplemented method 'update'");
    }

    @Override
    public Boolean delete(Long id) {
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }

}
