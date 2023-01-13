Database.JobGrades = {}

function Database.JobGrades.GetByJobName(name)
    return MySQL.query.await("SELECT grade,name,label FROM job_grades WHERE job_name = ?", {name})
end
