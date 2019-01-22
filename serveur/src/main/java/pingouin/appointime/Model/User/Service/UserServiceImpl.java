package pingouin.appointime.Model.User.Service;


import pingouin.appointime.Model.Repositories.RoleRepository;
import pingouin.appointime.Model.Repositories.UserRepository;
import pingouin.appointime.Model.User.Role;
import pingouin.appointime.Model.User.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;
/*
inspiré de https://github.com/hellokoding/registration-login-spring-hsql
Voir details dans le readme
*/
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    public void save(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        if (!roleRepository.existsByName("ROLE_USER")) {
            Role role = new Role();
            role.setName("ROLE_USER");
            roleRepository.save(role);
        }

        user.setRoles(new HashSet<>(roleRepository.findAll()));
        userRepository.save(user);
    }

    

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User findByEmailAndPassword(String email, String password) {
        return userRepository.findByEmailAndPassword(email, password);
    }

    
}
