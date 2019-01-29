/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pingouin.appointime.Model;

import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import lombok.Data;
import pingouin.appointime.Model.User.User;

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
     @OneToOne 
     private User boss;
       private String name;
       private String address;
       private String fieldOfActivity;
       private String description;
       private String siret;
       private int cancelAppointment;
       @ManyToMany
       private List<MyCalendar> calendar;
}
