/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.GL.Appointime.Model.User;

import java.util.Date;
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
public class MyCalendar {
      @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
      private Long id;
      private int halfDay;
      private Date openingTimme;
      private Date closingTimme;
      private boolean open;
}
