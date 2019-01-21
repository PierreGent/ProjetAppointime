/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.GL.Appointime.Model.User;

import java.util.Date;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import lombok.Data;

/**
 *
 * @author fdr
 */
@Data
@Entity
public class Appointment {
     @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
     private Long id;
     private Date startingTime;
     private Date endingTime;
     @ManyToOne
     private User customer;
     @ManyToOne
     private Favor favor;
}
