package com.dwa.Ecovoit.Model.User.Service;

import com.dwa.Ecovoit.Model.User.User;
/*
inspiré de https://github.com/hellokoding/registration-login-spring-hsql
Voir details dans le readme
*/
public interface UserService {

    void save(User user);

    User findByEmail(String email);

    User findByUsername(String username);

    public User findByEmailAndPassword(String email, String password);

    public User findByUsernameAndPassword(String username, String password);
}
