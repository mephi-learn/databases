use svedb04;

with recursive emp as (
	select e.EmployeeID, e. ManagerID, coalesce(t.child, 0) child
	from Employees e left join (select ManagerID, count(*) child from Employees group by ManagerID) t on e.EmployeeID = t.ManagerID
	where Name = 'Иван Иванов'
	union all
	select e.EmployeeID, e.ManagerID, coalesce(t.child, 0) child
	from Employees e
	inner join emp on emp.EmployeeID = e.ManagerID
	left join (select ManagerID, count(*) child from Employees group by ManagerID) t on e.EmployeeID = t.ManagerID
)
select EmployeeID, EmployeeName, ManagerID, DepartmentName, RoleName, group_concat(distinct ProjectName separator ', ') ProjectNames, group_concat(distinct TaskName separator ', ') TaskNames, child TotalSubordinates
from (
	select e.EmployeeID, e.Name EmployeeName, e.ManagerID, d.DepartmentName , r.RoleName, p.ProjectName, t.TaskName, emp.child 
		,count(t.TaskName) over (partition by EmployeeID) TotalTasks
	from emp inner join Employees e on e.EmployeeID = emp.EmployeeID
		inner join Departments d on e.DepartmentID = d.DepartmentID
		inner join Roles r on e.RoleID = r.RoleID
		left join Tasks t on e.EmployeeID = t.AssignedTo
		left join Projects p on d.DepartmentID = p.DepartmentID
	where r.RoleName = 'Менеджер' and child > 0
) t
group by EmployeeID, EmployeeName, ManagerID, DepartmentName , RoleName, child
order by EmployeeName
;
