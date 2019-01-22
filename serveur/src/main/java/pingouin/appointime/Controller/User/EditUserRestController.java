/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pingouin.appointime.Controller.User;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pingouin.appointime.Model.User.User;
import pingouin.appointime.Model.User.Service.SecurityService;

/**
 *
 * @author fdr
 */
@RestController
public class EditUserRestController {

    @Autowired
    private SecurityService securityService;

    @RequestMapping("/myAccount")
    public User myAccount() {

        return securityService.findLoggedInUser();
    }
}
