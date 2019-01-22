package pingouin.appointime.Model.Repositories;

import pingouin.appointime.Model.MyCalendar;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MyCalendarRepository extends JpaRepository<MyCalendar, Long> {
}
