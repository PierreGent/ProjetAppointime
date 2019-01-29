/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pingouin.appointime.Controller.User;


import javax.servlet.http.HttpServletRequest;
import pingouin.appointime.Model.User.Service.SecurityService;
import pingouin.appointime.Model.User.Service.UserService;
import pingouin.appointime.Model.User.User;
import javax.validation.Valid;
import static org.hibernate.annotations.common.util.impl.LoggerFactory.logger;
import static org.hibernate.internal.CoreLogging.logger;
import static org.hibernate.internal.HEMLogging.logger;
import static org.hibernate.internal.HEMLogging.logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author gentile
 */
@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

   

    /**
     * loginCheck called with /loginCheck request Used to check connexion
     *
     * @param user : user to log
     * @return Home page if success, login if not
     */
    @PostMapping("/login")
    ResponseEntity<User> loginCheck(@RequestParam("email") String email,
     @RequestParam("password") String password) {
        System.out.println("tyuezrhh");
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        User userToLog = userService.findByEmail(email);
        String error="";
        if (userToLog == null) {
           error=error+"Email incorrect";
        } else if (!passwordEncoder.matches(password, userToLog.getPassword())) {
            error=error+"password incorrect";

        }

        if (!error.equals("")) {

           return new ResponseEntity<User>(userToLog, HttpStatus.CONFLICT);
        }
        securityService.autologin(userToLog.getEmail(), userToLog.getPassword());
       return new ResponseEntity<User>(userToLog, HttpStatus.OK);
    }


    /**
     * logout called with /logout request Used to logout
     *
     * @return logout template
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(Model model) {
        return "logout";
    }

    /**
     * SubmitRegistration called with /registration with post request Used to
     * confirm registration (bindig and checking user to register)
     *
     * @param user: user to register
     * @return home page if success, registration if not
     */
    @RequestMapping(value = "/registration", method = RequestMethod.PUT)
    ResponseEntity<User> SubmitRegistration(@Valid User user,  Model mod) {
        System.out.println("snfkkzenfkkzlen");
        String error="";
        if (userService.findByEmail(user.getEmail()) != null) {

            error=error+"Email déjà utilisé";

        }
        if (userService.findByEmail(user.getEmail()) != null) {

            error=error+"Pseudo déjà utilisé";

        }

        if (!user.getPassword().equals(user.getPasswordConfirm())) {
            error=error+"Les mot de passe sont différents";
        }

        if (error.equals("")) {
            userService.save(user);

            securityService.autologin(user.getEmail(), user.getPasswordConfirm());
            return new ResponseEntity<User>(user, HttpStatus.OK);
        }

        return new ResponseEntity<User>(user, HttpStatus.CONFLICT);
    }

   
}
