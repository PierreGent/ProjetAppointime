package pingouin.appointime.Model.Repositories;

import pingouin.appointime.Model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
}
