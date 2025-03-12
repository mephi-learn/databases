use svedb04;

with recursive emp as (
	select EmployeeID, ManagerID
	from Employees
	where Name = 'Иван Иванов'
	union all
	select e.EmployeeID, e.ManagerID
	from Employees e
	inner join emp on emp.EmployeeID = e.ManagerID
)
select e.EmployeeID, e.Name EmployeeName, e.ManagerID, d.DepartmentName , r.RoleName, group_concat(distinct p.ProjectName separator ', ') ProjectNames, group_concat(distinct t.TaskName separator ', ') TaskNames
from emp inner join Employees e on e.EmployeeID = emp.EmployeeID
	inner join Departments d on e.DepartmentID = d.DepartmentID
	inner join Roles r on e.RoleID = r.RoleID
	left join Tasks t on e.EmployeeID = t.AssignedTo
	left join Projects p on d.DepartmentID = p.DepartmentID
group by e.EmployeeID, e.Name, e.ManagerID, d.DepartmentName , r.RoleName
order by e.Name
;
