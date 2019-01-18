/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dwa.Ecovoit.Model.User;

import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.Data;

/**
 *
 * @author fdr
 */
@Data
@Entity
public class Business {
     @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
      private Long id;
     private User boss;
       private String name;
       private String address;
       private String fieldOfActivity;
       private String description;
       private String siret;
       private int cancelAppointment;
       private List<MyCalendar> calendar;
}
