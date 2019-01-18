package com.dwa.Ecovoit.Model.Repositories;

import com.dwa.Ecovoit.Model.User.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    public User findByUsername(String username);

    public User findByEmail(String email);

    public boolean existsByUsername(String username);

    public User findByEmailAndPassword(String email, String password);
    
    public User findByUsernameAndPassword(String username, String password);
}
