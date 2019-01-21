package com.GL.Appointime.Model.Repositories;

import com.GL.Appointime.Model.User.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {

    public boolean existsByName(String name);

    public Role findByName(String name);
}
