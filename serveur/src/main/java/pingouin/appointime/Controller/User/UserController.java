/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pingouin.appointime.Controller.User;


import pingouin.appointime.Model.User.Service.SecurityService;
import pingouin.appointime.Model.User.Service.UserService;
import pingouin.appointime.Model.User.User;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author gentile
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

    @RequestMapping(value = "/login")
    String loginForm(Model mod) {
        mod.addAttribute("user", new User());
        return "connect";
    }

    /**
     * loginCheck called with /loginCheck request Used to check connexion
     *
     * @param user : user to log
     * @return Home page if success, login if not
     */
    @PostMapping("/loginCheck")
    String loginCheck(@Valid User user, BindingResult bindingResult) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        User userToLog = userService.findByEmail(user.getEmail());
        if (user == null) {
            return "connect";
        }
        if (userToLog == null) {
            bindingResult.addError(new ObjectError("userRefu", "Pseudo incorrect"));
        } else if (!passwordEncoder.matches(user.getPassword(), userToLog.getPassword())) {
            bindingResult.addError(new ObjectError("conRefuse", "mot de passe incorrect"));

        }

        if (bindingResult.hasErrors()) {

            return "connect";
        }
        securityService.autologin(user.getEmail(), user.getPassword());
        return "redirect:/home";
    }

    /**
     * registration called with /registration request Used to show register form
     *
     * @return register template with empty user as attribute
     */
    @RequestMapping("/registration")
    public String registration(Model model) {
        model.addAttribute("user", new User());

        return "register";
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
    @PostMapping("/registration")
    String SubmitRegistration(@Valid User user, BindingResult bindingResult, Model mod) {
        if (userService.findByEmail(user.getEmail()) != null) {

            bindingResult.addError(new ObjectError("emailExist", "Email déjà utilisé"));

        }
        if (userService.findByEmail(user.getEmail()) != null) {

            bindingResult.addError(new ObjectError("userExist", "Pseudo déjà utilisé"));

        }

        if (!user.getPassword().equals(user.getPasswordConfirm())) {
            bindingResult.addError(new ObjectError("passDif", "Les mot de passe sont différents"));
        }

        if (!bindingResult.hasErrors()) {
            userService.save(user);

            securityService.autologin(user.getEmail(), user.getPasswordConfirm());
            return "redirect:/home";
        }

        return "register";
    }

}
