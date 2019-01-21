package com.GL.Appointime.Model.User.Service;

import com.GL.Appointime.Model.User.User;


/*
inspiré de https://github.com/hellokoding/registration-login-spring-hsql
Voir details dans le readme
*/
public interface SecurityService {

    public String findLoggedInUsername();

    public void autologin(String username, String password);

    public User findLoggedInUser();
}
