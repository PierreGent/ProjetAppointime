package pingouin.appointime.Model.User.Service;

import pingouin.appointime.Model.User.User;


/*
inspiré de https://github.com/hellokoding/registration-login-spring-hsql
Voir details dans le readme
*/
public interface UserService {

    void save(User user);

    User findByEmail(String email);


    public User findByEmailAndPassword(String email, String password);

}
