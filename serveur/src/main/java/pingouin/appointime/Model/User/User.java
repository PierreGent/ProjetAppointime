package pingouin.appointime.Model.User;

import java.util.Objects;
import java.util.Set;
import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;
import lombok.Data;

@Data
@Entity
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String firstName;
    private String lastName;
    private String adress;
    @Column(name = "email", unique = true)
    private String email;
    private String password;
    private String phoneNumber;
    @Transient
    @Size(min = 5, max = 30, message = "La confirmation de mot de passe doit contenir entre 5 et 30 caractères")
    private String passwordConfirm;
    @ManyToMany
    @JoinTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles;
    private int credit;
    private boolean isPro;
public boolean equals(User user){
    return user.getId().equals(this.id);
}
    public String toString() {
        return this.getLastName()+" "+this.getFirstName();
    }

}
