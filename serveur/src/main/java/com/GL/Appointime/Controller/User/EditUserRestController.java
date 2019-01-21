/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.GL.Appointime.Controller.User;


import com.GL.Appointime.Model.User.Service.SecurityService;
import com.GL.Appointime.Model.User.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
